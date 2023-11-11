;; SPDX-FileCopyrightText: 2022 Dominic Martinez <dom@dominicm.dev>
;;
;; SPDX-License-Identifier: GPL-3.0-or-later

(use-modules (guix packages)
             (guix git-download)
             (guix download)
             (gnu packages guile-xyz)
             (gnu packages guile)
             (gnu packages autotools)
             (gnu packages texinfo)
             (gnu packages license))

(define patched-haunt
  (package
   (inherit haunt)
   (version "0.2.6")
   (source (origin
            (method url-fetch)
            (uri (string-append "https://files.dthompson.us/haunt/haunt-"
                                version ".tar.gz"))
            (sha256
             (base32
              "1nwhwngx0gl2892vrvrzrxy5w6a5l08j1w0522kdh9a3v11qpwmw"))
            (patches `(,(local-file "patches/haunt-literal-html.patch")))))))

(packages->manifest
 (list guile-syntax-highlight patched-haunt guile-3.0-latest guile-reader reuse))
