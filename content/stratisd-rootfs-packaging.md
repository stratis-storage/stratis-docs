+++
title = "Packaging for stratisd 2.4.1"
date = 2021-05-18
weight = 19
template = "page.html"
render = true
+++

*mulhern, Stratis Team*

For Fedora packaging, we have decided to split out the dracut support into
a separate subpackage, `stratisd-dracut`. This package must be installed
in order to support booting from a Stratis filesystem. All other
functionality is included in the `stratisd` package.

The motivation for this change is to allow users greater flexibility and
robustness. We understand that some users may choose to use Stratis but not to
use Stratis for their root filesystem. These users may choose to install only
the `stratisd` package.

Other users may prefer to use a Stratis root filesystem. They should install
the `stratisd-dracut` package, which has a hard dependency on the `stratisd`
package. The `stratisd-dracut` package also includes a hard dependency on
`dracut` itself and on `plymouth`. `plymouth` is used in order to obtain a
password to unlock an encrypted Stratis root filesystem. Please consult
[Stratis filesystem as the root filesystem] for further information about
Stratis support for a root filesystem.

We decided to implement this division due to a problem which would ensue
if stratisd was installed but plymouth was not. In that case, the dracut
module would not be installed in the initrd, and a subsequent reboot, when
using a Stratis root filesystem, would fail.

The solution of adding plymouth as a hard requirement for stratisd would
place an unnecessary dependency burden on a user who did not choose to
maintain a Stratis root filesystem. However, without such a requirement a
user who did choose to maintain a Stratis root filesystem might encounter a
failure to boot if plymouth was not installed when the initrd was created.

We believe that a separate subpackage is the most robust and flexible
solution; it is one which requires no manual intervention by the user.

To properly construct the stratisd-dracut subpackage, it is imperative that
the stratisd source code be compiled twice; once with the default features,
in order to build stratisd itself, and again with a different set of
features, in order to correctly build supporting scripts for the dracut
module.

We recommend that other downstream packagers adopt a similar scheme.

<!-- more -->

Please consult the [Fedora stratisd package repository] for an example
of the packaging approach used.

`stratis`, the Stratis CLI, will continue to have a hard dependency on
the stratisd package, but not on the stratisd-dracut subpackage.

We would like to thank our users who correctly identified and reported
the problems that we have addressed in this and other recent packaging
improvements: Matthias Berndt, Vojtech Trefny, and Yanko Kaneti.

[Fedora stratisd package repository]: https://src.fedoraproject.org/rpms/stratisd
[Stratis filesystems as the root filesystem]: https://stratis-storage.github.io/stratis-rootfs/
