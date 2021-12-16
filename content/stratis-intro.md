+++
title = "Stratis Description"
date = 2021-12-09
weight = 99
template = "page.html"
render = true
+++

*Dennis Keefe, Stratis Team*

### Stratis Description ###

Stratis is a tool to easily configure pools and filesystems with enhanced
storage functionality that works within the existing Linux storage
management stack.  To achieve this, Stratis prioritizes a straightforward
command-line experience, a rich API, and a fully automated approach to storage
management. It builds upon elements of the existing storage stack as much as
possible.  Specifically, Stratis uses device-mapper, LUKS, XFS, and Clevis. 
Stratis may also incorporate additional technologies in the future.

<!-- more -->

Stratis can configure an encrypted or unencrypted pool of storage with one or
more file systems quickly and without prior knowledge of the many storage
layers and commands.

Linux has a number of storage technologies that provide advanced functionality
to applications for accessing and storing data.  Examples of some of these
products that Stratis uses are:

* device-mapper - A framework for logical to physical mapping of data blocks
* LUKS          - An on disk format for encryption that can securely manages
                multiple passwords
* XFS           - A scalable, journaling, and performant filesystem
* Clevis        - A framework for automated decryption

Learning and gaining experience in a number of different storage technologies
can take many years.  Each of those technologies may have their own unique
command-line syntax, APIs, options, and logging.  Stratis simplifies volume
and filesystem management by providing a single CLI and API for users to set up
complex storage stacks without having to spend time learning each independent
storage technology.

### CLI Example ###

The simplicity that Stratis provides can be seen when comparing the CLI
commands used for creating a filesystem that encrypts data-at-rest, to the
method an advanced user would use to configure each layer separately:

Stratis commands to create an encrypted pool and filesystem:
<pre class="file">
# stratis key set testkey --capture-key
    passphrase
# stratis pool create p1 --key-desc testkey /dev/sdb
# stratis fs create p1 fs1
</pre>

Commands an advanced user would use to configure a similar filesystem: 

<pre class="file">
# cryptsetup -y -v luksFormat /dev/sdb
in TUI type YES
    YES
enter passphrase
    passphrase
verify passphrase
    passphrase
# cryptsetup -v luksOpen /dev/sdb luks-device
# pvcreate /dev/mapper/luks-device
# vgcreate -L100 -n lv1 vg1
# mkfs.xfs /dev/mapper/lv1-vg1
</pre>

### API Example ###

Stratis has also built a D-Bus API for developers to implement the storage
management features directly into their project.  The benefits to developers
interested in using Stratis and its D-Bus API would be:

* It provides a feature rich file system and storage management API
* Well designed and tested code ensures the developer can work on the important
details of their project
* Moves the responsibility of maintaining code for setting up storage to the Stratis project.

Here is an example of how to call Stratis D-Bus API using the busctl utility from a
command-line

Create a pool:

>`# busctl call org.storage.stratis3 /org/storage/stratis3 org.storage.stratis3.Manager.r0 CreatePool &quot;s(bq)as(bs)(b(ss))&quot; poolname 0 0 2 /dev/sda /dev/sdb 0 &quot;&quot; 0 &quot;&quot; &quot;&quot;`

Print version:

>`# busctl get-property org.storage.stratis3 /org/storage/stratis3 org.storage.stratis3.Manager.r0 Version`

Print engine state:

>`# busctl call org.storage.stratis3 /org/storage/stratis3 org.storage.stratis3.Manager.r0 EngineStateReport”`

Get ManagedObjects:

>`# busctl call org.storage.stratis3 /org/storage/stratis3 org.freedesktop.DBus.ObjectManager GetManagedObjects`

