;; Copyright © 2022 Dominic Martinez <dom@dominicm.dev>
;; SPDX-FileCopyrightText: 2022 Dominic Martinez <dom@dominicm.dev>
;;
;; SPDX-License-Identifier: GPL-3.0-or-later

(define-module (builder)
  #:use-module (util)
  #:use-module (haunt post)
  #:use-module (pages home)
  #:use-module (pages about))

(define-public (static-pages site posts)
  (flatten
   (list
    (home-page site posts)
    (about-me site))))
