;; Copyright © 2022 Dominic Martinez <dom@dominicm.dev>
;; SPDX-FileCopyrightText: 2022 Dominic Martinez <dom@dominicm.dev>
;;
;; SPDX-License-Identifier: GPL-3.0-or-later

(use-modules (haunt asset)
             (haunt site)

             (haunt builder assets)
             (haunt reader commonmark)

             (builder)
             (util))

(site #:title "Dominic's Website"
      #:domain "dominicm.dev"
      #:default-metadata
      '((author . "Dominic Martinez")
        (email  . "dom@dominicm.dev"))
      #:readers (list commonmark-reader)
      #:builders
      (list
       builder
       (static-directory "assets")
       (static-directory "css")
       (static-directory ".well-known")))
