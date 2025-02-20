+++
title = "Stratis 2.2.1 Release Notes"
date = 2020-11-09
weight = 13
template = "page.html"
render = true
+++

*mulhern, Stratis Team*

Stratis 2.2.1 is a bug fix release. It fixes the following bugs:

<!-- more -->

* It was possible to cause stratisd to hang by leaving open a D-Bus
connection when setting a key in the kernel keyring.
* stratis would pass as arguments on the D-Bus and stratisd would accept
relative, rather than absolute, path names to specify devices.
* Pool and filesystem names that included characters that would be escaped
by udev when constructing filesystem symlinks were permitted.
* The man page entry for the `key list` command was missing.

Other general improvements were made, and several crate version requirements
were increased.


Please consult the changelogs for additional information about the release.
