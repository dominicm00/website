; SPDX-FileCopyrightText: 2022 Dominic Martinez <dom@dominicm.dev>
;
; SPDX-License-Identifier: CC0-1.0

(use-modules (guix packages)
             (guix git-download)
             (gnu packages guile-xyz)
             (gnu packages guile)
             (gnu packages autotools)
             (gnu packages texinfo))

(define-public guile-syntax-highlight-for-assembly
  (let ((commit "d68ccf7c2ae9516ca2ddacc5f65e2277038b23f6")
        (revision "1"))
    (package
     (inherit guile-syntax-highlight)
     (version (git-version "0.2.0" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://git.dthompson.us/guile-syntax-highlight.git")
                    (commit commit)))
              (file-name (git-file-name "guile-syntax-highlight" version))
              (sha256
               (base32
                "0sbxy7mn6kzx83ml4x530r4g7b22jk1kpp766mcgm35zw7mn1qi9"))))
     (native-inputs
      (modify-inputs (package-native-inputs guile-syntax-highlight)
                     (prepend autoconf automake texinfo)))
     (properties '((hidden? . #t))))))

(packages->manifest
 (list guile-syntax-highlight-for-assembly haunt guile-3.0-latest guile-reader))
