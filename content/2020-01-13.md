+++
title = "Cryptsetup Rust bindings release"
date = 2020-01-13
weight = 6
template = "page.html"
render = true
+++

Monday January 13, 2020

One major focus in the Stratis project recently has been adding an encryption layer
for data in Stratis pools. Cryptsetup provides a library backend for programmatically
setting up device encryption, so we decided to write Rust bindings to access the
existing Cryptsetup functionality in Rust.

While designing the bindings, we took every opportunity to make use of Rust's
type system, leveraging features like reference lifetimes and type parameters
to ensure that as much of our public API as possible can be validated by the
compiler.

Though these bindings were designed with Stratis in mind, it is intended
to be general-purpose and so we encourage others to try it out. The license
is MPLv2, but it becomes effectively GPL when linked with libcryptsetup.
As a result, any project using our bindings will also need to be GPL or
GPL-compatible.

If you're interested in seeing more, you can find [the repository here].


<!-- more -->

[the repository here]: https://github.com/stratis-storage/libcryptsetup-rs
