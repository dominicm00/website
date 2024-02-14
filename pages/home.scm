;; Copyright © 2023 Dominic Martinez <dom@dominicm.dev>
;; SPDX-FileCopyrightText: 2023 Dominic Martinez <dom@dominicm.dev>
;;
;; SPDX-License-Identifier: GPL-3.0-or-later

(define-module (pages home)
  #:use-module (theme)
  #:use-module (util)
  #:use-module (haunt post))

(define section-limit 3)

(define (post-section name display-name description posts)
  "Generate a homepage section displaying up to `section-limit' posts."
  (if (null? posts)
      '()
      `((h2 (@ (class "post-type-header")) ,display-name)
        (p (@ (class "post-type-description")) ,description)
        ,(post-list (list-head posts
                               (min (length posts) section-limit)))

        ,@(if (> (length posts) section-limit)
              `(,(link
                  (string-append "→ see all " name)
                  (string-append "/" name ".html")))
              '())
        )))

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
         "I'm Dominic, a developer aligning how we program with how we think.")
      ,(link "→ more about me" "/about.html")

      ,@(post-section "thoughts" "Thoughts" "Haphazard attempts to solidify my ideas" thoughts)
      ,@(post-section "ramblings" "Ramblings" "A shout into the void" ramblings)
      ))))
