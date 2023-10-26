+++
title = "Stratis 3.6.0 Release Notes"
date = 2023-10-25
weight = 35
template = "page.html"
render = true
+++

*mulhern, Stratis Team*

Stratis 3.6.0 includes one significant enhancement as well as several smaller
improvements.

Most significantly, Stratis 3.6.0 extends its functionality to allow a user
to set a limit on the size of a filesystem. The limit can be set when the
filesystem is created, or at a later time.

In addition, Stratis 3.6.0 allows the user to stop a pool by specifying the pool
to stop either by UUID or by name, and allows better management of partially
constructed pools.

A new `--only` option was added to `stratis-dumpmetadata`, to allow it to print
only the pool-level metadata.

`stratis-min`, the minimal CLI for Stratis, was extended with `bind`, `unbind`,
and `rebind` commands.

The `devicemapper` dependency lower bound is increased to 0.34.0 which
includes an enhancement to check for the presence of the udev daemon.
`stratisd` and `stratisd-min` now exit on startup if the udev daemon is not
present.

The `libcryptsetup-rs` dependency lower bound is increased to 0.9.1 and a
direct dependency is introduced on `libcryptsetup-rs-sys` 0.3.0 to allow
registering callbacks with libcryptsetup.

The `nix` dependency lower bound is increased to 0.26.3, to avoid compilation
errors induced by a fix to a lifetime bug in a function in `nix`'s public API.

The `serde_derive` dependency lower bound is increased to 1.0.185 to avoid
vendoring the `serde_derive` executable included in some prior versions of the
package.

`stratisd` also contains sundry internal improvements, error message
enhancements, and so forth.

The `stratis-cli` command-line interface has been extended with an additional
option to set the filesystem size limit on creation and two new filesystem
commands, `set-size-limit` and `unset-size-limit`, to set or unset the
filesystem size limit after a filesystem has been created.

`stratis-cli` now incorporates password verification when it is used to
set a key in the kernel keyring via manual entry.

`stratis-cli` now allows specifying a pool by name or by UUID when stopping
a pool.

`stratis-cli` also contains sundry internal improvements, and enforces
a python requirement of at least 3.9 in its package configuration.

<!-- more -->

Please consult the [stratisd], [stratis-cli], [devicemapper], and
[libcryptsetup-rs] changelogs for additional information about the release.

We would like to thank brimworks, cpalv, jelly, kianmeng and ErwanGa for
contributions to this release.

[stratisd]: https://github.com/stratis-storage/stratisd/blob/master/CHANGES.txt
[stratis-cli]: https://github.com/stratis-storage/stratis-cli/blob/master/CHANGES.txt
[devicemapper]: https://github.com/stratis-storage/devicemapper-rs/blob/master/CHANGES.txt
[libcryptsetup-rs]: https://github.com/stratis-storage/libcryptsetup-rs/blob/master/CHANGES.txt
