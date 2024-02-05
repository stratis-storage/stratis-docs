+++
title = "stratisd 3.6.4 Release Notes"
date = 2024-02-05
weight = 36
template = "page.html"
render = true
+++

*mulhern, Stratis Team*

This post includes release notes for the prior patch releases in this
minor release.

`stratisd` 3.6.4 includes a fix for `stratisd-min` handling of the start
command sent by `stratis-min` to unencrypted pools. It also captures and logs
errors messages emitted by the `thin_check` or `mkfx.xfs` executables.

`stratisd` 3.6.3 explicitly sets the `nrext64` option to 0 when invoking
`mkfs.xfs`. A recent version of XFS changed the default for `nrext64` to 1.
Explicitly setting the value to 0 prevents `stratisd` from creating XFS
filesystems that are unmountable on earlier kernels.

`stratisd` 3.6.2 includes a fix in the way thin devices are allocated in order
to avoid misalignment of distinct sections of the thin data device. Such
misalignments may result in a performance degradation.

`stratisd` 3.6.1 includes a fix to correct a problem where `stratisd` would fail
to unlock a pool if the pool was encrypted using both Clevis and the kernel
keyring methods but the key in the kernel keyring was unavailable.

All releases include a number of housekeeping and maintenance updates.

<!-- more -->

Please consult the [stratisd] changelog for additional information about the
release.

[stratisd]: https://github.com/stratis-storage/stratisd/blob/patch-3.6.0/CHANGES.txt 
