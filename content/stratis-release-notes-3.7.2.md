+++
title = "Stratis 3.7.2 Release Notes"
date = 2024-10-16
weight = 39
template = "page.html"
render = true
+++

*mulhern, Stratis Team*

Stratis 3.7.2, which consists of `stratisd 3.7.2` and `stratis-cli 3.7.0`
includes one significant enhancement, several minor enhancements, and a
number of small improvements.

Most significantly, Stratis 3.7.2 extends its functionality to allow a user
to revert a snapshot, i.e., to overwrite a Stratis filesystem with a
previously taken snapshot of that filesystem. The process of reverting  
requires two steps. First, a snapshot must be scheduled for revert. However,
the revert can only take place when a pool is started. This can be done
while `stratisd` is running, by stopping and then restarting the pool. A
revert may also be occasioned by a reboot of the system `stratisd` is running
on. Restarting `stratisd` will also cause a scheduled revert to occur, 
so long as the pool containing the filesystem to be reverted has already
been stopped. To support this functionality, `stratis-cli` includes
two new filesystem subcommands, `schedule-revert` and `cancel-revert`.

Some additional functionality has been added to support this revert 
functionality. First, a filesystem's origin field is now included
among its D-Bus properties and updated as appropriate. `stratis-cli`
displays an origin value in its newly introduced filesystem detail view.
`stratisd` also support a new filesystem  D-Bus method which returns the
filesystem metadata. The filesystem debug commands in `stratis-cli` now
include a `get-metadata` option which will display the filesystem metadata
for a given pool or filesystem. Equivalent functionality has been
introduced for the pool metadata as well.

`stratisd` also includes a considerable number of dependency version bumps,
minor fixes and additional testing, while `stratis-cli` includes
improvements to its command-line parsing implementation.

<!-- more -->

Please consult the [stratisd] and [stratis-cli] changelogs for additional
information about the release.

[stratisd]: https://github.com/stratis-storage/stratisd/blob/rebase-3.6.0/CHANGES.txt 
[stratis-cli]: https://github.com/stratis-storage/stratis-cli/blob/rebase-3.6.0/CHANGES.txt
