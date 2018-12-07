+++
title = "Using Stratis: Frequently Asked Questions"
path = "/faq"
date = 2018-11-27
toc = true
+++


### Why and when would I use Stratis?

Stratis automates the management of local storage. On a system with just a single disk, Stratis can make it more convenient to logically separate /home from /usr, and enable snapshot with rollback on each separately. On larger configurations, Stratis can make it easier to create a multi-disk, multi-tiered storage pool, monitor the pool, and then manage the pool with less administrator effort.
Is Stratis a filesystem?

It’s not a traditional filesystem like ext4, [XFS], or FAT32. Stratis manages block devices and filesystems to support features akin to “volume-managing filesystems” (VMFs) like ZFS and Btrfs. Whereas a traditional filesystem acts to support directory and file operations on top of a single block device, VMFs can incorporate multiple block devices into a “pool”. Multiple independent filesystems can be created, each backed by the storage pool.

### How does Stratis compare to ZFS and Btrfs?

In terms of features, Stratis 1.0 does not yet implement some that ZFS and Btrfs have, such as RAID and send/receive support. Not surprising, given their head start in development time.

In terms of its design, Stratis is very different from the two, since they are both in-kernel filesystems. Stratis is a userspace daemon that configures and monitors existing components from Linux’s device-mapper subsystem, as well as the [XFS] filesystem. This approach makes some things harder to achieve for Stratis, usually involving integration between block-based management and filesystem implementation. For example, the [thin-provisioning] layer and the XFS filesystem each make no assumption that it is being used along with the other. They are two independent components that Stratis is using together.

But, there are two positives from this difference. First, this lets Stratis development advance more quickly because we does not have to reimplement these components from scratch, just tie them together. These components already were developed, have users, and are maintained and improved on their own. Second, being a userspace daemon makes it easier to perform periodic monitoring tasks, provide an API, as well as potentially integrating with other non-kernel storage-related APIs in the future, such as Ceph, Amazon EBS, or Kubernetes CSI.

### What Linux storage devices can I use for Stratis?

Stratis has been tested using block devices based on LUKS (crypto), LVM Logical Volumes, mdraid, dm-multipath, and iSCSI, as well as hard drives, SSDs, and NVMe storage devices.

Since Stratis contains a [thin-provisioning] layer, placing a pool on block devices that are already thinly-provisioned is not recommended.

***Note***: For iSCSI or other block devices requiring network, see `man systemd.mount` for info on the `_netdev` mount option.

### Does Stratis work with LVM?

Yes, Stratis will work with virtually any block device, and Stratis has been tested using LVM logical volumes as block devices for Stratis pools.
How do I mount and use Stratis filesystems, once they’ve been created?

Stratis pools and filesystems both are given names are part of the creation process. Stratis creates links to filesystems under `/stratis/<pool-name>/<filesystem-name>`. These may be used in `/etc/fstab`, but if pools or filesystems are renamed in the future, be sure to update `/etc/fstab` accordingly. Alternatively you can use the blkid tool to get the [XFS] filesystem UUID, and use that, which remains constant across renames. See `man fstab` for more information.

### Why do new filesystems show up as huge (1 terabyte) when using df?

Stratis filesystems are formatted with [XFS], but managed on behalf of the user. They show up in df as being the virtual size of the XFS filesystem. This is not the actual amount of space that the filesystem uses in the Stratis pool, due to “[thin provisioning]”. The actual space used by a filesystem can be shown using the stratis filesystem list command.

If the data in a filesystem actually approaches its virtual size, Stratis will automatically grow the filesystem.

### How does Stratis handle hard drive or other hardware failures?

For current releases of Stratis it doesn’t. In fact if you create a Stratis pool with multiple devices you increase the risk of data loss as you now have multiple devices which are required to be operational to access the data.

### What happens when disks become full?

If all the disks that reside in a Stratis pool become full, write operations to the block layer will fail for the [XFS] filesystem(s) just like they would for any non Stratis based solution.

### Does Stratis provide SNMP messages to use with my monitoring software?

Not at this time. The `stratisd` daemon does provide D-Bus signals which can be used to drive event driven alerts, but that requires functionality that needs to be written.

### Can I use Stratis with virtual machines?

Stratis is usable within a virtual machine (VM) for storage and outside of VM to provide storage to virtualization environment.

### Does Stratis help manage container-based storage, Docker, etc.?

Not currently. But, automated provisioning of filesystems with snapshots could be useful to container-based usage models. Stratis’s API could be used to integrate with container management tools in the future.

### Can I use Stratis with tools like Puppet, Chef, and Ansible?

Yes, to the degree that recipes for these can be written that use Stratis’s command-line interface. Stratis is still too new to have recipes already available.

### Does Stratis have any storage limits?

Stratis was designed to support theoretically thousands of pools, and millions of filesystems per pool. However, at this stage, testing on truly large systems has not taken place, so.. if you do, let us know what happens, ok?

### Why are parts of Stratis implemented using the [Rust] programming language ?

The Stratis daemon `stratisd` needs to be implemented in a compiled language in order to meet the requirement that it operate in a preboot environment. A small runtime memory footprint is also important, thus the `stratisd` daemon is written in Rust. The key features of Rust that make it a good choice for `stratisd` are:

- Compiled with minimal runtime (no GC)
- Memory safety, speed, and concurrency
- Strong stdlib, including collections
- Error handling
- Libraries available for DBus, device-mapper, JSON serialization, and CRC
- Foreign function interface (FFI) to C libraries if needed

Other alternatives considered were C and C++. Rust was preferred over them for increased memory safety and productivity reasons.

### I found a bug in Stratis, what do I do?

There are a couple of different ways to report a bug:

- Send an email to stratis-devel@lists.fedorahosted.org
- Create a github issue (if not sure which one just select `stratisd`)
  - [`stratisd` (daemon)](https://github.com/stratis-storage/stratisd/issues)
  - [command line interface](https://github.com/stratis-storage/stratis-cli/issues)

### How do I contribute to Stratis?

Thank you for considering to make Stratis better, we welcome everyone. There’re potentially many different ways to contribute to Stratis, some ideas include:

- Use it and write up any bugs or deficiencies you find
- Add support for other distributions
- Improve documentation
- Look at the outstanding issues and see if any are interesting:
  - [documentation](https://github.com/stratis-storage/stratis-docs/issues)
  - [`stratisd` (daemon)](https://github.com/stratis-storage/stratisd/issues)
  - [command line interface](https://github.com/stratis-storage/stratis-cli/issues)

If you need inspiration or suggestions, please send an email to mailing list or look for people on IRC

### How do I submit feature requests?

Please open a github issue or send an email to the mailing list `stratis-devel@lists.fedorahosted.org`.

[XFS]: https://en.wikipedia.org/wiki/XFS
[thin-provisioning]: https://en.wikipedia.org/wiki/Thin_provisioning
[Rust]: https://www.rust-lang.org/
