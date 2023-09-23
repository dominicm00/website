;; Copyright © 2023 Dominic Martinez <dom@dominicm.dev>
;; SPDX-FileCopyrightText: 2023 Dominic Martinez <dom@dominicm.dev>
;;
;; SPDX-License-Identifier: GPL-3.0-or-later

(define-module (pages home)
  #:use-module (theme)
  #:use-module (util)
  #:use-module (oop goops)
  #:use-module (haunt post))

(define-public (home-page site posts)
  (dm/static-page
   site
   "Home"
   "index.html"
   `((div
      (@ (id "home"))
      (h1 "Welcome!")
      (p "I'm Dominic, a student and developer focused on making open, flexible, and
friendly tools.")
      ,(link "more about me" "/about.html")

      (h2 "Essays")
      (p "An ever-evolving set of my current ideas and beliefs")
      ,(map (lambda (post)
              `(div
                (h2 ,(link (post-ref post 'title)
                           (post-slug post)))
                (p ,(post-ref post 'summary))))
            (essay-posts posts))

      (h2 "Notes")
      (p "My unpolished thoughts and experiences")
      ,(map (lambda (post)
              `(div
                (h2 ,(link (post-ref post 'title)
                           (post-slug post)))
                (p ,(post-ref post 'summary))))
            (note-posts posts))
      ))))
