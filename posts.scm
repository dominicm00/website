;; Copyright © 2022 Dominic Martinez <dom@dominicm.dev>
;; SPDX-FileCopyrightText: 2022 Dominic Martinez <dom@dominicm.dev>
;;
;; SPDX-License-Identifier: GPL-3.0-or-later

(define-module (posts)
  #:use-module (syntax-highlight))

(define-public (image-with-height filename alt height)
  `(img (@ (alt ,alt)
           (src ,(string-append "/assets/images/" filename))
           (style ,(string-append "max-height: " height)))))

(define-public (highlighted-code lexer code)
  `(pre (code ,(highlights->sxml (highlight lexer
                                            (string-trim code))))))

(define-public (caption b c)
  `(figure ,b (figcaption ,c)))

(define-public (todo t)
  `(p (@ (style "color: #ff3333")) (string-append "TODO: " ,t)))

(define-public (inline-code c)
  `(code (@ (class "inline-code")) ,c))
