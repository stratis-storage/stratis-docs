+++
title = "Stratis 2.3.0 Release Notes"
date = 2020-11-09 # FIXME
weight = 14
template = "page.html"
render = true
+++

Stratis 2.3.0 adds additional flexibility to its encryption support via
Clevis [clevis].

stratis 2.3.0
-------------
This release extends the `pool unlock` command, and adds two new commands,
`pool bind` and `pool unbind`.

The `pool bind` command establishes an alternative mechanism for unlocking
a pool. The user may select either the "tang" mechanism, which implements
NBDE (Network-bound Disc Encryption) by means of a Tang server, or the
"tpm" mechanism, which uses TPM (Trusted Platform Module) encryption. Binding
the devices in a pool to a supplementary Clevis encryption policy does not
remove the primary encryption mechanism, which uses a key in the kernel keyring.

The `pool unbind` command simply unbinds a previously added encryption
policy from all the devices in the specified pool.

In the `pool unlock` command it is now necessary to specify the mechanism.
Use `clevis` to make use of the Clevis unlocking policy previously
specified for the devices in the pool. Use `keyring`, to make use of the
mechanism that uses a key in the kernel keyring, which was introduced
in Stratis 2.1.0. Note that the `pool unlock` command unlocks all currently
locked pools.

stratisd 2.3.0
--------------
This release introduces two D-Bus interface revisions, which differ in the
following way from the previous revisions.

`org.storage.stratis2.Manager.r3` modifies the `UnlockPool` method to take
an additional parameter, `unlock_method`, which may be `keyring` or `clevis`.

`org.storage.stratis2.pool.r3` adds two new method: `Bind` and `Unbind`.
The `Bind` method takes two arguments, `pin` and `json`. The `pin` argument
designates the Clevis pin as a string, and the `json` argument encodes
a Clevis configuration appropriate to the designated pin. The configuration
is a JSON object. Besides Clevis information, it may include Stratis-specific
keys that encode configuration decisions that Stratis may implement. At
present there is just one such key: `stratis:tang:trust_url`.
The `Unbind` method reverses a `Bind` action.

Remarks
-------

The `Bind` method may be called with any Clevis pin and configuration.
However the Stratis project supports only the "tang" and "tpm" pins as those
are the pins that may be designated via `stratis`. Support for additional
Clevis policies may be introduced into `stratis` in later releases.

<!-- more -->

Please consult the changelogs for additional information about the release.

[clevis]: https://github.com/latchset/clevis
