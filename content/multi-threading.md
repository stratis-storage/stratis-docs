+++
title = "Multi-threading Support in stratisd"
date =
weight =
template = "page.html"
render = true
+++

Introducing Support for Multi-threading in stratisd
===================================================
`stratisd` is an entirely single-threaded application;
it is a daemon with a single event loop that consults a list of possible
event sources in a prescribed order, handling the events on each event
source before proceeding to the next.
The event sources are udev, device-mapper, and D-Bus events which are
handled in that order. `stratisd` can also be terminated cleanly by an
interrupt signal, which it checks for on every loop iteration.

Because `stratisd` is single threaded, every action taken by `stratisd` must be
completed before another action is performed. For example, if a client issues
a D-Bus message to create a filesystem, that command will be processed, the
engine will create a filesystem, and a response will be transmitted on the
D-Bus before any other action can be taken. If another D-Bus message is
received before the first is completed, that D-Bus message will then be
processed.  The engine will continue to process D-Bus messages until none are
left, preventing it from handling any other categories of signals or
events while any D-Bus messages remain.

For this reason, `stratisd` itself can not parallelize long-running
operations. It is well known that, for example, filesystem creation can be
time consuming, as it is necessary to write the filesystem metadata when
creating the filesystem. Ideally, `stratisd` would be able to run such time
consuming operations in parallel, initiating one operation and then
proceeding to initiate another before the first operation completes.

Additionally, as in the example above, if `stratisd` is continually receiving
D-Bus messages, it will not proceed to deal with a device-mapper event,
even if the device-mapper event is urgent and not in any conflict with the
D-Bus messages, for example, if it is associated with a different pool than
any D-Bus messages.

For these reasons, the next release introduces multi-threading capabilities
into `stratisd`. These capabilities do not solve all the problems that multi-
threading is intended to solve, but lay the essential foundation for multi-
threaded event handling.

We have chosen to implement multi-threading using the Rust [tokio] crate.
The alternative is to use operating system threads explicitly via the
Rust standard library [thread] module. We have chosen `tokio` in order to
get the benefits of code reuse from the `tokio` runtime, and because we
expect that this choice will allow `stratisd` to operate efficiently while
consuming fewer operating system resources.

We have also made use of the newest version of the [dbus] crate, which
includes support for multi-threading via the [dbus-tokio] crate.

Nomenclature
============
The following words have a precise definition in the context of
multi-threading:
* object - an instance of a Rust struct and the methods implemented for it.
* task - A task is a program which has been designed so that it can
be run concurrently  with its fellow tasks. The multi-threaded incarnation
of `stratisd` consists of a set of tasks, some code to facilitate interactions
between the tasks, and the `tokio` runtime.
* context - the context of a process is all the information required to
begin running the process when it resumes after having been suspended by the
operating system scheduler. A context switch is the action of storing this
information for the process being suspended and loading the information for
the process being resumed.
* thread - a thread is a sub-division of a process. When an operating system
switches processes, a context switch is required. When an operating
system switches threads, the new thread shares much of its process' context
with the previous thread. Consequently, switching between threads, as opposed
to processes, may be an order of magnitude less expensive. All threads
belonging to a process share the same memory and may communicate via this
shared memory.
* runtime - the `tokio` runtime manages scheduling of tasks.
* block - a task is said to block on an operation if the task must wait
for the operation to complete and is not able to be replaced in the same
thread by another task until the operation is completed. Examples of typical
operations are I/O or network interactions. Another sort of operation is
the acquisition of a shared resource via a mutex or other synchronization
primitive.
* blocking - a blocking task is a task that may block.
* non-blocking - a non-blocking task is a task that does not need to wait
for any operation to complete; if it initiates an operation that may take
a while to complete, it is able to yield to another task, and may be resumed
later from the instruction where it yielded.
* mutex - a synchronization primitive which enforces mutual exclusion. With
`tokio` the exclusion is enforced on a particular object. If a task obtains
a mutex, it has exclusive use of the object until it releases the mutex.  If
a mutex is already held by another task, a task requesting the mutex may
block or it may yield until the mutex can be obtained.
* read/write lock - a mutex which is relaxed in so far as that it allows
multiple tasks to share an object if none mutate the object. If a task
mutates the object then it must obtain exclusive possession of the mutex.
* lock - to enter a mutex guarding an object is synonymous with locking
an object.

