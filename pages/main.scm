; Copyright © 2022 Dominic Martinez <dom@dominicm.dev>
; SPDX-FileCopyrightText: 2022 Dominic Martinez <dom@dominicm.dev>
;
; SPDX-License-Identifier: GPL-3.0-or-later

(define-module (pages main)
  #:use-module (theme)
  #:use-module (util))

(define (project title uri description)
  `((div
     (@ (class "project"))
     (h3 ,(link title uri))
     (p ,description))))

(define-public main-page
  (dm/static-page
   "Dominic Martinez's Site"
   "index.html"
   `((h1 "Dominic Martinez")

     (h2 "About me")
     (p "I'm a developer interested in creating effective and ethical software. If you
ever want to chat, my inbox is always open.")

     (h2 "Projects")
     ,(project
       "Ham"
       "https://sr.ht/~dominicm/ham"
       "A modern replacement for the Perforce Jam C/C++ build system")
     ,(project
       "Dotfiles"
       "https://sr.ht/~dominicm/dotfiles"
       "A reproducible Linux configuration leveraging GNU Guix")

     (h2 "Contact me")
     ,(link "dom@dominicm.dev" "mailto:dom@dominicm.dev")
     (br)
     ,(link "PGP key" "https://meta.sr.ht/~dominicm.pgp"))))
