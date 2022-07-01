+++
title = "Stratis 3.2.0 Release Notes"
date = 2022-07-07
weight = 27
template = "page.html"
render = true
+++

*mulhern, Stratis Team*

Stratis 3.2.0 includes one significant enhancement, one bug fix, and a number
of more minor improvements.

Most significantly, Stratis 3.2.0 extends its functionality to allow users to
stop and start a pool.

Stopping a pool consists of tearing down its storage stack in an orderly way,
but not destroying the pool metadata. It is a `pool destroy` operation
without the final step of wiping the Stratis metadata. Starting a pool is
setting up a pool according to the information stored in the pool level
metadata of the devices associated with a pool. Whether a pool is stopped or
started is stored in the pool-level metadata, with the consequence that users
can control whether a pool is automatically started when `stratisd` is started
up, or whether startup of the pool is deferred until explicitly requested.

`stratis` supports these changes with new commands to start and to stop a
pool. It includes an additional `debug refresh` command which allows a user to
request that the state of all pools be refreshed. The `pool list` command has
been extended to allow a detailed view of individual pools and to allow the
user to examine stopped pools. The `pool unlock` command has been removed
in favor of the `pool start` command.

Other changes include a fix to the algorithm for determining the size of data 
and metadata devices that make up a thinpool device, the elimination of all
uses of `udevadm settle` in the `stratisd` engine, and general improvements to
the RPC layers used by `stratis-min` and `stratisd-min`.

In addition, the `stratisd-min` service now requires the `systemd-udevd`
service to ensure that Stratis filesystem symlinks are created when
`stratisd-min` sets up a Stratis filesystem.

<!-- more -->

Please consult the [stratisd] and [stratis-cli] changelogs for additional
information about the 3.2.0 release.

We would like to thank Ryan Gonzalez for reporting [issue #3019].

[stratisd]: https://github.com/stratis-storage/stratisd/blob/master/CHANGES.txt
[stratis-cli]: https://github.com/stratis-storage/stratis-cli/blob/master/CHANGES.txt
[issue #3019]: https://github.com/stratis-storage/stratisd/issues/3019
