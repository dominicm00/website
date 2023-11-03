;; Copyright © 2022 Dominic Martinez <dom@dominicm.dev>
;; SPDX-FileCopyrightText: 2022 Dominic Martinez <dom@dominicm.dev>
;;
;; SPDX-License-Identifier: GPL-3.0-or-later

(define-module (theme)
  #:use-module (haunt builder blog)
  #:use-module (haunt post)
  #:use-module (srfi srfi-19)
  #:use-module (ice-9 match)
  #:use-module (util))

(define %thought-stages
  `(("nebulous" "Nebulous" #f "/assets/images/profile-picture-128.png" "Nebula")
    ("fusing" "Fusing" #f "/assets/images/profile-picture-128.png" "Fusing blue star")))

(define (layout site title body)
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
               (href "/assets/images/profile-picture-128.png")))
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
        ,(link "About me" "/about.html")
        ,(link "Thoughts" "/thoughts.html")
        ,(link "Ramblings" "/ramblings.html")))

      ,body

      (footer
       (p
        "Made with "
        ,(link "Haunt" "https://dthompson.us/projects/haunt.html")
        ", "
        ,(link "Simple.css" "https://simplecss.org/")
        " - "
        ,(link "Source code" "https://sr.ht/~dominicm/website")))))))

(define (stage-blurb stage)
  (define stage-info (assoc stage %thought-stages))

  (match stage-info
    ((tag title description image alt)
     `((p (@ (class "thought-stage"))
        (img (@ (src ,image) (alt ,alt)))
        ,(if description
             (string-append title ": " description)
             title))))))

(define-public (post-list posts)
  `((div (@ (class "collection"))
     ,@(map (lambda (post)
              `((h3 (@ (class "post-link"))
                 ,(link (post-ref post 'title)
                        (string-append (post-slug post) ".html")))

                ,@(if (post-ref post 'stage)
                      (stage-blurb (post-ref post 'stage))
                      '())

                (p (@ (class "post-summary"))
                   ,(post-ref post 'summary))))
            posts))))

(define-public (post-template post)
  `((main (@ (class "post"))
     (h1 ,(post-ref post 'title))
     (p (@ (class "post-summary")) ,(post-ref post 'summary))
     ,(post-sxml post))))

(define-public (collection-template site title posts prefix)
  `((main
     (h1 (@ (id "collection-title"))
         ,title)
     ,(post-list posts))))

(define-public blog-theme
  (theme #:name "dominicm"
         #:layout layout
         #:post-template post-template
         #:collection-template collection-template))

(define-public static-page
  (static-page-generator blog-theme))
