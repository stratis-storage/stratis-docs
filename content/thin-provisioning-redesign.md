+++
title = "Thin provisioning redesign"
date = 2022-05-18
weight = 25
template = "page.html"
render = true
+++

*John Baublitz, Stratis Team*

Overview
========
For a while, we've bumped into a number of problems with our thin provisioning implementation
around reliability and safety for users. After gathering a lot of feedback on our thin
provisioning layer, we put together [a proposal] for improvements to how we currently handle
allocations.

The changes can largely be divided up into three areas of improvement:
* Predictability
* Safety
* Reliability

<!-- more -->

Predictability
==============
We made two notable changes to make behavior in the thin provisioning layer well-defined and
predictable for users. Both parts relate to an existing thin provisioning tool,
`thin_metadata_size`. This tool allows users to calculate the amount of metadata needed for
a thin pool with a given size and number of thin devices (filesystems and snapshots in the
case of stratisd). We have started taking advantage of `thin_metadata_size` to make our
metadata space reservation more precise. Instead of our previous approach of allocating
a fixed fraction of the available space, we now calculate the exact amount of space required for
a given pool size and number of filesystems and snapshots. The second change is a switch
to lazy allocation. Previously, we allocated greedily which meant that every time a device
was added, we would allocate a certain amount of space for data and metadata regardless of
the individual user's requirements. We now delay allocation and allocate block device storage
on an as-needed basis allowing users to develop different requirements and adjust accordingly.
For example, a user may realize that they need more filesystems than they originally planned for.
With lazy allocation, assuming there is unallocated space on the pool, the user can now redirect
that unallocated space from data to metadata space so there is enough room for a greater
number of filesystems than was originally anticipated.

This change resulted in two API modifications. One is filesystem limits; to appropriately
ensure that we never exceed the allocated metadata limit, we set a filesystem limit per
pool. This limit can be increased through the API, triggering a new allocation for
metadata space. The other API change is related to the switch to lazy allocation. There
is now information available that reports the amount of space that has been allocated.
Previously we only concerned ourselves with used and total space, but with lazy allocation,
it is now also important to report space that has been allocated but may not be in use yet.

Safety
======
A key drawback of thin provisioning is often the failure cases. When overprovisioning a
storage stack, the stack can get into a bad state when the pool becomes full due to the
filesystem being far larger than the pool backing it. We have added in two safety features
to help users cope with this.

One measure is the addition of a mode to disable overprovisioning. This ensures that the size
of all filesystems on the pool does not exceed the available physical storage provided by the
pool. This feature is not necessarily useful for all users, particularly with heavy snapshot
usage because even if storage is shared between a snapshot and a filesystem, this mode will
treat them as entirely independent entities in terms of storage cost. This ensures that copy-
on-write operations will not accidentally fill the pool if the shared storage diverges between
the two, but puts a rather strict limit on snapshot capacity. For users that use Stratis for
critical applications or the root filesystem, this mode prevents certain failure cases that
can be challenging to recover from.

When overprovisioning is enabled, we have also introduced a new API signal to notify the user
when physical storage has been fully allocated. This does not necessarily mean that the pool
has run out of space but serves as a warning to the user that once the remaining free space
fills up, Stratis has no space left to extend to. This gives users time to provide more storage
from which to allocate space before reaching a failure case.

Reliability
===========
For a while, we've gotten bug reports about the reliability of filesystem extension. In certain
cases, Stratis was not able to handle filesystem extension smoothly or at all. Between the
[per-pool locking] and the thin provisioning redesign, we have now resolved some of the
previous issues with filesystem extension. The approach we've taken attacks the problem from
a few different angles.

Earlier filesystem extension
----------------------------
Stratis used to wait until several gigabytes were left to extend the filesystem. If Stratis didn't
resize the filesystem quickly enough, the filesystem would run out of space before the extension
could complete. While this would eventually resolve itself once the filesystem was extended,
it would cause some unnecessary IO errors. We now extend the filesystem at 50% usage
to ensure that users always have a large buffer of free space available for even very IO-heavy
usage patterns.

Parallelized filesystem extension operations
--------------------------------------------
Stratis could previously only iterate sequentially through pools. Now stratisd can handle filesystem
extension on two separate pools in parallel, reducing the latency between the point where
high usage is detected and the extension operation being performed.

Periodic checks for filesystem usage
------------------------------------
Checking filesystem usage used to be a devicemapper event-dependent operation. This led to
some problems around filesystem extension. A devicemapper event would be generated periodically
as the filesystem filled up, but if the filesystem failed to extend a few times,
devicemapper events would no longer be generated once the pool filled up and users would be
left with a filesystem that couldn't be extended. We've removed our dependency on devicemapper
events for filesystem monitoring and use devicemapper events for pool handling exclusively.
Instead, we run periodic checks in the background on filesystems to ensure that even if
filesystem extension fails multiple times, once the filesystem is ready to be extended,
stratisd can perform the operation in the background, so that we don't leave users in a state
where their filesystem can't be extended.

Migration and backwards compatibility
=====================================
There are two types of changes that require migrations from older versions of stratisd: 
metadata changes and allocation scheme changes.

Metadata changes
----------------
The changes we made required some schema changes in our MDA, the metadata region outside of
the superblock that records longer form JSON about the specifics of the pool topology. The
migration should be invisible to the user and will be performed the first time the new
version of stratisd detects legacy pools. The migration adds some additional devicemapper
information, information about filesystem limits on a pool, and other bookkeeping information.

Allocation scheme changes
-------------------------
As mentioned above, the previous metadata allocation scheme was less precise and allocated
a larger segment for metadata space than was necessary for the amount of data space present.
Migration for old pools will cause stratisd to detect that the metadata device is already larger
than it needs to be and no additional metadata device growth will occur until the data device
size becomes large enough to require additional metadata space.

Future work
===========
We hope to eventually provide some smarter allocation strategies for our data and metadata
allocations to maximize contiguous allocation extents.

[a proposal]: https://github.com/stratis-storage/stratisd/issues/2814
[per-pool locking]: @/per-pool-locking.md
