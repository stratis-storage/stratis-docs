+++
title = "Stratis 3.5.0 Release Notes"
date = 2023-01-24
weight = 30
template = "page.html"
render = true
+++

*mulhern, Stratis Team*

Stratis 3.5.0 includes one significant enhancement as well as several smaller
improvements.

Most significantly, Stratis 3.5.0 extends its functionality to allow a user
to add a cache to an encrypted pool. The cache devices are each encrypted with
the same mechanism as the data devices; consequently the cache itself is
encrypted.

Stratis 3.5.0 also fixes a few bugs. It requires a new version of the Stratis 
devicemapper-rs library, which contains a fix which eliminates undefined
behavior in the management of ioctls with large result values. It makes the
pool name field in the Stratis LUKS2 metadata optional; this prevents a 
failure to start an encrypted pool when upgrading from previous `stratisd`
versions to `stratisd` 3.4.0. It requires a new version of the Stratis
libblkid-rs library, which fixes a memory leak in the `get_tag_value`
method used by `'stratisd`.

This release also reduces the problem of repetitive log messages and modifies
the D-Bus API to eliminate the `redundancy` parameter previously required by 
the `CreatePool` D-Bus method.

<!-- more -->

Please consult the [stratisd] and [stratis-cli] changelogs for additional
information about the release.

[stratisd]: https://github.com/stratis-storage/stratisd/blob/master/CHANGES.txt
[stratis-cli]: https://github.com/stratis-storage/stratis-cli/blob/master/CHANGES.txt
