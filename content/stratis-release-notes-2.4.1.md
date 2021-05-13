+++
title = "Stratis 2.4.1 Release Notes"
date = 2021-05-13
weight = 18
template = "page.html"
render = true
+++

*mulhern, Stratis Team*

Stratis 2.4.1 is a bug fix release, which addresses a flaw in the
multi-threading implementation.

A user could observe the behavior caused by the flaw when CLI commands would
either take far longer to complete than normal or the D-Bus connection would
eventually time out.

The cause of the observed problem was that stratisd was accepting a
GetManagedObjects call on the D-Bus but not returning the result. This
could occur when numerous object paths, i.e., several hundred, were being
supported on the D-Bus, generally due to the creation of many filesystems.

We have addressed this problem by:
* modifying the D-Bus message handling implementation
* implementing a custom ObjectManager class in the D-Bus layer

In addition, we have refined the method by which individual threads are
terminated when stratisd receives a shutdown signal to better terminate the
D-Bus message handling thread.

The stratisd 2.4.1 release includes one additional fix: the signals
associated with r4 D-Bus interfaces were not being sent appropriately,
now they are.

In addition, stratisd 2.4.1 includes logging, at the trace level, of lock
aquisitions and releases.

The stratis-cli 2.4.1 release includes an improvement to the listing of
block devices.

<!-- more -->

Previously, stratisd made use of the dbus-tokio crate to implement the
multi-threading aspects of D-Bus method handling. With this release, it no
longer depends on dbus-tokio, but handles the implementation using the
tokio crate directly.

Please consult the [stratisd] and [stratis] changelogs for additional
information about the 2.4.0 release.

[stratisd]: https://github.com/stratis-storage/stratisd/blob/develop-2.4.0/CHANGES.txt
[stratis]: https://github.com/stratis-storage/stratis-cli/blob/develop-2.4.0/CHANGES.txt
