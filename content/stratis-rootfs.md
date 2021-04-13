+++
title = "Stratis filesystems as the root filesystem"
date = 2021-04-12
weight = 16
template = "page.html"
render = true
+++

*John Baublitz, Stratis Team*

While Stratis unencrypted pools could previously be used as the root filesystem
for a Linux installation with proper customization of the initramfs, our most
recent feature provides all of the plumbing to fully support Stratis filesystems
as the root filesystem of a Linux installation.

### IPC
Stratis relies on D-Bus for interprocess communication between the daemon and the
client. D-Bus does not currently ship in the initramfs so the first order of business
was to choose an alternate form of IPC. Because we require the ability to pass a file
descriptor from the client to the daemon, this made Unix sockets the only reasonable
transport mechanism. After evalutating several JSON RPC libraries with Unix socket
support, we decided to write a minimal RPC interface ourselves. This was due to a
few constraints:

* JSON RPC libraries with Unix socket support did not support setting the ancillary
data for packets required to send file descriptors.
* The libraries had relatively complicated threading models, and we preferred to take
a simple approach of processing each new request using a Tokio task.
* It was relatively trivial to serialize full data structures as JSON thanks to
[`serde_json`].

This approach proved successful and we were able to implement an IPC mechanism
that left our internal stratisd API unchanged.

### Support in the initramfs
The next step was to integrate stratisd with a minimal IPC mechanism into the
initramfs. This involved quite a bit of configuration for dracut and systemd.

Our current model uses systemd generators that are enabled by passing information on
the kernel command line at boot to properly set up and unlock any devices that need
to be unlocked. We aim to do this in as user-friendly of a way as possible by
leveraging existing tools like Plymouth to handle prompting users for a passphrase
on the splash screen.

To set up the generators and necessary dependencies, we wrote two dracut modules:
stratis and stratis-clevis. stratis-clevis depends on stratis and is required for
automated unlocking using clevis.

The required information on the kernel command line is:

* ` root=[STRATIS_FS_SYMLINK]`: The symlink under `/dev/stratis` that corresponds to
the desired Stratis filesystem. This is required by dracut.
* ` stratis.rootfs.pool_uuid=[POOL_UUID]`: The UUID of the pool that contains the
root filesystem.
* ` stratis.rootfs.uuid_paths=/dev/disk/by-uuid/[DEVICE_UUID]`: The UUID of one of the
devices required to assemble the Stratis pool. All devices in the pool must be
specified and this kernel command line parameter can be specified multiple times.

If the user requires networking (for example, unlocking a pool using Tang), the
parameter `rd.neednet=1` is required as well.

### Testing on Fedora using Anaconda
This process was relatively simple once it came time to test with Fedora. Anaconda
provides the parameter `--dirinstall` which allows the user to install into a path
with the mounted Stratis filesystem as the root directory. It requires a bit more
configuration after the fact (manual `/etc/fstab` or `.mount` file configuration) but
works quite well.

### `/etc/fstab` or `.mount` files the right way
Because systemd generates mount files from `/etc/fstab`, we also needed to provide a
service to set up pools at filesystem mount time. Similarly to the initramfs, D-Bus
is not available at this point in the boot process. For this, we use the same JSON
RPC mechanism for IPC. The service file used to set up filesystems in `/etc/fstab` is
roughly equivalent to the generated service files in the initramfs. It can be invoked
setting the following entry in `/etc/fstab`:

`/dev/stratis/mypool/myfs / xfs defaults,x-systemd.requires=stratis-fstab-setup@[POOL_UUID],x-systemd.after=stratis-fstab-setup@[POOL_UUID] 1 1`

where `POOL_UUID` is replaced by the pool containing your filesystems.

This will cause the setup script to be run and the mount will not proceed until it has
been completed successfully.

### Conclusion

While this took quite a bit of effort to put all of the pieces together, the Linux
boot utilities had all of the features we needed to accomplish this. We're excited
for future work with other teams to make using Stratis as the root filesystem
for Linux installations even easier!

<!-- more -->

[`serde_json`]: https://github.com/serde-rs/json
