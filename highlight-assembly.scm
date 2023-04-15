; SPDX-FileCopyrightText: 2023 Dominic Martinez <dom@dominicm.dev>
;
; SPDX-License-Identifier: GPL-3.0-or-later

(define-module (highlight-assembly)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-11)
  #:use-module (srfi srfi-26)
  #:use-module (syntax-highlight lexers)
  #:export (lex-assembly))

; TODO: This whole thing is horrible but I don't know how to improve it...
(define char-set:assembly-constant
  (char-set #\- #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9))

(define char-set:assembly-separator
  (char-set #\,))

(define lex-graphic
  (lex-char-set char-set:graphic))

(define lex-whitespace
  (lex-char-set char-set:whitespace))

(define lex-inline-label
  (lex-tag 'function
           (lex-char-set
            (char-set-union
             char-set:letter+digit
             (char-set #\- #\_)))))

(define lex-label
  (lex-all lex-inline-label
           (lex-tag 'function (lex-string ":"))))

(define lex-alphanumeric
  (lex-char-set char-set:letter+digit))

(define lex-register
  (lex-all (lex-string "$")
           lex-alphanumeric))

(define lex-separator
  (lex-char-set char-set:assembly-separator))

(define lex-nonline
  (lex-char-set (char-set-union char-set:blank
                                char-set:graphic)))

(define lex-instruction
  (lex-all (lex-tag 'special lex-graphic)
           (lex-consume-until
            (lex-string "\n")
            (lex-any
             lex-whitespace
             (lex-all (lex-any (lex-tag 'comment (lex-string "#"))
                               (lex-tag 'comment (lex-string ";")))
                      (lex-tag 'comment lex-nonline))
             (lex-tag 'open (lex-any* (map lex-string '("(" "[" "{"))))
             (lex-tag 'close (lex-any* (map lex-string '(")" "]" "}"))))
             (lex-tag 'symbol lex-register)
             (lex-tag 'constant (lex-char-set char-set:assembly-constant))
             lex-inline-label
             lex-separator))))

(define lex-directive
  (lex-all (lex-tag 'special (lex-string "."))
           (lex-tag 'special lex-graphic)))

(define lex-assembly
  (lex-consume
   (lex-any lex-whitespace
            (lex-tag 'comment (lex-any (lex-delimited "#" #:until "\n")
                                       (lex-delimited ";" #:until "\n")))
            lex-label
            lex-directive
            (lex-tag 'string (lex-any (lex-delimited "\"")
                                      (lex-delimited "'")))
            lex-instruction)))
