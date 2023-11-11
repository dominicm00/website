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

             (srfi srfi-1)

             (builder)
             (util)
             (posts)
             (theme))

(define %collections
  `(("Thoughts" "thoughts.html" ,thought-posts)
    ("Ramblings" "ramblings.html" ,rambling-posts)))

(define %ignored-extensions
  '(".license"))

(define (ignore-file-predicate filename)
  (not (any (lambda (extension)
              (string-suffix? extension filename))
            %ignored-extensions)))

(site #:title "Dominic's Website"
      #:domain "dominicm.dev"
      #:default-metadata
      '((author . "Dominic Martinez")
        (email  . "dom@dominicm.dev"))
      #:file-filter ignore-file-predicate
      #:readers (list modified-commonmark-reader)
      #:builders
      (list
       static-pages
       (blog #:theme blog-theme #:collections %collections)
       (static-directory "assets")
       (static-directory "css")
       (static-directory ".well-known")))
