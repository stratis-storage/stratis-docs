+++
title = "stratisd 1.0.6 Release Notes"
date = 2019-10-02
template = "page.html"
render = true
+++

Wednesday October 2, 2019

This release includes one significant bug fix and a substantial refactoring.

The bug was caused by an inconsistency in the metadata handling which led to
a failure to properly update the Stratis metadata if stratisd was restarted
in an environment where the system clock indicated a time earlier than when
it had previously been running. See [stratisd issue 1509] for further
details.

This release also includes significant refactoring of the stratisd metadata
handling for clarity and modularity and to use types to enforce distinctions
among the sizes of different metadata regions ([stratisd issue 1573]).

<!-- more -->

Additional changes include demoting a log message to a level appropriate
to its significance ([stratisd issue 1485]) and specifying the stratisd PID
file using the path `/run/stratisd.pid` instead of `/var/run/stratisd.pid`
([stratisd issue 1632]).

We would like to thank our external contributors:
* sergeystepanovx for reporting [stratisd issue 1509] and for testing the fix
* GuillaumeGomez for many metadata refactoring contributions
([stratisd issue 1573])

[stratisd issue 1485]: https://github.com/stratis-storage/stratisd/issues/1485
[stratisd issue 1509]: https://github.com/stratis-storage/stratisd/issues/1509
[stratisd issue 1573]: https://github.com/stratis-storage/stratisd/issues/1573
[stratisd issue 1632]: https://github.com/stratis-storage/stratisd/issues/1632
