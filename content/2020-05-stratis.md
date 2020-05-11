+++
title = "Stratis 2.1.0 Release Notes"
date = 2020-03-31
weight = 9
template = "page.html"
render = true
+++

UNRELEASED

Stratis 2.1.0 introduces support for encryption.

It supports per-pool encryption of the devices that form a pool's data
tier. A pool may be encrypted, or its constituent encrypted devices may
be activated, by means of a key stored in the kernel keyring.

stratisd 2.1.0
--------------
This release implements encryption support and adds several new D-Bus
interfaces to administer or monitor that support.

It implements encryption support in the following way:
  * A single instance of stratisd can support both encrypted and unencrypted
    pools.
  * The choice to encrypt a pool must be made at the time a pool is created.
  * At present, the use of a cache and of encryption are mutually exclusive;
    if the pool is created with encryption enabled, then it is not possible
    to create a cache.
  * Each pool may be encrypted by means of a key in the kernel keyring; each
    encrypted pool may make use of a different key, but all devices in a pool
    are encrypted with a single key.
  * Any additional devices that are added to an encrypted pool's data tier
    will be encrypted using the key that was specified when the pool was
    initialized.

stratisd 2.1.0 supplies several new D-Bus interfaces:
  * `org.storage.stratis2.manager.r1`: This interface supplies an
    extended `CreatePool` method, to support an optional argument for
    encryption. In addition, it supplies a number of method for key
    management.
  * `org.storage.stratis2.pool.r1`: This interface supports explicit
    initialization of a cache tier. Previously, a cache was initialized as
    a side-effect of the addition of the first device to the cache tier.
    It also supports the new `Encrypted` property.
  * `org.storage.stratis2.FetchProperties.r1`: This interface supports an
    additional `HasCache` property.
  * `org.storage.stratis2.Report.r1`: This interface supports a set of
    ad-hoc reports about Stratis. The interface is unstable; the names by
    which the reports can be accesed are not guaranteed to remain stable,
    and the format of any report is only guaranteed to be valid JSON.

Please consult the D-Bus API Reference for the precise D-Bus specification.

The following are significant implementation details:
  * Each block device in an encrypted pool's data tier is encrypted with a
    distinct, randomly chosen MEK (Media Encryption Key) on initialization.
  * All devices belonging to a single encrypted pool share a single passphrase,
    supplied via the kernel keyring.
  * The release requires cryptsetup version 2.3.



We would like to thank our external contributor GuillaumeGomez for further
work on metadata refactoring ([stratisd issue 1573]).

[stratisd issue 1573]: https://github.com/stratis-storage/stratisd/issues/1573

stratis-cli 2.1.0
-----------------
This release requires stratisd 2.1.0. The user will observe the following
changes:

  * The `pool create` command has been extended to allow encryption.
  * There is a new `pool init_cache` command, for initializing a cache.
  * There is a new subcommand, `key`, for key management tasks.
  * The output of `pool list` now includes a `Properties` column; each
    entry in the column is a string encoding the following properties of the
    pool:
    - whether or not it has a cache
    - whether or not it is encrypted

<!-- more -->

Please consult the changelogs for additional information about the release.