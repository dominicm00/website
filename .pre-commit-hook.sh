#!/bin/sh

# SPDX-FileCopyrightText: 2023 Dominic Martinez <dom@dominicm.dev>
#
# SPDX-License-Identifier: GPL-3.0-or-later

TMPDIR=$(mktemp -d)/
git checkout-index --prefix=$TMPDIR -af
cd $TMPDIR

guix shell -m manifest.scm -- reuse lint || exit 1

rm -rf $TMPDIR