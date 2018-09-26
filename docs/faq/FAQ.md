---
title: 'Using Stratis: Frequently Asked Questions'
---

### Why do new filesystems show up as huge (1 terabyte) when using `df`?

Stratis filesystems are formatted with
[XFS](https://en.wikipedia.org/wiki/XFS), but managed on behalf of the
user. They show up in `df` as being the virtual size of the XFS
filesystem. This is *not* the actual amount of space that the filesystem uses
in the Stratis pool, due to "[thin
provisioning](https://en.wikipedia.org/wiki/Thin_provisioning)". The actual
space used by a filesystem can be shown using the `stratis filesystem list`
command.

If the data in a filesystem actually approaches its virtual size, Stratis will
automatically grow the filesystem.

### What Linux storage devices can I use for Stratis?

Stratis has been tested using block devices based on LUKS (crypto), LVM
Logical Volumes, mdraid, dm-multipath, and iSCSI, as well as hard drives,
SSDs, and NVMe storage devices.

Since Stratis contains a thin-provisioning layer, placing a pool on block
devices that are already thinly-provisioned is not recommended.

Note: For iSCSI or other block devices requiring network, see `man
systemd.mount` for info on the "_netdev" mount option.

### How do I mount and use Stratis filesystems, once they've been created?

Stratis pools and filesystems both are given names are part of the creation
process. Stratis creates links to filesystems under
`/dev/stratis/<pool-name>/<filesystem-name>`. These may be used in
`/etc/fstab`, but if pools or filesystems are renamed in the future, be sure
to update `/etc/fstab` accordingly. Alternatively you can use the `blkid` tool
to get the XFS filesystem UUID, and use that, which remains constant across
renames. See `man fstab` for more information.


### Why are parts of Stratis implemented using the [rust](https://www.rust-lang.org) programming language ?

The Stratis daemon `stratisd` needs to be implemented in a compiled language in
order to meet the requirement that it operate in a preboot environment.
A small runtime memory footprint is also important, thus `stratisd` daemon is
written in Rust. The key features of Rust that make it a good choice for
`stratisd` are:

  * Compiled with minimal runtime (no GC)
  * Memory safety, speed, and concurrency
  * Strong stdlib, including collections
  * Error handling
  * Libraries available for DBus, device-mapper, JSON serialization, and CRC
  * Foreign function interface (FFI) to C libraries if needed

Other alternatives considered were C and C++. Rust was preferred over them for
increased memory safety and productivity reasons.

### I found a bug in Stratis, what do I do?

There are a couple of different ways to report a bug:
  * Send an email to `stratis-devel@lists.fedorahosted.org`
  * Create a github issue (if not sure which one just select stratisd)
    - [stratisd (daemon)](https://github.com/stratis-storage/stratisd/issues)
    - [command line interface](https://github.com/stratis-storage/stratis-cli/issues)

### How do I contribute to Stratis?

Thank you for considering to make Stratis better, we welcome everyone.
There're potentially many different ways to contribute to Stratis, some ideas
include:

   * Use it and write up any bugs or deficiencies you find
   * Add support for other distributions
   * Improve documentation
   * Look at the outstanding issues and see if any are interesting:
     - [documentation](https://github.com/stratis-storage/stratis-docs/issues)
     - [command line interface](https://github.com/stratis-storage/stratis-cli/issues)
     - [stratisd daemon](https://github.com/stratis-storage/stratisd)

If you need inspiration or suggestions, please send an email to mailing list or
look for people on IRC

### How do I submit feature requests?

Please open a github issue or send an email to the mailing list `stratis-devel@lists.fedorahosted.org`.

### Does Stratis provide SNMP messages to use with my monitoring software?

Not at this time.  The `stratisd` daemon does provide DBUS signals which can
be used to drive event driven alerts, but that requires functionality that
needs to be written.

### Does Stratis work with LVM?

Yes, Stratis will work with virtually any block device and Stratis has been tested
using LVM logical volumes as block devices for Stratis pools.

### How does Stratis handle hard drive or other hardware failures?

For current releases of Stratis it doesn't.  In fact if you create a Stratis pool with
multiple devices you increase the risk of data loss as you now have multiple devices which
are required to be operational to access the data.

### What happens when disks become full?

If all the disks that reside in a Stratis pool become full, write operations to the
block layer will fail for the XFS filesystem(s) just like they would for
any non Stratis based solution.

### Can I use Stratis with VM etc.?

Stratis is usable within a virtual machine (VM) for storage and outside of VM to
provide storage to virtualization environment.
