# Stratis Documentation

A repository for various kinds of Stratis Documentation.

Built versions of the documentation are available at:
https://stratis-storage.github.io/

All documentation in this repository is licensed under a
Creative Commons Attribution-Share Alike 4.0 International License [license].

.. [license] https://creativecommons.org/licenses/by-sa/4.0

## Contributing

This guide covers building this static site and adding documentation

## Pre-Reqs

This site requires the following binaries:

* [`zola`](https://github.com/getzola/zola) - a single binary static site generator (SSG) written in [Rust](https://rust-lang.org) used for building the website
* [`lyx`](https://www.lyx.org/) - a document processor used for building the PDFs

`zola`'s installation instructions are located [on the getzola.org installation page](https://www.getzola.org/documentation/getting-started/installation/).

`lyx` can be installed by following your OS package manager and/or software installation instructions.

## Building

First we clone the repo:

```
$ git clone https://github.com/stratis-storage/stratis-docs
 [ ... ]

$ cd stratis-docs
```

Now just build the site:

```
$ make
[ ... ]
```

The site can now be served using only the contents of the `public/` directory.

## Editing

Depending on which part of the site you'd like to edit, depends on where the source files are located.

### PDF Documents

The PDF documents are built from the source files in `docs/`

### Release Notes and  other "Front Page Articles"

To add "articles" or "posts" to the front page simply create a Markdown file in `contents/`

But be sure to include a front matter section (the top of the file surrounded by `+++`). You can use other markdown files in the directory as a template for the front matter.

### "Static" (aka Orphan) Pages

Pages in subdirectories of the `content/` directory (such as the `content/static/` directory) are *not* automatically added to the front page and will need to be linked from some other page. These are also known as *orphan* pages. These are still markdown files that will be rendered into HTML files by `zola`.

### Static Content

Any content inside the `static/` directory (*not* `content/static/`) will be copied into the built site verbatim. For example, `static/imgs/stratis_d28445.jpg` -> `public/imgs/stratis_d28445.jpg`.

### Front Page Sidebar

Links can be added adn removed by editing the `config.toml`. Specifically, the `hyde_user_links`, `hyde_developer_links`, or `hyde_contact_links` arrays.

## Theming

The current theme in use is a customized version of [`hyde`](https://github.com/getzola/hyde) whose source and style sheets, and templates can be found in `themes/hyde/`.

## Further Info

More information about how to use `zola` can be found on [getzola.org](https://www.getzola.org)
