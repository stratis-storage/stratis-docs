+++
title = "stratisd filesystem as root filesystem on Fedora"
date = 2023-03-30
weight = 32
template = "page.html"
render = true
+++

*John Baublitz, Stratis Team*

Based on recent questions, we wanted to develop a specific guide for additional steps that need to be taken
on Fedora to enable Stratis as the root filesystem for a Fedora install.

If you have not already looked at [the guide] for root filesystem work, please read that first. It is a
prerequisite.

<!-- more -->

For a little bit of background, stratisd provides an additional subpackage for our dracut modules that we
use to set up the root filesystem during early boot. This package installs the necessary modules for dracut
to automate the setup. However there are some steps that may not be obvious to users to get this all to work.
We'll cover them below.

Steps:
1. Install the `stratisd-dracut` package. This is the subpackage mentioned above.
2. *Optional* If using Clevis for unlocking encrypted pools, add the following configuration
under /etc/dracut.conf.d/99-stratisd.conf:

```
add_dracutmodules+=" stratis-clevis "
```

3. Test your configuration or ensure you have a rescue kernel and initramfs in case the update of the
initramfs renders your install unbootable.
4. Once you've verified that everything works as expected, run `dracut --force --kver=[KERNEL_VERSION]`

[the guide]: @/stratis-rootfs.md
