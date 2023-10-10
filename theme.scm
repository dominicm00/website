;; Copyright © 2022 Dominic Martinez <dom@dominicm.dev>
;; SPDX-FileCopyrightText: 2022 Dominic Martinez <dom@dominicm.dev>
;;
;; SPDX-License-Identifier: GPL-3.0-or-later

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
      (link (@ (rel "shortcut icon")
               (type "image/png")
               (href "/assets/images/profile-pictur-128.png")))
      (link (@ (rel "apple-touch-icon-precomposed")
               (type "image/png")
               (href "/assets/images/profile-picture-128.png")))
      ,(stylesheet "reset")
      ,(stylesheet "simple")
      ,(stylesheet "dominicm"))
     (body
      (header
       (nav
        (a (@ (href "/") (id "home-link"))
           (img (@ (src "/assets/images/profile-picture-128.png")
                   (alt "Home"))))
        ,(link "Essays" "/essays.html")
        ,(link "Notes" "/notes.html"))))
     (main ,body)
     (footer
      (p
       ,(link "RSS feed" "/feed.xml")
       ". Made with "
       ,(link "Haunt" "https://dthompson.us/projects/haunt.html")
       ", "
       ,(link "Simple.css" "https://simplecss.org/")
       " - "
       ,(link "Source code" "https://sr.ht/~dominicm/website"))))))

(define-public (post-list posts)
  `((div (@ (class "collection"))
     ,@(map (lambda (post)
              `((h3 (@ (class "post-link"))
                 ,(link (post-ref post 'title)
                        (post-slug post)))
                (p (@ (class "post-summary"))
                   ,(post-ref post 'summary))))
            posts))))

(define-public (%dm/collection site title posts prefix)
  `((h1 (@ (id "collection-title"))
     ,title)
    ,(post-list posts)))

(define-public %dm/blog-theme
  (theme #:name "dominicm"
         #:layout %dm/layout
         #:collection-template %dm/collection))

(define-public dm/static-page
  (static-page-generator %dm/blog-theme))
