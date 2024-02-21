+++
title = "stratisd 3.6.5 Release Notes"
date = 2024-02-21
weight = 37
template = "page.html"
render = true
+++

*mulhern, Stratis Team*

`stratisd` 3.6.5 includes a modification to its internal locking mechanism
which allows a lock which does not conflict with a currently held lock to
precede a lock that does. This change relaxes a fairness restriction that
gave precedence to locks based solely on the order in which they had been
placed on a wait queue. This release also includes a number of housekeeping
commits and minor improvements.

<!-- more -->

Please consult the [stratisd] changelog for additional information about the
release.

[stratisd]: https://github.com/stratis-storage/stratisd/blob/patch-3.6.0/CHANGES.txt 
