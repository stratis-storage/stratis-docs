+++
title = "On-disk metadata format and storage stack modifications"
date = 2025-02-19
weight = 40
template = "page.html"
render = true
+++

*John Baublitz, Stratis Team*

Until now, Stratis has had a metadata format that, with a few exceptions, works
remarkably well for our current feature set. However, as we plan for more features
like RAID, integrity, and online reencryption, we've decided that we require some
reworks to the order of our devicemapper devices in the storage stack and the addition
of space reservation ahead of time for the metadata of new devicemapper layers. The
metadata rework has been a large effort to pave the way for Stratis moving forward and
will provide the ability for additional flexibility in enabling and disabling certain layers
after pool creation time once the features are added.

### Support for V1

V1 will continued to be supported as-is. Features that no longer work on V1 of the metadata
will be considered bugs, and we intend to continue releasing bug fixes for functionality that
breaks, even if it is only in V1. However, creating new V1 pools is disabled, and users will
only be able to create V2 pools in the next version of stratisd.

### Changes to encryption

The modifications to how we handle encryption are the single largest difference
between V1 and V2 of the metadata. The crypt device now sits above the Stratis metadata
and where RAID and integrity will be in the stack.

Let's dive into the practical applications of this.

#### Switch from full disk encryption

V1 of the metadata provided full disk encryption, but V2 will not. Data, cache, and
thinpool/filesystem metadata will all still be encrypted, but integrity metadata, RAID
metadata, and the Stratis metadata, which is generally just a record of the devicemapper
tables for the Stratis pool, will not be encrypted.

We discussed this at length with the cryptsetup maintainers and the security team and the
general consensus is that leaving this data unencrypted will not result in leaking any
information about the encrypted data stored above it in the stack.

#### Higher position in the stack

The switch of encryption's position in the stack also has a surprising number of benefits.

Firstly, the operation time on encrypted pools no longer scales linearly according to the
number of devices. Because Stratis can add additional devices to a single pool, FDE required
encrypting each new device with its own crypt device which resulted in having to pass
through PBKDF once for each device. This increased execution times for operations like unlock
based on how many devices were in the pool. For V2 of the metadata, operations that require PBKDF
execute in constant time.

Secondly, the encryption layer will be on top of the caching layer. This simplifies the cache handling
and requires no special handling for encrypting cached data.

Thirdly, this will avoid the problem we would have run into with RAID of encryption amplification.
Because previously each leg would have its own crypt device, the CPU load of encryption would
have been multiplied by the number of legs in the RAID array. This would result in reduced throughput
due to too much CPU load encrypting each leg separately.

### Addition of metadata space reservation

In V2 of the metadata layout, we've begun reserving space for the crypt header and integrity metadata. The end
result of this is that in future versions, we will increasingly be able to toggle certain features
on and off after pool creation time. Work has already begun on supporting this for encryption, and we intend to
do this at least for integrity as well. We are still discussing the best way to support this for RAID given
certain restrictions in the case of converting from a multi-disk pool to a RAID array.

### Backports

Moving forward, we intend to port all features that are compatible with V1 of the metadata layout back to V1, but
for features that cannot be backported like turning encryption on and off due to the differences outlined here,
we recommend that users migrate data to a V2 pool to take advantage of these upcoming features.

Please let us know what you think of the new metadata layout in a Github issue!
