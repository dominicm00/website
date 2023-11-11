;; SPDX-FileCopyrightText: 2022 Dominic Martinez <dom@dominicm.dev>
;;
;; SPDX-License-Identifier: GPL-3.0-or-later

(use-modules (guix packages)
             (guix git-download)
             (gnu packages guile-xyz)
             (gnu packages guile)
             (gnu packages autotools)
             (gnu packages texinfo)
             (gnu packages license))

(packages->manifest
 (list guile-syntax-highlight haunt guile-3.0-latest guile-reader reuse))
