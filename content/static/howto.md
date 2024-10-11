+++
path = "/howto"
title = "Stratis how-to/walk-through"
date = 2018-11-27
toc = true
+++


# Introduction

Stratis provides ZFS/Btrfs-style features by integrating layers of existing technology: Linux’s devicemapper subsystem, and the XFS filesystem. The stratisd daemon manages collections of block devices, and provides a D-Bus API. The stratis-cli provides a command-line tool stratis which itself uses the D-Bus API to communicate with stratisd.

## Installation

```
# dnf install stratisd stratis-cli
```

## Starting the service

```
# systemctl start stratisd

# systemctl enable stratisd
Created symlink /etc/systemd/system/sysinit.target.wants/stratisd.service →
/usr/lib/systemd/system/stratisd.service.
```

## Locate an empty block device

Use utilities like lsblk and blkid to find a block device to use with Stratis.

```
# lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0   28G  0 disk
├─sda1   8:1    0    1G  0 part /boot
├─sda2   8:2    0  2.8G  0 part [SWAP]
└─sda3   8:3    0   15G  0 part /
sdb      8:16   0    1T  0 disk
sdc      8:32   0    2T  0 disk
sdd      8:48   0    8G  0 disk
sde      8:64   0    8G  0 disk
sdf      8:80   0    8G  0 disk
sdg	 8:96   0    8G  0 disk
sr0     11:0    1 1024M  0 rom

# blkid -p /dev/sda
/dev/sda: PTUUID="b7168b63" PTTYPE="dos"
```

Not empty, it contains a partition table.

```
# blkid -p /dev/sdb
Empty, no known signatures found.
```

If you are positive that you have a block device that you want to use and it has a signature on it, you need to clear the signature before using it in a Stratis pool. Otherwise you will get an error when you attempt to create the pool.

To clear a device so that it can be used by Stratis.

```
# blkid -p /dev/sdc
/dev/sdc: UUID="770587cc-cfd3-44cb-82e2-756902cf458b" VERSION="1.0" TYPE="ext4" USAGE="filesystem"

# wipefs -a /dev/sdc
/dev/sdc: 2 bytes were erased at offset 0x00000438 (ext4): 53 ef
```

## Creating a pool

A pool with one block device.

```
# stratis pool create stratis_howto /dev/sdb

# stratis pool list
Name             Total Physical Size  Total Physical Used
stratis_howto                  1 TiB               52 MiB
```

A pool with 2 block devices.

```
# stratis pool create tale_of_2_disks /dev/sdd /dev/sdf

# stratis pool list
Name               Total Physical Size  Total Physical Used
stratis_howto                    1 TiB               52 MiB
tale_of_2_disks                 16 GiB               56 MiB
```

## Creating a filesystem from the pool

```
# stratis filesystem create stratis_howto fs_howto

# stratis filesystem list
Pool Name      Name      Used     Created            Device
stratis_howto  fs_howto  546 MiB  Nov 09 2018 11:08  /dev/stratis/stratis_howto/fs_howto
```

To create another file system, just repeat the same command with a different file system name. The file system names are required to be unique in a pool.

```
# stratis filesystem create stratis_howto my_precious

# stratis filesystem list
Pool Name      Name         Used     Created            Device
stratis_howto  fs_howto     546 MiB  Nov 09 2018 11:08  /dev/stratis/stratis_howto/fs_howto
stratis_howto  my_precious  546 MiB  Nov 09 2018 11:09  /dev/stratis/stratis_howto/my_precious
```

The file system is created on a thinly provisioned 1 TB block device. Stratis will take care of allocating blocks from the pool and re-sizing the XFS file system as needed during its lifetime.

You can also constrain the file system list output by including the pool name.

```
# stratis pool create olympic /dev/sdc

# stratis filesystem create olympic backstroke

# stratis filesystem
Pool Name      Name         Used     Created            Device
olympic        backstroke   546 MiB  Nov 09 2018 11:10  /dev/stratis/olympic/backstroke
stratis_howto  fs_howto     546 MiB  Nov 09 2018 11:08  /dev/stratis/stratis_howto/fs_howto
stratis_howto  my_precious  546 MiB  Nov 09 2018 11:09  /dev/stratis/stratis_howto/my_precious

# stratis filesystem list stratis_howto
Pool Name      Name         Used     Created            Device
stratis_howto  fs_howto     546 MiB  Nov 09 2018 11:08  /dev/stratis/stratis_howto/fs_howto
stratis_howto  my_precious  546 MiB  Nov 09 2018 11:09  /dev/stratis/stratis_howto/my_precious
```

