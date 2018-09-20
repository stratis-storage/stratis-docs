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
