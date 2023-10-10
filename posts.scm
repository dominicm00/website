;; Copyright © 2022 Dominic Martinez <dom@dominicm.dev>
;; SPDX-FileCopyrightText: 2022 Dominic Martinez <dom@dominicm.dev>
;;
;; SPDX-License-Identifier: GPL-3.0-or-later

(define-module (posts)
  #:use-module (syntax-highlight)
  #:use-module (syntax-highlight c)
  #:use-module (syntax-highlight css)
  #:use-module (syntax-highlight scheme)
  #:use-module (highlight-python)
  #:use-module (highlight-assembly)
  #:use-module (commonmark)
  #:use-module (haunt post)
  #:use-module (haunt reader)
  #:use-module (ice-9 match))

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

(define-public (post-process-sxml sxml)
  (define (lexer-for-lang language)
    (match language
      ("language-c" lex-c)
      ("language-css" lex-css)
      ("language-scheme" lex-scheme)
      ("language-asm" lex-assembly)
      ("language-python" lex-python)))

  (map (match-lambda
         (`(pre (code (@ (class ,language)) ,code))
          (highlighted-code (lexer-for-lang language) code))
         (x x))
       sxml))

(define-public modified-commonmark-reader
  (make-reader (make-file-extension-matcher "md")
               (lambda (file)
                 (call-with-input-file file
                   (lambda (port)
                     (values (read-metadata-headers port)
                             (post-process-sxml (commonmark->sxml port))))))))
