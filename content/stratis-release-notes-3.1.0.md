+++
title = "Stratis 3.1.0 Release Notes"
date = 2022-05-24
weight = 26
template = "page.html"
render = true
+++

*mulhern, Stratis Team*

Stratis 3.1.0 includes significant improvements to the management of the
thin-provisioning layers, as well as a number of other user-visible
enhancements and bug fixes.

Please see [this post] for a detailed discussion of the thin-provisioning
changes. To support these changes the Stratis CLI has been enhanced to:
* allow specifying whether or not a pool may be overprovisioned on creation
* allow changing whether or not a pool may be overprovisioned while it is
running
* allow increasing the filesystem limit for a given pool
* display whether or not a pool is overprovisioned in the pool list view

Users of the Stratis CLI may also observe the following changes:
* A `debug` subcommand has been added to the `pool`, `filesystem`, and
`blockdev` subcommands. Debug commands are not fully supported and may change
or be removed at any time.
* The `--redundancy` option is no longer available when creating a pool. This
option had only one permitted value so specifying it never had any effect.

stratisd 3.1.0 includes one additional user-visible change:
* The minimum size of a Stratis filesystem is increased to 512 MiB.

stratisd 3.1.0 also includes a number of internal improvements:
* The size of any newly created MDV is increased to 512 MiB.
* A pool's MDV is mounted in a private mount namespace and remains mounted
while the pool is in operation.
* Improved handling of udev events on device removal.
* The usual and customary improvements to log messages.

<!-- more -->

Please consult the [stratisd] and [stratis-cli] changelogs for additional
information about the 3.1.0 release.

[this-post]: @/thin-provisioning-redesign.md
[stratisd]: https://github.com/stratis-storage/stratisd/blob/master/CHANGES.txt
[stratis-cli]: https://github.com/stratis-storage/stratis-cli/blob/master/CHANGES.txt
