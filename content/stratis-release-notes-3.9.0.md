+++
title = "Stratis 3.9.0 Release Notes"
date = 2026-04-27
weight = 43
template = "page.html"
render = true
+++

*mulhern, Stratis Team*

Stratis 3.9.0, which consists of `stratisd 3.9.0` and `stratis-cli 3.9.0`
introduces two major new features.

## Online Encryption, Decryption, and Reencryption
With Stratis 3.9.0 it is now possible to perform in-place encryption,  
decryption, and reencryption of Stratis pools. Previously, the decision 
whether or not a pool should be encrypted had to be made when the pool was
created. With Stratis 3.9.0 the storage administrator may choose to encrypt
a pool after it has been put into use. Moreover, with Stratis 3.9.0, it is
possible to reencrypt a pool, i.e., to change the key used to encrypt the
pool, a task that may be performed as a housekeeping measure or in the case
a key is known to have been compromised.

## Starting a Stratis Pool Without its Cache
With Stratis 3.9.0 it is now possible to start a pool while explicitly
instructing stratisd not to set up the pool's cache. This facility can be
useful if the pool's cache devices are missing or otherwise unusable. Once
the pool is set up, it is a pool without a cache; restoring the cache
requires adding new cache devices to the pool.

<!-- more -->

Please consult the [stratisd] and [stratis-cli] changelogs for additional
information about the release.

[stratisd]: https://github.com/stratis-storage/stratisd/blob/master/CHANGES.txt 
[stratis-cli]: https://github.com/stratis-storage/stratis-cli/blob/master/CHANGES.txt
