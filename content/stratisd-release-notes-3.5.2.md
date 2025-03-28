+++
title = "stratisd 3.5.2 Release Notes"
date = 2023-03-21
weight = 31
template = "page.html"
render = true
+++

*mulhern, Stratis Team*

`stratisd` 3.5.2 includes three significant enhancements as well as a bug
fix.

<!-- more -->

The enhancements are:

* `stratisd` 3.5.2 is the first `stratisd` release to include a subpackage,
`stratisd-tools`, which incorporates `stratis-dumpmetadata`, an application
which may be used for troubleshooting.
* `stratisd` 3.5.2 now depends on `devicemapper-rs` 0.33.1, which includes
support for synchronization between udev and devicemapper. See
the [devicemapper-rs] changelog and [stratisd pr 3069] for additional details.
* `stratisd` 3.5.2 modifies the way takeover by `stratisd` from `stratisd-min`
is managed during early boot. See [stratisd pr 3269] for further details.


`stratisd` 3.5.2 also fixes a bug in a script used by the stratisd-dracut
subpackage. This fix was included in the `stratisd` 3.5.1 release. See
[stratisd pr 3256] for further details.

Please consult the [stratisd] changelog for additional information about the
release.

We would like to thank matthias\_berndt and kianmeng for their contributions
to this release.

[stratisd pr 3069]: https://github.com/stratis-storage/stratisd/pull/3069
[stratisd pr 3269]: https://github.com/stratis-storage/stratisd/pull/3269
[stratisd pr 3256]: https://github.com/stratis-storage/stratisd/pull/3256
[devicemapper-rs]: https://github.com/stratis-storage/devicemapper-rs/blob/master/CHANGES.txt
[stratisd]: https://github.com/stratis-storage/stratisd/blob/master/CHANGES.txt
