+++
title = "Stratis 3.8.2 Release Notes"
date = 2025-12-16
weight = 42
template = "page.html"
render = true
+++

*mulhern, Stratis Team*

Stratis 3.8.2, which consists of `stratisd 3.8.2` and `stratis-cli 3.8.2`
adds a facility for maintaining keys of an encrypted pool.

`stratisd` now maintains an encrypted pool's volume key in the `stratisd`
process keyring. The key is automatically loaded into the process keyring
by `stratisd` when the pool is unlocked or when `stratisd` is started when
an encrypted pool is already set up. The key is removed when `stratisd`
exits or when the pool is destroyed or stopped. This ensures that when
`stratisd` extends the pool, something that `stratisd` does automatically
when it judges that circumstances require it, the extension of the pool's
crypt device will not fail due to missing encryption information.

`stratisd` now supports a pool-level DBus property, `VolumeKeyLoaded`,
which is:
* false if the pool is a V1 pool or not encrypted
* true if the pool is a V2 pool and encrypted and all is well
* an error message otherwise 

If the pool is a V2 encrypted pool and the `VolumeKeyLoaded` property is
not true, `stratis-cli` will display an alert in its pool listing.

Subsequent releases of `stratisd` were made to address the following:
* 3.8.3: Failure to build on a newly supported architecture due to an
outdated libmount dependency.
* 3.8.4: Failure to build with a new version of systemd libraries due to
bindgen-generated uncompilable test code.
* 3.8.5: Change to numbering of stratis dracut modules to conform to
new dracut ordering requirements.
* 3.8.6: Failure to build introduced by Rust 1.90.0 due to redundant
parentheses in a map closure.

The subsequent release of `stratis-cli`, `stratis-cli 3.8.3`, adds some man 
page entries omitted in `stratis-cli 3.8.2`. 

<!-- more -->

Please consult the [stratisd] and [stratis-cli] changelogs for additional
information about the release.

[stratisd]: https://github.com/stratis-storage/stratisd/blob/patch-3.8.2/CHANGES.txt 
[stratis-cli]: https://github.com/stratis-storage/stratis-cli/blob/master/CHANGES.txt
