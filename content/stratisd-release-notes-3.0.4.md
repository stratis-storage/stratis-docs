+++
title = "stratisd 3.0.4 Release Notes"
date = 2022-02-16
weight = 24
template = "page.html"
render = true
+++

*mulhern, Stratis Team*

stratisd 3.0.4 contains two fixes to bugs in its D-Bus API. 

The D-Bus property changed signal sent on a change to the LockedPools
property of the "org.storage.stratis3.Manager.r0" interface misidentified the
interface as the "org.storage.stratis3.pool.r0" interface; the interface
being sent with the signal is now correct.

The introspection data obtained via the "org.freedesktop.DBus.Introspectable"
interface's "Introspect" method was not correct for the "GetManagedObjects"
method of the "org.freedesktop.DBus.ObjectManager" D-Bus interface; it did
not include the specification of the out argument. This has been corrected.

<!-- more -->

Please consult the [stratisd changelog] for additional information about the
release.

[stratisd changelog]: https://github.com/stratis-storage/stratisd/blob/master/CHANGES.txt
