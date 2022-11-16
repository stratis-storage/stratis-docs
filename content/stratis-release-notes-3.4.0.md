+++
title = "Stratis 3.4.0 Release Notes"
date = 2022-11-23
weight = 29
template = "page.html"
render = true
+++

*mulhern, Stratis Team*

Stratis 3.4.0 includes one significant enhancement as well as several smaller
improvements.

Most significantly, Stratis 3.4.0 extends its functionality to allow users to
specify a pool by its name when starting a stopped pool. Previously it was
only possible to identify a stopped pool by its UUID.

In addition, `stratisd` enforces some checks on the compatibility of the block
devices which make up a pool. It now takes into account the logical and
physical sector sizes of the individual block devices when creating a pool,
adding a cache, or extending the data or cache tier with additional devices.

The `stratis pool start` command has been modified to accept either a UUID
or a name option, while the `stratis pool list --stopped` command now displays
the pool name if it is available.

This release also includes improvements to `stratisd`'s internal locking
mechanism.

<!-- more -->

Please consult the [stratisd] and [stratis-cli] changelogs for additional
information about the release.

[stratisd]: https://github.com/stratis-storage/stratisd/blob/master/CHANGES.txt
[stratis-cli]: https://github.com/stratis-storage/stratis-cli/blob/master/CHANGES.txt
