;; SPDX-FileCopyrightText: 2022 Dominic Martinez <dom@dominicm.dev>
;;
;; SPDX-License-Identifier: GPL-3.0-or-later

(define-module (pages about)
  #:use-module (theme)
  #:use-module (util))

(define (project title uri description)
  `((div
     (@ (class "project"))
     (h2 ,(link title uri))
     (p ,description))))

(define-public (about-me site)
  (static-page
   site
   "About Dominic Martinez"
   "about.html"
   `((main
      (@ (id "about"))
      (h1 "Dominic Martinez")

      (h2 "About me")
      (p "Hello! I'm a university student and developer making open, empowering
software. I'm particularly interested in tools for thought, programming
languages, and operating systems.

I also love to cook, play games, and hang out in VR.

Feel free to chat with me over any contact method below!")

      (h2 "Contact me")
      (ul
       (li (a (@ (rel "me") (href "mailto:dom@dominicm.dev")) "dom@dominicm.dev"))
       (li (a (@ (rel "me") (href "https://alpha.polymaths.social/@dominicm")) "Fediverse"))
       (li (a (@ (rel "me") (href "https://www.linkedin.com/in/dominicm00")) "LinkedIn"))
       (li ,(link "PGP key" "https://meta.sr.ht/~dominicm.pgp")))))))
