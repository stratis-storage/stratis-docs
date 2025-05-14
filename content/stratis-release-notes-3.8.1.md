+++
title = "Stratis 3.8.1 Release Notes"
date = 2025-05-13
weight = 41
template = "page.html"
render = true
+++

*mulhern, Stratis Team*

Stratis 3.8.1, which consists of `stratisd 3.8.1` and `stratis-cli 3.8.1`
is a bug fix release which addresses the following problems.

For `stratis-cli`, the release fixes a bug where a user would be unable to
start an encrypted pool previously created with any Stratis release less
than 3.8.0.

`stratis-cli 3.8.1` also contains better organized help text and displays 
more complete information in the pool detail view.

For `stratisd`, the release makes improvements to the Stratis support for
mounting filesystems at boot. It introduces a new systemd unit file,
`stratis-fstab-setup-with-network@.service`, which should be used when a
filesystem's pool requires unlocking with the network present, as is the
case when a pool is encrypted using NBDE (network-bound disk encryption).
The fstab entry for the filesystem _must_ include the `_netdev` option if this
systemd unit file is used.

If the `stratis-fstab-setup-with-network@service` unit is used and the
`_netdev` option is omitted in the same fstab entry, systemd will calculate
a cyclic dependency, and the boot process will fail.

An example fstab entry for a filesystem on a pool that is encrypted using
NBDE should look something like this:

`/dev/stratis/<POOL_NAME>/<FILESYSTEM_NAME> <MOUNTPOINT> xfs defaults,_netdev,x-systemd.requires=stratis-fstab-setup-with-network@<POOL_UUID>.service,x-systemd.after=stratis-fstab-setup-with-network@<POOL_UUID>.service 0 2`

If a filesystem's pool does not require that the network is up to be
unlocked then the fstab entry may use the existing
`stratis-fstab-setup@.service` unit instead.

`stratisd 3.8.1` also contains some minor fixes: it adds a previously
omitted D-Bus `PropertiesChanged` signal for the revision 8 `MergeScheduled`
property, includes additional information about stopped pools in the
D-Bus `StoppedPools` property, and improves some error messages.

<!-- more -->

Please consult the [stratisd] and [stratis-cli] changelogs for additional
information about the release.

[stratisd]: https://github.com/stratis-storage/stratisd/blob/master/CHANGES.txt
[stratis-cli]: https://github.com/stratis-storage/stratis-cli/blob/master/CHANGES.txt
