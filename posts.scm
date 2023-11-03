;; Copyright © 2022 Dominic Martinez <dom@dominicm.dev>
;; SPDX-FileCopyrightText: 2022 Dominic Martinez <dom@dominicm.dev>
;;
;; SPDX-License-Identifier: GPL-3.0-or-later

(define-module (posts)
  #:use-module (syntax-highlight)
  #:use-module (syntax-highlight c)
  #:use-module (syntax-highlight css)
  #:use-module (syntax-highlight scheme)
  #:use-module (syntax-highlight python)
  #:use-module (syntax-highlight assembly)
  #:use-module (commonmark)
  #:use-module (haunt post)
  #:use-module (haunt reader)
  #:use-module (ice-9 match))

(define-public (highlighted-code lexer code)
  (highlights->sxml (highlight lexer
                               (string-trim code))))

(define-public (post-process-sxml sxml)
  (define (lexer-for-lang language)
    (match language
      ("language-c" lex-c)
      ("language-css" lex-css)
      ("language-scheme" lex-scheme)
      ("language-asm" lex-assembly)
      ("language-python" lex-python)
      (_ #f)))

  (map (match-lambda
         (`(pre (code (@ (class ,language)) ,code))
          (let ((lexer (lexer-for-lang language))
                (wrapper (lambda (code)
                           `(pre (code (@ (class ,language)) ,code)))))
            (if lexer
                (wrapper (highlighted-code lexer code))
                (wrapper code))))

         (x x))
       sxml))

(define-public modified-commonmark-reader
  (make-reader (make-file-extension-matcher "md")
               (lambda (file)
                 (call-with-input-file file
                   (lambda (port)
                     (values (read-metadata-headers port)
                             (post-process-sxml (commonmark->sxml port))))))))
