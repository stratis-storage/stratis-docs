+++
title = "Stratis 3.8.0 Release Notes"
date = 2025-03-10
weight = 40
template = "page.html"
render = true
+++

*mulhern, Stratis Team*

Stratis 3.8.0, which consists of `stratisd 3.8.0` and `stratis-cli 3.8.0`
includes two significant enhancements, as well as a number of minor
improvements.

Most significantly, Stratis 3.8.0, introduces a revised storage stack. The
motivation for this change and overall structure of the storage stack is
described [in a separate post].

Stratis 3.8.0 also introduces support for multiple bindings for encryption
using the same mechanism. Previously, Stratis only allowed a single binding
that used a key in the kernel keyring, now multiple bindings with different
keys may be used for the same pool. Similarly, multiple bindings that make
use of a Clevis encryption mechanism may be used with the same pool. The
number of total bindings is limited to 15.

This change enables a number of use cases that the previous scheme did not
allow. For example, a pool might be configured so that it can be unlocked
with one key belonging to a storage administrator, for occasional necessary
maintenance, and with a different key by the designated user of the pool.

Previously, when starting an encrypted pool, the user was required to
designate an unlock method, `clevis` or `keyring`. Since this release
allows multiple bindings with one unlock method, it introduces a more general
method of specifying an unlock mechanism on pool start. The user may specify
`--unlock-method=any` and all available methods may be tried. The user
may also specify that the pool should be opened with one particular binding,
using the `--token-slot` option. Or the user may choose to enter a passphrase 
to unlock the pool instead, either by specifying the `--capture-key` option
or a keyfile using the `--keyfile-path` option. Similarly, the `unbind`
command now requires the user to specify which binding to unbind using the
`--token-slot` option. And the rebind method requires that the user specify
a particular token slot with the `--token-slot` option if the pool has more
than one binding with the same method.

<!-- more -->

There were also a number of internal improvements, minor bug fixes, and
dependency updates.

Please consult the [stratisd] and [stratis-cli] changelogs for additional
information about the release.

[stratisd]: https://github.com/stratis-storage/stratisd/blob/master/CHANGES.txt 
[stratis-cli]: https://github.com/stratis-storage/stratis-cli/blob/master/CHANGES.txt
[in a separate post]: @/metadata-rework.md
