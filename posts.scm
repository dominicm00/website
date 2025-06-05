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
  #:use-module (ice-9 receive)
  #:use-module (ice-9 curried-definitions)
  #:use-module (ice-9 exceptions)
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
    (if success `(p (html-literal ,html))
        (raise-exception
         (make-exception-with-message
          (string-append "Failed to parse latex: "
                         latex
                         "; With error: "
                         html))))))

(define-public (convert-mermaid mermaid)
  (receive (from to pids)
      ;; Very annoyingly, the open-pipe* API doesn't allow you to separately
      ;; close the WRITE pipe, and then the READ pipe. Since Mermaid expects
      ;; the entire input at once, we need to close the WRITE pipe first.
      (pipeline '(("npx" "mmdc" "-e" "svg" "-I" "mermaid-svg" "--input" "-" "--output" "-")))
    (display mermaid to)
    (close to)
    (let* ((html (get-string-all from))
           (_ (close from))
           ;; Because the pipeline API doesn't make it straightforward to get
           ;; the status code, check if an SVG was output from the command.
           (success (string-prefix? "<svg" html)))
      (if success `(p (html-literal ,html))
        (raise-exception
         (make-exception-with-message
          (string-append "Failed to parse mermaid: "
                         latex
                         "; With error: "
                         html)))))))


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
      ("language-mermaid" convert-mermaid)
      (_ plain-code-block)))

  (map (match-lambda
         ;; Highlight supported code blocks
         (`(pre (code (@ (class ,language)) ,code))
          ((code-processor language) code))

         ;; Support captions
         (`(blockquote (h1 "caption") ,fig . ,caption)
          `(figure ,fig (figcaption ,caption)))

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
