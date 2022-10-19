+++
title = "Stratis 3.3.0 Release Notes"
date = 2022-10-18
weight = 28
template = "page.html"
render = true
+++

*mulhern, Stratis Team*

Stratis 3.3.0 includes one significant enhancement and several smaller
enhancements as well as number of stability and efficiency improvements.

Most significantly, Stratis 3.3.0 extends its functionality to allow users to
instruct `stratisd` to include additional space that may have become available
on a component data device in the space that is available to the device's pool.
The most typical use case for this is when a RAID device which presents as a
single device to `stratisd` is expanded.

`stratis` supports these changes with a new command `stratis pool extend-data`
that allows the user to specify that the pool should make use of
additional space on its devices. The `stratis pool list` command has been
extended to show an alert if a pool's device has changed in size. The
`stratis blockdev list` command will display two device sizes if the size
that stratisd has on record differs from a device's detected size.

A less user-visible change is an improvement to the way that `stratisd`
allocates space for its thin pool metadata and data devices from the backing
store. The new approach is less precise but always more conservative when
allocating space for the thin pool metadata device and will consistently reduce
possible fragmentation of the thin pool metadata device over the backing
store.

Checks for Clevis executables occur whenever a Clevis executable that is
depended on by `stratisd` needs to be invoked to complete a user's command.
Previously, the check occurred only once, when `stratisd` was started. We
believe that this change will be more convenient for users who may install
needed Clevis executables after `stratisd` has already been started.


<!-- more -->

Please consult the [stratisd] and [stratis-cli] changelogs for additional
information about the release.

We would like to thank Ryan Gonzalez for reporting [issue #3086].

[stratisd]: https://github.com/stratis-storage/stratisd/blob/master/CHANGES.txt
[stratis-cli]: https://github.com/stratis-storage/stratis-cli/blob/master/CHANGES.txt
[issue #3086]: https://github.com/stratis-storage/stratisd/issues/3086
