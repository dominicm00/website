;; Copyright © 2022 Dominic Martinez <dom@dominicm.dev>
;; SPDX-FileCopyrightText: 2022 Dominic Martinez <dom@dominicm.dev>
;;
;; SPDX-License-Identifier: GPL-3.0-or-later

(define-module (theme)
  #:use-module (haunt builder blog)
  #:use-module (haunt post)
  #:use-module (srfi srfi-19)
  #:use-module (srfi srfi-9)
  #:use-module (ice-9 match)
  #:use-module (util))

(define-record-type <stage>
  (make-stage tag name description image alt)
  stage?
  (name stage-name)
  (tag stage-tag)
  (description stage-description)
  (image stage-image)
  (alt stage-alt))

;; Association list of tag names to stages
(define %thought-stages
  (map (lambda (args) (cons (car args) (apply make-stage args)))
       `(("nebulous" "Nebulous" #f "/assets/images/nebulous-256.png" "Nebula")
         ("fusing" "Fusing" #f "/assets/images/fusing-256.png" "Fusing blue star"))))

(define (make-icon size)
  `(((link (@ (rel "icon")
              (type "image/png")
              (sizes ,(string-append size "x" size))
              (href ,(string-append "/assets/images/profile-picture-" size ".png"))))
     (link (@ (rel "apple-touch-icon")
              (type "image/png")
              (sizes ,(string-append size "x" size))
              (href ,(string-append "/assets/images/profile-picture-" size ".png")))))))

(define (layout site title body)
  `((doctype html)
    (html
     (@ (lang "en"))
     (head
      (meta (@ (charset "utf-8")))
      (meta (@ (name "viewport")
               (content "width=device-width, initial-scale=1")))
      (title ,title)
      ,@(make-icon "128")

      ,(stylesheet "simple")
      ,(stylesheet "dominicm")

      (link (@ (rel "stylesheet")
               (href "/assets/katex/katex.css"))))
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
  (let ((name (stage-name stage))
        (description (stage-description stage)))
    `((p (@ (class "thought-stage"))
       ,(if description
            (string-append name ": " description)
            name)))))

(define-public (post-list posts)
  (define (post-blurb post)
    (let* ((stage-name (post-ref post 'stage))
           (stage (if stage-name
                      (assoc-ref %thought-stages stage-name)
                      #f))
           (title (post-ref post 'title))
           (summary (post-ref post 'summary))
           (post-url (string-append (post-slug post) ".html")))

      `((h3 (@ (class "post-link"))
         ,@(if stage
               `((image (@ (src ,(stage-image stage))
                           (alt ,(stage-alt stage)))))
               '())
         ,(link title post-url))

        ,@(if stage
              (stage-blurb stage)
              '())

        (p (@ (class "post-summary")) ,summary))))

  `((div (@ (class "collection"))
     ,@(map post-blurb posts))))

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
