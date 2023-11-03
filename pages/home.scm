;; Copyright © 2023 Dominic Martinez <dom@dominicm.dev>
;; SPDX-FileCopyrightText: 2023 Dominic Martinez <dom@dominicm.dev>
;;
;; SPDX-License-Identifier: GPL-3.0-or-later

(define-module (pages home)
  #:use-module (theme)
  #:use-module (util)
  #:use-module (haunt post))

(define-public (home-page site posts)
  (define thoughts (thought-posts posts))
  (define ramblings (rambling-posts posts))

  (static-page
   site
   "Home"
   "index.html"
   `((main
      (@ (class "home"))
      (h1 "Welcome!")
      (p (@ (id "home-intro"))
         "I'm Dominic, a student and developer focused on making open,
 flexible, and friendly tools.")
      ,(link "→ more about me" "/about.html")

      ,@(if (null? thoughts)
            '()
            `((h2 (@ (class "post-type-header")) "Thoughts")
              (p (@ (class "post-type-description"))
                 "What I'm thinking about right now")
              ,(post-list thoughts)
              ,(link "→ see all thoughts" "/thoughts.html")))

      ,@(if (null? ramblings)
            '()
            `((h2 (@ (class "post-type-header")) "Ramblings")
              (p (@ (class "post-type-description"))
                 "Unpolished experiences and ideas")
              ,(post-list ramblings)
              ,(link "→ see all ramblings" "/ramblings.html")))
      ))))
