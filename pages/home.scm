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
      (@ (class "home"))
      (h1 "Welcome!")
      (p (@ (id "home-intro"))
         "I'm Dominic, a student and developer focused on making open,
 flexible, and friendly tools.")
      ,(link "→ more about me" "/about.html")

      (h2 (@ (class "post-type-header")) "Essays")
      (p (@ (class "post-type-description"))
         "An ever-evolving set of my current ideas and beliefs")
      ,(post-list (essay-posts posts))
      ,(link "→ see all essays" "/essays.html")

      (h2 (@ (class "post-type-header")) "Notes")
      (p (@ (class "post-type-description"))
         "My unpolished thoughts and experiences")
      ,(post-list (note-posts posts))
      ,(link "→ see all notes" "/notes.html")
      ))))