Design
======
`stratisd` divides its work among a number of tasks which handle
different event sources. Some tasks are non-blocking, others are blocking
tasks. Non-blocking tasks may yield, and can share a single thread with
other non-blocking tasks. The tasks communicate using two unbounded MPSC
(Multi-Producer Single-Consumer) channels; a channel for udev events and
a channel for D-Bus updates.

Termination Variable
--------------------
One boolean variable, `should_exit`, is shared among some of the tasks.
It is set to true only if SIGINT is detected. It is observed only by the
udev task, which checks its value on every iteration of its loop, and
immediately returns if the value is `true`. For all other tasks, termination
is handled by `tokio` constructs. The udev task requires special handling
because it does not yield and because it contains a non-terminating loop.

The dbus `tree`
--------------
The dbus tree is a data structure which contains the state of the D-Bus
layers. Access to the dbus tree is controlled by a read/write lock.

The stratisd engine
-------------------
The `stratisd` engine is the core of the `stratisd` daemon. It manages all the
essentially functionality of `stratisd`. Access to the engine is controlled
by a mutex.

The dbus channel
----------------
The dbus channel is an unbounded multi-producer, single-consumer channel.
It carries messages instructing the DbusTreeHandler how to update the dbus
tree. The DbusTreeHandler task is the unique consumer of the messages.
The DbusConnectionHandler, which processes D-Bus messages sent by the client,
and the DbusUdevhandler, which handles udev events, may both place messages
on the dbus channel.

The udev channel
----------------
The udev channel is an unbounded multi-producer, single-consumer channel.
It carries messages about udev events to the DbusUdevHandler. There is
only one producer for this channel, the udev event handling task,
which monitors udev events and places those events on the channel.

signal handling task
--------------------
The signal handling task is a non-blocking task which waits for SIGINT. If
it receives the signal it sets `should_exit` to true and finishes.

device-mapper event task
------------------------
The device-mapper event task loops forever waiting for a device-mapper event.
On receipt of any event, it locks the `stratisd` engine, and processes the
event. It yields only when waiting for a new device-mapper event, it blocks
on the engine mutex.

udev event handling task
------------------------
The udev event handling task uses a polling mechanism to detect udev events.
If a udev event is detected it places a message on the `stratisd` udev channel.
It reads `should_exit` after every udev event or, if no udev event has
occurred, after a designated time interval. If  `should_exit` is `true` when
read it returns immediately.

D-Bus Tasks
-----------
The management of the D-Bus layer is handled by several cooperating tasks.
The dbus crate supplies one task, which detects D-Bus messages and places
them on its own unbounded channel. The `stratisd` tasks are the
DbusTreeHandler task, the DbusConnectionHandler task, and the
DbusUdevHandler task.

DbusTreeHandler task
---------------------
`stratisd` defines a DbusTreehandler task which updates the dbus tree and
may also handle emitting D-Bus signals. It is the unique receiver on
the `stratisd` dbus channel and the only task which obtains a write lock
on the dbus tree. It is a non-blocking task.

DbusConnectionHandler task
--------------------------
`stratisd` defines a DbusConnectionHandler task which spawns a
new task for every D-Bus method call. Each spawned task obtains a read
lock on the dbus tree before it begins to process the D-Bus method call,
and may also lock the engine. If it locks the engine, it blocks on the lock.
Each spawned task may place messages on the `stratisd` dbus channel. Each
task is responsible for sending replies to its D-Bus message on the D-Bus.
This is the only part of the implementation where new tasks can be spawned
during `stratisd`'s regular operation.

