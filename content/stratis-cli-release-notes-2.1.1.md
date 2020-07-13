+++
title = "stratis-cli 2.1.1 Release Notes"
date = 2020-07-14
weight = 10
template = "page.html"
render = true
+++

stratis-cli 2.1.1 fixes a bug where if one encrypted pool could not be
unlocked, execution terminated, and no attempt was made to unlock any other
pools that might need to be unlocked ([stratis issue 618]).

It also introduces an improved error message in the case where the daemon
is not running and extends the documentation for the `--capture-key` and
`--keyfile-path` command-line options.

[stratis issue 618]: https://github.com/stratis-storage/stratis-cli/issues/618

<!-- more -->

Please consult the changelog for additional information about the release.
