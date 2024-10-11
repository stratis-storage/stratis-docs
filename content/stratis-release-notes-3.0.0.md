+++
title = "Stratis 3.0.0 Release Notes"
date = 2021-11-15
weight = 21
template = "page.html"
render = true
+++

*mulhern, Stratis Team*

Stratis 3.0.0 includes many internal improvements, bug fixes, and
user-visible changes.

Users of the Stratis CLI may observe the following changes:
* It is now possible to set the filesystem logical size when creating a
filesystem.
* It is possible to rebind a pool using a Clevis tang server or with a key
in the kernel keyring.
* Filesystem and pool list output have been extended and improved. The pool
listing includes an `Alerts` column. Currently this column is used to indicate
whether the pool is in a restricted operation mode. A new subcommand,
`stratis pool explain`, which provides a fuller explanation of the codes
displayed in the `Alerts` column has been added.  The filesystem listing
now displays a filesystem's logical size.
* With encrypted pools it was previously possible for the display of block
device paths to change format if `stratisd` was restarted after an encrypted
pool had been created. Now the display of the block device paths is consistent
across `stratisd` restarts.

In stratisd 3.0.0 the D-Bus API has undergone a revision and the prior
interfaces are all removed. The `FetchProperties` interfaces that
were supported by all objects have been removed. The values that were
previously obtainable via the `FetchProperties` methods
are now conventional D-Bus properties. The possible values of error codes
returned by the D-Bus methods have been reduced to 0 and 1, with the usual
interpretation.

stratisd 3.0.0 includes a number of significant internal improvements and a few
bug fixes.

`stratisd` bug fixes:
* Previously the Stratis release included a dracut.conf.d file which made
the Stratis dracut modules required in the initramfs. The consequence of this
was that the initramfs could not be built unless all files required for the
Stratis modules were present; if the initramfs is not built a reboot will fail.
That file has been removed in this release.
* The `--prompt` option was not passed to `stratis-min` in the
`stratis-fstab-setup` script; this prevented the user from entering the
password necessary to unlock an encrypted pool during boot. This is
no longer the case.
* Previously, stratisd did not increase the amount of space allocated to
its spare metadata device when its in-use thinpool metadata device was
extended. In some situations, when setting up a pool, stratisd might attempt
a repair operation on the thinpool metadata device; if the space allocated
for the spare metadata device was not large enough to accommodate all the
metadata, then the repair operation would fail. Now the space allocated for
the spare metadata device is increased whenever the metadata device is extended.
* `stratisd` was not immediately updating the devicemapper device stack when
a cache was initialized with the result that the cache was not immediately
put in use. This is no longer the case.
* `stratisd` was not immediately updating the Clevis encryption info associated
with a pool on a command to bind an encrypted pool with Clevis. This problem
has been corrected.
* `stratisd` was sending an incorrect D-Bus signal on a pool name change; this
has been fixed.
* Previously, when `stratisd-min`, which runs during boot before D-Bus
functionality is available, gave way to `stratisd` when the D-Bus had been set
up, it was possible for inconsistencies to arise if the Stratis engine was
performing an operation which required invoking a distinct executable. The
executable might be terminated during its execution, and `stratisd-min` would
take the action appropriate to the command failure before exiting. Now, systemd
is instructed to send a kill signal only to `stratisd-min` and not to any of
`stratisd-min`'s child processes when shutting down `stratisd-min`.
* Previously, if the same device was specified using two different paths
when creating or extending a pool the different paths would be
interpreted as two different devices and an error would be returned when
`stratisd` attempted to initialize the device a second time. Now, the
different paths are canonicalized eagerly, and converted into a single
canonical representation of the device, `stratisd` initializes the device only
once, and no error is returned.
* Previously, `stratisd` did not report all existing object paths in the
result of a D-Bus Introspect() call. This was due to a bug in version
0.9.1 and previous of `stratisd`'s dbus-tree dependency. `stratisd` now
requires dbus-tree 0.9.2, so all nodes are reported.


Other `stratisd` improvements:
* Previously, `stratisd` relied entirely on udev information when deciding
whether a storage device was not in use by another application and could
safely be overwritten with Stratis metadata. Now it performs a supplementary
check using libblkid and exits with an error if libblkid reports that the
device is in use.
* Handling of errors returned by internal methods is improved; a chaining
mechanism has been introduced and the error chains can be scrutinized
programmatically to identify expected scenarios like rollback failures.
* A set of states indicating that a pool has reduced capability have been
added internally and are published on the D-Bus. A pool's capability is
reduced on an error being returned internally which contains, somewhere in
its chain, the appropriate identifying error variant.
* The code used to roll back failed encryption operations on a list of
pool devices has been refactored and generalized. It is now capable of
returning an error that can be used to identify a restricted pool capability
due to a rollback failure.
* `stratisd` uses sha-256 instead of sha-1 for Clevis-related encryption
operations to conform with Clevis's own usage.
* `stratisd` exits more elegantly and less frequently if it encounters an
error during execution of the distinct tasks that are assigned to the
individual threads that it manages internally.
* In preparation for edition 2021 of the Rust language, `stratisd` source code
has been updated to conform entirely to edition 2018 recommendations.

<!-- more -->

NOTE: `stratisd` depends directly on the `chrono` crate against which
[RUSTSEC-2020-0159] has been filed. We have demonstrated that `stratisd` is
not affected by this CVE by building and testing `stratisd` against a
clone of the `chrono` crate from which all the code affected by the CVE
has been removed, proving that `stratisd` has no dependency on that code.

Please consult the [stratisd] and [stratis-cli] changelogs for additional
information about the 3.0.0 release.

We would like to thank mvollmer for contributions to this release.

[stratisd]: https://github.com/stratis-storage/stratisd/blob/develop-2.4.2/CHANGES.txt
[stratis-cli]: https://github.com/stratis-storage/stratis-cli/blob/develop-2.4.1/CHANGES.txt
[RUSTSEC-2020-0159]: https://rustsec.org/advisories/RUSTSEC-2020-0159
