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

<!-- more -->

### IPC
Stratis relies on D-Bus for interprocess communication between the daemon and the
client. D-Bus does not currently ship in the initramfs so the first order of business
was to choose an alternate form of IPC. Because we require the ability to pass a file
descriptor from the client to the daemon, this made Unix sockets the only reasonable
transport mechanism. After evaluating several JSON RPC libraries with Unix socket
support, we decided to write a minimal RPC interface ourselves. This was due to a
few constraints:

* JSON RPC libraries with Unix socket support did not support setting the ancillary
data for packets required to send file descriptors.
* The libraries had relatively complicated threading models, and we preferred to take
a simple approach of processing each new request using a Tokio task.
* It was relatively trivial to serialize full data structures as JSON thanks to
[`serde_json`].

This approach proved successful and we were able to implement an IPC mechanism
that left our internal stratisd API unchanged. The alternate IPC mechanism is
distributed in a separate pair of executables, stratis-min and stratisd-min.

### Support in the initramfs
The next step was to integrate stratisd-min into the initramfs. This involved quite a
bit of configuration for dracut and systemd.

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

If the user requires networking (for example, unlocking a pool using Tang), the
parameter `rd.neednet=1` is required as well.

### Testing on Fedora using Anaconda
This process was relatively simple once it came time to test with Fedora. Anaconda
provides the parameter `--dirinstall` which allows the user to install into a path
with the mounted Stratis filesystem as the root directory. It requires a bit more
configuration after the fact (manual `/etc/fstab` or `.mount` file configuration) but
works quite well.

### `/etc/fstab` or `.mount` files
We now also provide a systemd service to manage setting up non-root filesystems in
/etc/fstab.  For devices that require a passphrase or are critical for a working
system, the following line can be used:

`/dev/stratis/[STRATIS_SYMLINK] [MOUNT_POINT] xfs defaults,x-systemd.requires=stratis-fstab-setup@[POOL_UUID].service,x-systemd.after=stratis-fstab-setup@[POOL_UUID].service 0 2`

The absence of `nofail` here is due to the fact that `nofail` causes the boot to
proceed prior to a successful mount. This means that passphrase prompts
will not work properly, and most users will want critical system partitions to be
mounted successfully or else have the boot fail.

For devices that do not require interaction to set up, such as unencrypted devices or
devices that have Clevis bindings, and are not critical for a working system, the
following line can be optionally used:

`/dev/stratis/[STRATIS_SYMLINK] [MOUNT_POINT] xfs defaults,x-systemd.requires=stratis-fstab-setup@[POOL_UUID].service,x-systemd.after=stratis-fstab-setup@[POOL_UUID].service,nofail 0 2`

The addition of `nofail` here will cause mounting of this device to proceed
independently from the boot which can speed up boot times. The set up process will
continue running in the background until it either succeeds or fails.

Because the root filesystem is mostly set up in the initramfs, the entry is slightly
different and does not require the `stratis-fstab-setup` service. It should be:

`/dev/stratis/[STRATIS_SYMLINK] / xfs defaults 0 1`

### Recovery console
While we mention above that stratisd could previously be used in the initramfs, there
is one major caveat: it could be started but commands could not be issued. This had
one major drawback of not allowing users to interact with stratisd in the recovery
console. D-Bus is not available in the recovery console, so the move to stratis-min
and stratisd-min now allows users to perform recovery actions in the emergency console
by starting stratisd-min and running the necessary commands using stratis-min. This
will make rescuing systems that do not boot significantly easier moving forward.

### Scope of dracut modules and systemd service files
While our dracut modules and systemd service files are meant to work for almost all
users, they may not meet the requirements of everyone using them. We encourage those
with more advanced configurations to design their own configurations and reach out
for guidance as needed. Our configuration is also meant as a template that you can
build on!

### Conclusion
While this took quite a bit of effort to put all of the pieces together, the Linux
boot utilities had all of the features we needed to accomplish this. We're excited
for future work with other teams to make using Stratis as the root filesystem
for Linux installations even easier!

### Release version
All of the utilities required for booting from a Stratis filesystem as the root
filesystem will be included in stratisd 2.4.0.

### Corrections
* The `/etc/fstab` examples previously omitted `.service` for `stratis-fstab-setup`. systemd
assumes that any unit dependency in `/etc/fstab` is a `.mount` unit file unless explicitly
specified, so the examples as previously written would cause a failed boot unless `nofail`
was specified.

### Fedora specific set up
See [this guide] for specific setup steps on Fedora.

[this guide]: @/stratis-rootfs-fedora.md
