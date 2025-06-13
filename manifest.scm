;; SPDX-FileCopyrightText: 2025 Dominic Martinez <dom@dominicm.dev>
;;
;; SPDX-License-Identifier: GPL-3.0-or-later

(use-modules (guix packages)
             (guix git-download)
             (guix download)
             (gnu packages guile-xyz)
             (gnu packages guile)
             (gnu packages autotools)
             (gnu packages texinfo)
             (gnu packages license)
             (gnu packages node))

(define patched-haunt
  (package
   (inherit haunt)
   (version "0.3.0")
   (source (origin
            (method url-fetch)
            (uri (string-append "https://files.dthompson.us/haunt/haunt-"
                                version ".tar.gz"))
            (sha256
             (base32
              "0awrk4a2gfnk660m4kg9cy1w8z7bj454355w7rn0cjp5dg8bxflq"))
            (patches `(,(local-file "patches/haunt-literal-html.patch")))))))

(packages->manifest
 (list guile-syntax-highlight
       patched-haunt
       guile-3.0-latest
       guile-reader
       reuse
       node-lts))
