+++
title = "Stratis 2.4.0 Release Notes"
date = 2021-04-21
weight = 17
template = "page.html"
render = true
+++

*mulhern, Stratis Team*

Stratis 2.4.0 includes two major user-visible changes:
* All the functionality required to boot from a Stratis-managed root
filesystem. See the prior post [Stratis filesystems as the root filesystem]
for a more detailed discussion.
* An enhancement to existing encryption support that allows the user to
create a pool with encryption managed either by the kernel keyring or
[Clevis], and to subsequently bind an already encrypted pool using either
mechanism. Previously, the user could create an encrypted pool using the
kernel keyring only, and could bind or unbind using Clevis only.

<!-- more -->

More minor user-visible changes are:
* An enhancement to the FetchProperties D-Bus interface in order to disclose
more information about sets of encrypted devices.
* The `engine_state_report` key in the report interface has been stabilized
and is guaranteed to be supported in future releases.
* A new executable, `stratis-predict-usage` to predict free space on a newly
created pool is distributed with stratisd.

This release of Stratis also includes a number of significant but less
visible changes:
* Support for multi-threading in stratisd. The new multi-threading
implementation replaces the prior event-loop implementation. See the prior
post [Multi-threading Support in stratisd] for a detailed discussion.
* The management of Stratis filesystem symlinks has been simplified.
Determining the filesystem and pool name that comprise the symlink path no
longer requires communication with stratisd over the D-Bus; it is
now accomplished via standard udev-based mechanisms.
* stratisd now emits a log message at the info level in connection with every
mutating D-Bus method call that it completes without an error.

The support for migrating symlinks introduced in Stratis 2.2.0 is no longer
included in this release.

The ongoing and perpetual but entirely routine work of improvements to
individual log and error messages continues.

Please consult the [stratisd] and [stratis] changelogs for additional
information about the 2.4.0 release.

We would like to thank our external contributor carzacc for continued work
on bash tab-completion.

[Clevis]: https://github.com/latchset/clevis
[Stratis filesystems as the root filesystem]: https://stratis-storage.github.io/stratis-rootfs/
[Multi-threading Support in stratisd]: https://stratis-storage.github.io/multi-threading/
[stratisd]: https://github.com/stratis-storage/stratisd/blob/develop-2.3.0/CHANGES.txt
[stratis]: https://github.com/stratis-storage/stratis-cli/blob/develop-2.3.0/CHANGES.txt
