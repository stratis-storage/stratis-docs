+++
title = "stratis-cli 2.0.1 Release Notes"
date = 2020-01-21
weight = 7
template = "page.html"
render = true
+++

Sunday January 21, 2020

stratis-cli 2.0.1 contains a number of internal improvements as well as
some improvements to certain error messages.

<!-- more -->

We expect that most current users will notice very little if any change;
we hope that new users will benefit from error messages that they can
more directly relate to the commands that they have typed. In order to
achieve this, the internal exception hierarchy was refined, and some new
exception classes were added.

The man pages have been updated to include a precise specification of every
field displayed by any of the `list` subcommands.

Contributors to the source will observe that our CI now requires 100% code
coverage.

Please consult the changelog for additional information about the release.

We would like to thank our external contributor carzacc for further work
on bash tab-completion ([stratis-cli pull 446]).

[stratis-cli pull 446]: https://github.com/stratis-storage/stratis-cli/pull/446
