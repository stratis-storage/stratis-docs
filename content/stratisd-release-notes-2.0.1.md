+++
title = "stratisd 2.0.1 Release Notes"
date = 2020-02-10
weight = 8
template = "page.html"
render = true
+++

February 10, 2020

stratisd 2.0.1 contains a number of internal improvements as well as
enhanced logging.

<!-- more -->

A code defect which made it possible to leave the thinpool suspended on an
error was fixed ([stratisd issue 1730]).

The device discovery implementation was improved; computational complexity
was reduced and additional logging on unusual events was added.

The D-Bus layer was restructured to more cleanly suppport multiple versioned
D-Bus interfaces.

All macros were rewritten to use fully qualified names to improve code
stability.

Please consult the changelog for additional information about the release.

We would like to thank our external contributor GuillaumeGomez for further
work on metadata refactoring ([stratisd issue 1573]).

[stratisd issue 1573]: https://github.com/stratis-storage/stratisd/issues/1573
[stratisd issue 1730]: https://github.com/stratis-storage/stratisd/issues/1730
