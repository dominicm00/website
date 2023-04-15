; SPDX-FileCopyrightText: 2022 Dominic Martinez <dom@dominicm.dev>
;
; SPDX-License-Identifier: CC0-1.0

(use-modules (guix packages)
             (guix git-download)
             (gnu packages guile-xyz)
             (gnu packages guile)
             (gnu packages autotools)
             (gnu packages texinfo)
	     (gnu packages license))

;; Install git hooks
(if (file-exists? ".git/")
    (copy-file ".pre-commit-hook" ".git/hooks/pre-commit"))

(packages->manifest
 (list guile-syntax-highlight haunt guile-3.0-latest guile-reader reuse))
