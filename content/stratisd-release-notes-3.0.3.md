+++
title = "stratisd 3.0.3 Release Notes"
date = 2022-02-06
weight = 23
template = "page.html"
render = true
+++

*mulhern, Stratis Team*

stratisd 3.0.3 contains internal improvements and several bug fixes.

Most significantly, it includes an enhancement to stratisd's original
multi-threading model to allow [locking individual pools]. 

A change was made to the conditions under which the stratis dracut module is
included in the initramfs.

Under some conditions, a change in pool size did not result in a corresponding
property changed signal for the relevant D-Bus property change; this has been
fixed.

<!-- more -->

Please consult the [stratisd changelog] for additional information about the
release.

[locking individual pools]: @/per-pool-locking.md
[stratisd changelog]: https://github.com/stratis-storage/stratisd/blob/master/CHANGES.txt