## Mount the file system

```
# mount /dev/stratis/stratis_howto/fs_howto /mnt
```

## Add mount point to `/etc/fstab` using file system UUID

You can use `/dev/stratis/<pool name>/<file system name>` but each time you rename a pool or file system you will need to update `/etc/fstab`, thus using file system UUID is recommended.

```
# blkid -p /dev/stratis/stratis_howto/fs_howto
/dev/stratis/stratis_howto/fs_howto: UUID="a38780e5-04e3-49da-8b95-2575d77e947c" TYPE="xfs" USAGE="filesystem"

# echo "UUID=a38780e5-04e3-49da-8b95-2575d77e947c /mnt xfs defaults 0 0" >> /etc/fstab
```

# Other useful pool operations

## `add-data`: Add a disk to an existing pool

```
# stratis pool add-data tale_of_2_disks /dev/sdc

# stratis pool list
Name               Total Physical Size  Total Physical Used
stratis_howto                    1 TiB               52 MiB
tale_of_2_disks               2.02 TiB               60 MiB
```

## `rename`: Rename a pool

```
# stratis pool rename tale_of_2_disks 3_amigos

# stratis pool list
Name             Total Physical Size  Total Physical Used
3_amigos                    2.02 TiB               60 MiB
stratis_howto                  1 TiB               52 MiB
```

## `init-cache`: Initialize cache and add block device as cache device (typically something like SSD)

```
# stratis pool init-cache 3_amigos /dev/sde
```

## `add-cache`: Add a block device as cache to a pool with an existing cache

```
# stratis pool add-cache 3_amigos /dev/sdg
```

## `destroy`: Destroy a pool, no file systems can exist in pool

```
# stratis pool destroy 3_amigos

# stratis pool list
Name             Total Physical Size  Total Physical Used
stratis_howto                  1 TiB               52 MiB
```

# Other useful file system operations

## `destroy`: Remove a Stratis provided filesystem

To remove a Stratis provided filesystem, make sure that it’s not in use, and then destroy it.

```
# stratis filesystem list
Pool Name      Name         Used     Created            Device
olympic        backstroke   546 MiB  Nov 09 2018 11:10  /dev/stratis/olympic/backstroke
stratis_howto  fs_howto     546 MiB  Nov 09 2018 11:08  /dev/stratis/stratis_howto/fs_howto
stratis_howto  my_precious  546 MiB  Nov 09 2018 11:09  /dev/stratis/stratis_howto/my_precious

# stratis filesystem destroy stratis_howto my_precious

# stratis filesystem list
Pool Name      Name        Used     Created            Device
olympic        backstroke  546 MiB  Nov 09 2018 11:10  /dev/stratis/olympic/backstroke
stratis_howto  fs_howto    546 MiB  Nov 09 2018 11:08  /dev/stratis/stratis_howto/fs_howto
```

## `rename`: Rename a file system

```
# stratis filesystem rename olympic backstroke some_fs
```

## `snapshot`: Create a snapshot

To create a snapshot, which is a read/writeable thinly provisioned point in time copy of the source FS.

```
# stratis filesystem snapshot olympic some_fs some_fs_snapshot

# stratis filesystem list olympic
Pool Name  Name              Used     Created            Device
olympic    some_fs           546 MiB  Nov 09 2018 11:10  /dev/stratis/olympic/some_fs
olympic    some_fs_snapshot  546 MiB  Nov 09 2018 11:26  /dev/stratis/olympic/some_fs_snapshot
```

# Misc. operations

Query which block devices belong to a pool or all of Stratis.

```
# stratis blockdev list olympic
Pool Name  Device Node    Physical Size   State  Tier
olympic    /dev/sdc            2.00 TiB  In-use  Data

# stratis blockdev list
Pool Name      Device Node    Physical Size   State  Tier
olympic        /dev/sdc            2.00 TiB  In-use  Data
stratis_howto  /dev/sdb               1 TiB  In-use  Data
```

Query the Stratis daemon (`stratisd`) version.

```
# stratis daemon version
1.0.1
```
