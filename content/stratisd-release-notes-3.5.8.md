+++
title = "stratisd 3.5.8 Release Notes"
date = 2023-07-30
weight = 34
template = "page.html"
render = true
+++

*mulhern, Stratis Team*

`stratisd` 3.5.8 principally contains changes to make handling of partially  
set up or torn down pools more robust. It also fixes a few errors and omissions
in the management of `stratisd`'s D-Bus layer, including supplying some
previously missing D-Bus property change signals and removing D-Bus object
paths to partially torn down pools which had in some cases persisted past the
point when the pool should be considered stopped. In addition, it removes
the `dracut` subpackage's dependency on plymouth.

<!-- more -->

Please consult the [stratisd] changelog for additional information about the
release.

We would like to thank matthias\_berndt for contributions to this release. 

[stratisd]: https://github.com/stratis-storage/stratisd/blob/patch-3.5.4/CHANGES.txt 
