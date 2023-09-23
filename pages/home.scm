;; Copyright © 2023 Dominic Martinez <dom@dominicm.dev>
;; SPDX-FileCopyrightText: 2023 Dominic Martinez <dom@dominicm.dev>
;;
;; SPDX-License-Identifier: GPL-3.0-or-later

(define-module (pages home)
  #:use-module (theme)
  #:use-module (util)
  #:use-module (haunt post))

(define-public (home-page site posts)
  (dm/static-page
   site
   "Home"
   "index.html"
   `((div
      (@ (id "home"))
      (h1 "Dominic Martinez")

      (h2 "Hoooome")
      (p "Welcome! I'm a university student and developer making open, user-centric
software. I'm particularly interested in tools for thought,
programming languages, and operating systems. If you want to chat my
email is always open.")

      ,(map (lambda (post)
              `(h2 ,(link (post-ref post 'title)
                          (post-slug post))))
            posts)))))
