;; Copyright © 2022 Dominic Martinez <dom@dominicm.dev>
;; SPDX-FileCopyrightText: 2022 Dominic Martinez <dom@dominicm.dev>
;;
;; SPDX-License-Identifier: GPL-3.0-or-later

(use-modules (haunt asset)
             (haunt site)
             (haunt post)

             (haunt builder assets)
             (haunt builder blog)
             (haunt builder atom)

             (builder)
             (util)
             (posts)
             (theme))

(define %collections
  `(("Thoughts" "thoughts.html" ,(compose posts/reverse-chronological thought-posts))
    ("Ramblings" "ramblings.html" ,(compose posts/reverse-chronological rambling-posts))))

(site #:title "Dominic's Website"
      #:domain "dominicm.dev"
      #:default-metadata
      '((author . "Dominic Martinez")
        (email  . "dom@dominicm.dev"))
      #:readers (list modified-commonmark-reader)
      #:builders
      (list
       static-pages
       (blog #:theme blog-theme #:collections %collections)
       (static-directory "assets")
       (static-directory "css")
       (static-directory ".well-known")))
