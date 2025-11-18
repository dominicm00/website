<!--
SPDX-FileCopyrightText: 2022 Dominic Martinez <dom@dominicm.dev>

SPDX-License-Identifier: GPL-3.0-or-later
-->

# Dominic's Website

Welcome to my personal site! This is a work in progress so there isn't much here for the moment.

## Structure

All the content is written in Markdown and rendered with [Haunt](https://dthompson.us/projects/haunt.html).

## Building

[GNU Guix](https://guix.gnu.org/) is used to automatically create the correct environment; this is the only official method for building the site.

You can launch an interactive development environment using the provided manifest file:

```shell
guix shell -m manifest.scm
```

You can then use any [Haunt](https://files.dthompson.us/docs/haunt/latest/index.html) command to develop the site:

```shell
haunt build && haunt serve --watch
```

## Publishing

This site is published on [sourcehut pages](https://srht.site/) using Haunt's built-in sourcehut publisher.

```shell
haunt build && haunt publish
```