DbusUdevHandler task
--------------------
`stratisd` defines a DbusUdevHandler task which removes udev event information
from the `stratisd` udev channel, allows the engine to process it, and puts
any messages that may be necessary as a result of the engine processing the
udev event on the `stratisd` dbus channel. Currently, a udev event may result in
a pool being set up; when that happens an add message must be placed on the
dbus channel for every filesystem or block device belonging to the pool,
as well as an add message for the pool itself. The DbusUdevHandler locks
the engine when processing a udev event, but does not block on the lock.


Properties and Consequences
===========================

Unbounded Channels
----------------
Both the `stratisd` udev channel and the dbus channel are "unbounded channels".
These "unbounded" channels are actually bounded, but the bound on the number
of messages allowed on the channel is the maximum value of the Rust usize type.
It is assumed that other machine limits will be encountered before the number
of messages on the channel reaches that limit. Because both channels are
unbounded, tasks do not block placing a message on the channel, sending
always succeeds.

We chose to make the dbus channel unbounded, as there exist two situations
where a large number of messages may be placed on the channel. When a pool
is constructed, the number of messages placed on the channel is proportional
to the number of devices in the pool. On startup, when `stratisd` sets up
a pool from its constituent devices, the number of messages is proportional
to the number of devices and to the number of filesystems that the pool
supports. We prefer to use an unbounded channel rather than to bound the
number of filesystems by the channel size.

Generally speaking, we expect the number of messages on the channel, except
on the occasion of pool creation or setup, to be no greater than 1; no other
action currently implemented requires more than one message to be sent to the
DbusTreeHandler. Messages will be rapidly consumed by the DbusTreeHandler, as
it is the only task that takes a write lock on the dbus tree, and a task
waiting for a write lock takes precedence over one waiting for a read lock.

The choice of unbounded channels also eliminates one possible source of
deadlock.

Bounded Number of Blocking Threads
----------------------------------
We have accepted, at this time, the tokio default for the number of blocking
threads, which is 512. Because the DbusConnectionHandler's generated tasks
are blocking, this places an upper bound on the number of
distinct D-Bus messages that can be handled concurrently. Note that it
is quite possible for 512 D-Bus messages to be handled by just one thread,
as each task may be run in sequence on a single thread if the tasks complete
rapidly.

We do not believe that this restriction will prove important in practice.
The dbus crate's message channel is unbounded, so D-Bus messages can not be
dropped although they may be handled very slowly if there is a backlog.
Depending on the client's configuration, this may cause the client to hang
indefinitely waiting for a response or the client may receive a message
indicating that no response was transmitted in the allotted time. However,
this situation can only arise if many messages require long-running actions
to be taken and if these messages are sent in parallel.

In any case, the improvement with respect to a single-threaded approach is
obvious. In the existing single threaded design, `stratisd` would be
unable to handle any other events until all the D-Bus messages had been
handled. With the multi-threaded design, udev and device-mapper events can
be handled when they arrive, interspersed with the handling of the D-Bus
messages.

One Task per D-Bus Message Model
--------------------------------
In the single-threaded design, every D-Bus message is handled completely
before handling of the next D-Bus message is begun. In our multi-threaded
design multiple D-Bus message handling tasks may be being processed at the same
time if the `tokio` scheduler allocates two message handling tasks to separate
threads.

Each such task must:
1. Acquire a read lock on the dbus tree.
2. Query the tree in order to find the necessary information to call the engine
method.
3. Enter a mutex on the `stratisd` engine.
4. Operate on the `stratisd` engine.
5. Place any required messages on the dbus channel.
6. Exit the mutex.
7. Relinquish the read lock.

While processing of each message will be started precisely in the sequence
in which the messages arrive, the order in which messages complete may not
be the same, because a later task may enter the engine mutex before an earlier
task.

