; Copyright © 2022 Dominic Martinez <dom@dominicm.dev>
; SPDX-FileCopyrightText: 2022 Dominic Martinez <dom@dominicm.dev>
;
; SPDX-License-Identifier: GPL-3.0-or-later

(use-modules (haunt asset)
             (haunt site)
             (haunt post)

             (haunt builder blog)
             (haunt builder atom)
             (haunt builder assets)

             (haunt reader skribe)

             (pages about)

             (theme)
             (util))

(define %dm/collections
  `(("Posts" "index.html" ,posts/reverse-chronological)))


(site #:title "Dominic's Website"
      #:domain "dominicm.dev"
      #:default-metadata
      '((author . "Dominic Martinez")
        (email  . "dom@dominicm.dev"))
      #:readers (list skribe-reader)
      #:builders (list (blog
                        #:theme %dm/blog-theme
                        #:collections %dm/collections)
                       (atom-feed)
                       about-page
                       (static-directory "assets")
                       (static-directory "css")
                       (static-directory ".well-known")))
