+++
title = "stratisd 3.6.7 Release Notes"
date = 2024-04-19
weight = 38
template = "page.html"
render = true
+++

*mulhern, Stratis Team*

<!-- more -->

`stratisd` 3.6.7 contains two bug fixes. The first bug fix prevents a
file descriptor from being closed too soon after opening so that the user 
is prevented from specifying a passphrase via the `--capture-key`
option of the `stratis-min pool start` command. This bug was introduced in
`stratisd` 3.6.6.  The second corrects an error in the
`stratis-fstab-setup` script where the pool UUID was not properly
supplied to the `stratis-min pool is-encrypted` command.

`stratisd` 3.6.6 includes a number of changes. It now defines two
workspaces, one for itself and one for `stratisd_proc_macros`, mostly to
simplify packaging downstream. It increases the lower bounds of many of its
dependencies; its bindgen dependency lower bound is now increased to
0.69.0. It includes a restriction on the size of any `String` value in the
Stratis pool-level metadata. It ensures that the `UserInfo` values on
devices conform to the same restrictions as filesystem names and pool
names. It fixes a bug in lock file handling where it would be possible
for the lock file to contain some extra digits at the end of the running
`stratisd` process's id.

Both releases contain many minor fixes and improvements.

Please consult the [stratisd] changelog for additional information about the
release.

[stratisd]: https://github.com/stratis-storage/stratisd/blob/patch-3.6.0/CHANGES.txt 
