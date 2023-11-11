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
  #:use-module (ice-9 match)
  #:use-module (ice-9 curried-definitions)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 textual-ports))

(define-public (highlighted-code lexer code)
  (highlights->sxml (highlight lexer
                               (string-trim code))))

(define-public (convert-latex latex)
  (let* ((port (open-pipe* OPEN_READ "node" "katex-runner.js" latex))
         (html (get-string-all port))
         (status (close-pipe port))
         (success (zero? (status:exit-val status))))
    (display html)
    (if success `(p (html-literal ,html))
        (raise-exception
         (make-exception-with-message
          (string-append "Failed to parse latex\n"
                         latex
                         "With error:\n"
                         html))))))

(define-public (post-process-sxml sxml)
  (define ((highlighter lexer language) code)
    `(pre (code (@ (class ,language))
                ,(highlighted-code lexer code))))

  (define (plain-code-block code)
    `(pre (code ,code)))

  (define (code-processor language)
    (match language
      ("language-c" (highlighter lex-c language))
      ("language-css" (highlighter lex-css language))
      ("language-scheme" (highlighter lex-scheme language))
      ("language-asm" (highlighter lex-assembly language))
      ("language-python" (highlighter lex-python language))
      ("language-latex" convert-latex)
      (_ plain-code-block)))

  (map (match-lambda
         ;; Highlight supported code blocks
         (`(pre (code (@ (class ,language)) ,code))
          ((code-processor language) code))

         ;; Support callout blocks
         (`(blockquote (h1 ,class) . ,content)
          `(aside (@ (class ,class)) ,content))

         ;; Pass other objects through unchanged
         (x x))
       sxml))

(define-public modified-commonmark-reader
  (make-reader (make-file-extension-matcher "md")
               (lambda (file)
                 (call-with-input-file file
                   (lambda (port)
                     (values (read-metadata-headers port)
                             (post-process-sxml (commonmark->sxml port))))))))
