+++
title = "Stratis 1.0 Release Notes"
date = 2018-09-28
weight = 2
template = "page.html"
render = true
+++

Friday September 28, 2018

# New Features

## Initial Stable Stratis Release

Stratis is a Linux local storage management tool that aims to enable easy use of advanced storage features such as thin provisioning, snapshots, and pool-based management and monitoring.

After two years of development, Stratis 1.0 has stabilized its on-disk metadata format and command-line interface, and is ready for more widespread testing and evaluation by potential users. Stratis is implemented as a daemon – `stratisd` – as well as a command-line configuration tool called stratis, and works with Linux kernel versions 4.14 and up.

<!-- more -->

Packages will soon be available for Fedora. We also hope that other Linux distributions consider packaging Stratis 1.0 components (although this will require support for Rust 1.25+ and Python 3).

# Open Issues

## Rapid Growth of Used Storage in Pool May Cause Errors

Rapid increase in the data stored in the pool, such as creating tens of filesystems in a loop, may cause filesystem creation to fail intermittently. Writing large amounts to filesystems in parallel may also trigger this. ([issue 1152])

## D-Bus API not yet stable

The Stratis development team has not yet declared Stratis’ D-Bus API as stable. We recommend waiting until it is, to integrate Stratis support into other tools. In the meantime, the stratis command-line tool can be used to configure and monitor Stratis pools. ([issue 1237])

## dm-cache issue in 4.18.7+ kernels affects Stratis Cache Tier

An issue with dm-cache that affects Stratis cache tier creation was introduced into the 4.18.7 stable release. Users interested in using a cache tier should avoid this and later kernels in the 4.18 series. This issue will be fixed in 4.19. ([issue 1212])

[issue 1152]: https://github.com/stratis-storage/stratisd/issues/1152
[issue 1212]: https://github.com/stratis-storage/stratisd/issues/1212
[issue 1237]: https://github.com/stratis-storage/stratisd/issues/1237
