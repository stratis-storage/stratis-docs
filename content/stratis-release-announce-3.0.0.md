+++
title = "stratisd 3.0.0 Release Announcement"
date = 2021-07-07
weight = 21
template = "page.html"
render = true
+++

*mulhern, Stratis Team*

The next version of stratisd will be 3.0.0.

We have already decided on two breaking changes for this release:

* We will collapse all the non-zero error codes returned over the D-Bus
on an engine error into a single error code, 1.
* We will remove all the backwards compatible D-Bus interfaces corresponding
to stratisd 2 and will supply just a single D-Bus interface for stratisd 3.
Subsequent minor releases of stratisd 3 will retain their backwards compatible
interfaces as described in the [DBus API Reference]. Each interface will have 
a simplified naming convention, always specifying the major version and
using the stratisd minor version in the revision number. For example, the name
of the filesystem D-Bus interface under the new system for stratisd 3.0.0 is 
`org.storage.stratis3.filesystem.r0`.

The motivation for both these changes is the most typical of all: the
implementation of stratisd will become unwieldly and bug-ridden if we try to
maintain backwards compatibility in the D-Bus layer while simultaneously
doing necessary redesign, re-implementation, and enhancement of the stratisd
engine. In particular, changes to the way errors are managed internally will
not allow us to ensure consistency of error codes returned over the D-Bus with
the ones that were previously used.

Since we are increasing the major version, dropping the stratisd 2 D-Bus API is
an obvious next step.

We are reviewing other possible API changes at this time in order to minimize
the number of subsequent major version increases that we will be obliged to do.

<!-- more -->

[DBus API Reference]: https://stratis-storage.github.io/DBusAPIReference.pdf
