; Copyright © 2022 Dominic Martinez <dom@dominicm.dev>
; SPDX-FileCopyrightText: 2022 Dominic Martinez <dom@dominicm.dev>
;
; SPDX-License-Identifier: GPL-3.0-or-later

(define-module (theme)
  #:use-module (haunt builder blog)
  #:use-module (haunt post)
  #:use-module (srfi srfi-19)
  #:use-module (util))

(define (%dm/layout site title body)
  `((doctype html)
    (html
     (@ (lang "en"))
     (head
      (meta (@ (charset "utf-8")))
      (meta (@ (name "viewport")
               (content "width=device-width, initial-scale=1")))
      (title ,title)
      ,(stylesheet "normalize")
      ,(stylesheet "dominicm"))
     (body
      (div
       (@ (id "site-container"))
       (main ,body)
       (footer
        (p "Made with "
           ,(link "Haunt" "https://dthompson.us/projects/haunt.html")
           " - "
           ,(link "Source code" "https://sr.ht/~dominicm/website"))))))))

(define (%dm/collection site title posts prefix)
  (define (post-uri post)
    (string-append "/" (or prefix "") "/" (post-slug post) ".html"))

  `((h1 (@ (id "collection-title"))
        ,title)
    ,@(map (lambda (post)
             `(div
               (@ (class "post-container"))
               (h2 ,(link (post-ref post 'title)
                          (post-uri post)))
               (p ,(date->string (post-date post)
                                 "~Y/~m/~d"))))
           posts)))

(define-public %dm/blog-theme
  (theme #:name "dominicm"
         #:layout %dm/layout
         #:collection-template %dm/collection))

(define-public dm/static-page
  (static-page-generator %dm/blog-theme))
