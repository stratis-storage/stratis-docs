+++
title = "Stratis root filesystem installation with stratify.py"
date = 2023-04-18
weight = 33
template = "page.html"
render = true
+++

*Bryn Reeves, Stratis team*

Support for using Stratis as the root filesystem was added in version 2.4.0 but
without support in distribution installers it can be tricky for users to build
systems for testing.

This blog post will look at a quick method for installing systems with Stratis
as the root filesystem using the Fedora Live ISO, kickstart, and a Python script to
simplify and automate the process.

<!-- more -->

### Background

Stratis has supported use as the root filesystem since version 2.4.0 and the steps
required to prepare a system with Stratis as the root filesystem are conceptually
straightforward: allocate storage to a system and then create a Stratis pool and
filesystem, copy the desired installation content to the new filesystem and then set
up a boot loader to boot the newly installed system.

Typically these details would all be handled by an operating system installer such as
Fedora's *Anaconda* based on the parameters specified by the user. That's fine if the
installer knows about the filesystem type you are using, but testing new filesystems
typically requires a more manual approach. For Stratis the following steps are
needed:

  * Partition disks as required for EFI or BIOS boot
  * Install packages needed for Stratis
  * Create a Stratis pool and filesystem
  * Install packages into the new root filesystem
  * Install Grub2 or another bootloader on the installation disk
  * Generate an initramfs image with the required components
  * Configure the bootloader to boot the new system

This can be done manually but it is a long and tedious process with plenty of
opportunity for mistakes to creep in. A single error in any of the above steps may
lead to an unbootable system and user frustration.


### Introducing stratify.py

In this post we'll look at using the `stratify.py` script to automate the
installation of a virtual machine using Stratis as the root filesystem. The script
automates the preparation of the basic system layout and then runs Anaconda to
perform the OS installation. Once the installer has done its work `stratify.py` will
set up the boot loader and other details needed for a working system.

Since Anaconda is used to carry out the OS installation we will use a [kickstart
file](https://pykickstart.readthedocs.io/en/latest/) to configure the installed
system.

Refer to the [stratify documentation](https://github.com/bmr-cymru/stratify) for more
details or press on to get started right away!


### Requirements

In order to install a system with Stratis as the root filesystem you will need an
`x86_64` virtual machine configured with the following specification:

  * At least 3GiB memory
  * BIOS or UEFI firmware
  * One 10GiB or larger VirtIO disk for the installation
  * The [Fedora LiveCD media](https://fedoraproject.org/workstation/download/) (Fedora 37 or 38)


### Getting started
Configure the machine with your preferred virtualization solution and then boot the
Live desktop environment. We'll download the necessary files to the root account home
directory (`/root`) and then start the installation process.

Once the system has booted dismiss the "Install to hard disk" dialog, open a terminal
window and switch to the root account by running `su -`.

Download the `stratify.py` script and example kickstart file from GitHub:

```
# wget https://raw.githubusercontent.com/bmr-cymru/stratify/main/stratify.py
# wget https://raw.githubusercontent.com/bmr-cymru/stratify/main/ks.cfg
```

The kickstart file can be customized before beginning the installation - for
example to set the system language, timzeone, or package selection for the
install. See the [kickstart
documentation](https://pykickstart.readthedocs.io/en/latest/) for further
information.

The kickstart file sets the root account password to "changeme" - edit the file
to set a new password, or use the openssl command to generate an encrypted
(hashed) password:

```
$ openssl passwd -6 "newpassword"
$6$ly/YwB6/b5R6Pezz$zZGzBKgkPZvYHtefBwC7gJKB0BpW7ANJyt0sfjIf46yKS2IGfcnhfFW6wiXJLpYeQXvIBlJG/W7wukX0/S9Wu/
```

In `ks.cfg`:

```
# Root password
rootpw --iscrypted $6$ly/YwB6/b5R6Pezz$zZGzBKgkPZvYHtefBwC7gJKB0BpW7ANJyt0sfjIf46yKS2IGfcnhfFW6wiXJLpYeQXvIBlJG/W7wukX0/S9Wu/
```

### Running the script
Once the `stratify.py` script and kickstart file have been downloaded, start
the installation process by running:

```
python stratify.py --target vda --kickstart /root/ks.cfg
```

This will install required packages in the Live environment, set up the Stratis root
pool and filesystem, and run anaconda to perform the installation. The process logs
to the terminal and to a file named `stratify.log`.

To encrypt the pool with a passphrase add `--encrypt` to the command line - you will
be prompted for the pool password when it is set up.

The installation should take less than 20 minutes with a typical network and virtual
machine configuration.

When finished the script will print:

```
INFO - Stratis root fs installation complete.
```

At that point the machine is ready to reboot into the Stratis root filesystem. Use
either the `reboot` command or the graphical desktop power menu to reboot the system.


### First boot

Once the system has booted up log in using the credentials set during the
installation. The system is now running with Stratis as the root filesystem:

```
# findmnt -s
TARGET SOURCE              FSTYPE OPTIONS
/      /dev/stratis/p1/fs1 xfs    defaults
/boot  /dev/vda1           xfs    defaults
```

The `stratis` command shows the state of the thin pool and the block devices and
filesystems that it contains:

```
# stratis pool
Name                Total / Used / Free    Properties                                   UUID   Alerts
p1     19.02 GiB / 2.71 GiB / 16.31 GiB   ~Ca,~Cr, Op   f0401402-3710-422b-8ffb-ecb987e7d0c0
# stratis filesystem
Pool   Filesystem   Total / Used / Free              Created             Device                UUID
p1     fs1          1 TiB / 2.19 GiB / 1021.81 GiB   Apr 21 2023 12:58   /dev/stratis/p1/fs1   68e52045-baa0-440b-8636-128936a0e512
# stratis blockdev
Pool Name   Device Node   Physical Size   Tier   UUID
p1          /dev/vda2         19.02 GiB   DATA   6a9c7d7c-3d84-4287-80b8-829f0f4de602
```


### Conclusion

Until operating system installers gain native support for Stratis users face a
lengthy and complex process to deploy systems with Stratis as the root filesystem.
The `stratify.py` script is a quick and easy method for administrators and developers
to set up Stratis root systems for testing.
