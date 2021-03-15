+++
title = "stratis-cli 1.1.0 Release Notes"
date = 2019-10-02
weight = 4
template = "page.html"
render = true
+++

*mulhern, Stratis Team*

With this release stratis now recognizes an environment variable,
`STRATIS_DBUS_TIMEOUT`. This environment variable controls the timeout for
any individual D-Bus call that stratis makes. You may want to set it to a
higher value than the default, which is 120 seconds, if you are running
tests or otherwise scripting via stratis, and wish to avoid erroneous errors
resulting from slow operations in your testing environment. See
[stratis-cli issue 252] for further details.

This release also introduces simplified and more complete error-reporting.
For stratis, it constitutes an error if any command issued results in a
Python stack trace. If you experience any such incident, please
report it in a GitHub issue, including the full stack trace, and
circumstances that led up to the incident.

<!-- more -->

This release also includes a minor bug fix ([stratis-cli issue 248]) and an
enhancement to the bash tab-completion facilities ([stratis-cli pull 300]).

We would like to thank our external contributors carzacc and poizen18 for
their work on bash tab-completion ([stratis-cli pull 300])

[stratis-cli issue 248]: https://github.com/stratis-storage/stratis-cli/issues/248
[stratis-cli issue 252]: https://github.com/stratis-storage/stratis-cli/issues/252
[stratis-cli pull 300]: https://github.com/stratis-storage/stratis-cli/pull/300
