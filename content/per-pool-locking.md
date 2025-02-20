+++
title = "Addition of per-pool locking"
date = 2022-01-06
weight = 22
template = "page.html"
render = true
+++

*John Baublitz, Stratis Team*

Overview
========
Recently, we've merged a PR that completes our work on improved concurrency in
stratisd.  Previously, we had made some changes to the IPC layer to provide the
ability for stratisd to handle incoming requests in parallel which you can read
about [here]. This work allowed IPC requests to each be handled
in a separate [tokio task], but the Stratis engine, the part of our code that
handles all of the storage stack operations, could still only be accessed
sequentially.

<!-- more -->

Motivation
==========
After having conversations with the LVM team, it seemed like sequential accesses
of storage operations was not entirely necessary. While modifying multiple layers
of the pool stack at once can cause problems, modifying independent pools in
parallel is safe, and we wanted to take advantage of the potential for increased
concurrency. A large part of this is due to how we handle D-Bus properties. Our
D-Bus properties expose aspects of the storage stack that sometimes require
querying the device-mapper stack for information. With sequential accesses,
this would mean that even two list operations on any two pools could not run in
parallel, a restriction that causes a bad user experience and is not technically
necessary.

Requirements
============
Despite the motivation being clear, the solution turned out to be more complicated.
One of the major problems that we bumped into when trying to achieve more granular
concurrency was the interaction between standard Rust synchronization structures
and the API for listing D-Bus objects.

Our initial idea was to wrap the data structure containing the record of all of
the pools in a read-write lock. This had a few notable drawbacks. For one, you
could not acquire mutable access to two independent pools at a time even though
this is a completely safe operation.

This led us to the idea of wrapping each pool in a read-write lock. Unfortunately,
this also had some major drawbacks. One notable example of this was the behavior of
our list operation with this solution. A list operation would require a read lock
on every single pool and this means that the time that it would take to list all of
the pools or filesystems would increase proportionally with the number of pools
on the system. Because locking is relatively expensive, we noticed a significant
slowdown when listing larger numbers of pools and filesystems.

Our ideal scenario was to have the benefits of a read-write lock so that list
operations could run in parallel but to provide an ability to either lock single
pools or all pools in one operation so that locking all pools would take the
same amount of time no matter how many were present on the system.

Design
======
After determining that no locking data structure like this appeared to exist
in tokio, we took some time to look into how tokio implements its locking data
structures. The API for much of the locking data structures appeared to
be a lock acquisition method that returned a future. This future would poll the state
of the lock and either update the internal data structures to indicate that
the lock had been acquired or put itself to sleep until it was ready to poll
again. The `drop` method on the data structure returned by the future would
trigger waking up a task to poll again. This seemed perfectly workable with
a more granular read-write lock. The only difference would be that we would
need to keep track of locks on individual pools as well as locks on the entire
collection. The proper locking conflict rules would need to be checked:

* `WriteAll` conflicts with all other operations.
* `ReadAll` conflicts with `WriteAll` and `Write` on any pool.
* `Write` conflicts with `WriteAll` and `Read` or `Write` on the same pool.
* `Read` conflicts with `WriteAll` and `Write` on the same pool.

Any attempt to acquire two conflicting locks would queue one of the tasks to
be woken up once the conflicting lock was dropped.

Notable design choices
======================
We chose to implement our lock as a starvation-free lock. Implementing a lock
that allows `ReadAll` to bypass `Write*` requests that are queued when another
`ReadAll` request has already acquired the lock leads to behavior where `Write*`
requests could block indefinitely. This behavior could cause list operations to
block filesystem extension handling indefinitely, potentially leading to IO errors
and a full filesystem. A starvation-free locking approach puts a task in a FIFO
queue if any are already queued in front of it. The notable downside of this is
slightly more latency for handling locking requests, but the benefits seemed to
outweigh this.

Because tokio can cause spurious wake ups for tasks, we assign a unique integer
ID to each future responsible for polling the lock for readiness. In the case
where there is both a legitimate and spurious wake up at the same time, this
allows our lock to differentiate between the two woken tasks to determine which
one should be given priority and which should be put to sleep. This prevents
spurious wake ups from acquiring the lock before they are scheduled to.

Because tokio does not currently allow lifetimes shorter than `'static` when
passing a reference across thread boundaries, our locking data structure
heavily uses automatic reference counting (`Arc`). This enables shared access
between multiple threads and the ability to pass an acquired lock handle to
a separate thread after acquisition. Without the use of `Arc`, the pool would
have to be operated on in the same task as the lock acquisition which would
prevent passing lock handles to separate tasks to process them in parallel.

Optimizations
=============
After our initial implementation of the write-all lock, we bumped into an issue
where we could not pass all pool lock handles into separate threads to handle
them all in parallel. This was particularly problematic for our implementation
of background devicemapper event handling. Our solution for this was to allow
acquiring all locks at once to avoid the penalty of locking each pool individually
and then converting that lock handle to a set of individual locks that can all
be released when they are no longer needed. This addressed both the issue of
parallelization and constant time locking for all pools nicely.

Originally we also only woke one queued task at a time when a lock was released.
This proved to be less performant. If two `ReadAll` tasks were queued, these could
both be woken up in parallel and acquire the lock with no conflict. The solution
to this was to factor out the part of the code that tests for conflicts and traverse
the queue and wake up all tasks until a conflicting task is found. This allowed
waking up a batch of queued tasks that could all operate in parallel without
also waking up a conflicting task that would immediately be put back to sleep.

Future work
===========
Recently, we discovered that we should be able to provide even more
parallelization for filesystem background operations. While we cannot perform
multiple pool mutation operations in parallel, the filesystems on top of the
pool can be modified independently in parallel. We expect to change the way
background checks on filesystem usage are handled by spawning each filesystem
extension in its own tokio task so that, for pools with many filesystems, the
filesystem extension will be more responsive. Rather than iterating through
hundreds of filesystems, stratisd will be able to handle multiple filesystem
extensions in parallel, speeding up the checking process if there is more than
one filesystem that needs to be extended at once. This will benefit IO performance
by ensuring that the filesystems are extended in a timely manner to avoid cases
where the filesystem is filled before it can be extended.

Final notes
===========
We've added extensive debugging for the locking data structure in case users run
into issues. To enable these logs and see the state of the per-pool locking data
structure over time, simply enable trace logs in stratisd!

[here]: @/multi-threading.md
[tokio task]: https://tokio.rs/tokio/tutorial/spawning