The motivation for this design is obvious, although the benefits are not
yet realized in this preliminary multi-threading implementation. In future,
we expect to relax the requirement that each task have exclusive access to
the entire engine and lock only the relevant parts of the engine. With that
extension two non-interfering D-Bus commands may be run separately. The
same general advantage from this proposed enhancement will also be gained
in the matter of, for example, handling device-mapper events while
simultaneously handling a D-Bus method.

This change introduces a relaxation of certain properties that held in
the single-threaded case.

1. If a D-Bus method that mutates state and requires an update to the
dbus tree is invoked the changes to the dbus tree resulting from that method
call are not visible until some time after the call has returned as updates
to the dbus tree can only occur after the method has completed. This can
be observed by a client, if the client invokes a second method immediately
after the first has returned. For example, if the client invokes the CreatePool
method and then immediately invokes the GetManagedObjects() method, some
pool object paths corresponding to the pool or its devices may not yet
be present in the tree. The opposite behavior can also be observed, for
example, if the client invokes the DestroyPool method, some object paths
belonging to the destroyed pool may still be found by a GetManagedObjects()
invocation.

2. If two D-Bus methods are invoked in separate processes, the same behaviors
described in (1) are somewhat easier to observe.

3. We believe that we have made it impossible to incorrectly update the
tree by returning rich result types from the engine methods.

Given two distinct mutating D-Bus methods running in separate threads
there is a possibility of a situation rather analogous to a race-condition
arising. Two tasks may read the dbus tree, update the internal engine state,
and then send update messages on the dbus channel. It is uncertain which
task will acquire the engine mutex. This is
partially analogous to the classic race-condition where two processes read a
single variable, and then both update that variable in an undetermined order.

What makes this analogy only partial is the interposition of the engine,
which restricts the updates that may be requested of the DbusTreeHandler by
the DbusRequestHandler. The engine methods invoked by the D-Bus layer return
a result which sufficiently distinguishes the actions actually taken by
the engine so that conflicting updates to the dbus tree can not be
requested. Thus the updates are constrained to be correct.

For example, consider that two conflicting commands may be handled at the
same time: one command to delete a filesystem and the other to rename
the same filesystem. If both commands are being handled in separate threads
each will read the same data based on the filesystem object. Then, either
one may enter the engine mutex. If the rename task enters the mutex first,
it will be the first to place a message on the dbus channel. The DbusTreeHandler
will remove the rename message first and then the remove message placed
on the dbus channel after the remove request completes. Clearly,
this order of processing can not result in an error. With the other order,
the remove message will be placed on the dbus channel before the rename
occurs. But in this case, the engine method will return a result indicating
that no rename could occur, because the filesystem could not be found.
Consequently, no rename message will be put on the dbus channel, and so the
DbusTreeHandler will receive the remove message only. Thus, no incorrect
update is performed on the dbus tree.

Error Behavior
--------------
`stratisd` exits immediately if any task encounters an error.

Ensuring a Clean and Prompt Exit
--------------------------------
On SIGINT, `stratisd` should exit promptly and cleanly. This is ensured by:
1. Having a separate signal handling task that waits on SIGINT. The tokio
scheduler will ensure that this task is run regularly; thus the signal
can not be ignored. Note that in the single-threaded case it is possible
for the signal handling code never to be reached.
2. Causing asynchronous tasks to terminate at their next synchronization point
 when the signal handling task terminates.
3. Having the udev event handling loop check the flag set by the signal
handling task on every iteration, and terminate if the flag
is true.
4. Each distinct D-Bus method processing task is allowed to run to completion,
so that every action that it has begun can be completed.

Statistics
==========
Using `tokio` increases the size of the `stratisd` executable by about 1 MiB,
which at `stratisd`'s current size is an increase of approximately 20%.

Remarks
=======
Preliminary multi-threading support will be included in the next `stratisd`
release, 2.4.0.

<!-- more -->

[tokio] https://tokio.rs/
[thread] https://doc.rust-lang.org/std/thread/
[dbus] https://crates.io/crates/dbus
[dbus-tokio] https://crates.io/crates/dbus-tokio/
