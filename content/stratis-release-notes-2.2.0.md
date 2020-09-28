+++
title = "Stratis 2.2.0 Release Notes"
date = 2020-09-29
weight = 12
template = "page.html"
render = true
+++

Stratis 2.2.0 now places Stratis filesystem symlinks in `/dev/stratis`,
rather than `/stratis`. Stratis creates and maintains the symlinks by means
of udev rules, rather than directly via stratisd as previously.
The `/stratis` directory is neither created nor used by stratisd 2.2.0.

This release places management of the terminal setting for interactive
encryption-key entry in stratisd rather than in stratis-cli.

This release also includes enhancements to the stratisd D-Bus interface,
various bug fixes, and a change in the stratisd CLI specification for
log levels.

stratisd 2.2.0
--------------
This release creates and maintains Stratis filesystem symlinks in
`/dev/stratis` by means of udev rules. It includes a small Rust script,
`stratis_uuids_to_names` which is invoked by the Stratis udev rule which
sets the Stratis filesystem symlinks.

In the case where stratisd is updated in place, some filesystem symlinks
may remain in `/stratis`. This release includes a shell script,
`stratis_migrate_symlinks.sh` which may be used to clean up the `/stratis`
directory and ensure that the correct symlinks exist in `/dev/stratis`. The
script removes the `/stratis` directory once it has completed without error.
The shell script relies on a small Rust script, `stratis_dbusquery_version`
which is included with this version of stratisd.

This release also extends the D-Bus interface in a few ways:
  * It sends `org.freedesktop.DBus.ObjectManager.InterfacesAdded`and
    `org.freedesktop.DBus.ObjectManager.InterfacesRemoved` signals on the
    D-Bus whenever a D-Bus object is added to or removed from the D-Bus
    interface.
  * It adds a new D-Bus property, `PhysicalPath`, for the 
    `org.storage.stratis2.blockdev.r2` interface. This property is
    principally useful for encrypted Stratis block devices; it identifies
    the block device on which the Stratis LUKS2 metadata resides.
  * It adds a new key, `LockedPools`, to the
    `org.storage.stratis2.FetchProperties.r2` interface for objects that
    implement the `org.storage.stratis2.Manager` interface. This key
    returns a D-Bus object that maps the UUIDs of locked pools to their
    corresponding key descriptions.

Please consult the D-Bus API Reference for the precise D-Bus specification.

This release allows the user to specify their preferred log level more
directly and succinctly with the `--log-level` CLI option.

This release includes management of terminal settings for interactive
encryption-key entry.

This release includes some unsupported scripts which may be built from the
source distribution but are not intended to be released as part of any
package. These scripts depend on the `extras` feature in `Cargo.toml`.

This release also includes a number of minor bug fixes.


stratis-cli 2.2.0
-----------------
This release requires stratisd 2.2.0. Some commands have been updated to
make use of the new stratisd D-Bus interfaces.

This release drops management of terminal settings for interactive
encryption-key entry; management of terminal settings is now handled in
stratisd 2.2.0.

We would like to thank our external contributors carzacc and poizen18 for
their work on bash tab-completion.

<!-- more -->

Please consult the changelogs for additional information about the release.
