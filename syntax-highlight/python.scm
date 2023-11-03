;; SPDX-FileCopyrightText: 2023 Dominic Martinez <dom@dominicm.dev>
;;
;; SPDX-License-Identifier: GPL-3.0-or-later

(define-module (syntax-highlight python)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-11)
  #:use-module (srfi srfi-26)
  #:use-module (syntax-highlight lexers)
  #:export (lex-python))

(define %python-reserved-words
  '("False" "await" "else" "import" "pass"
    "None" "break" "except" "in" "raise"
    "True" "class" "finally" "is" "return"
    "and" "continue" "for" "lambda" "try"
    "as" "def" "from" "nonlocal" "while"
    "assert" "del" "global" "not" "with"
    "async" "elif" "if" "or" "yield" "self"))

(define (python-reserved-word? str)
  "Return #t if STR is a Python keyword."
  (any (cut string=? <> str) %python-reserved-words))

(define %python-operators
  '("=" "==" "!=" "<=" ">=" "<" ">"
    "@" "**" "//" "*" "/" "%" "++" "--" "+" "-"
    "<<" ">>" "&" "|" "~" "^" "."))

(define %python-separators
  '(":" ","))

(define lex-python-operator
  (lex-any* (map lex-string %python-operators)))

(define lex-python-separator
  (lex-any* (map lex-string %python-separators)))

(define char-set:python-identifier
  (char-set #\a #\b #\c #\d #\e #\f #\g #\h #\i #\j #\k #\l #\m #\n #\o
            #\p #\q #\r #\s #\t #\u #\v #\w #\x #\y #\z
            #\A #\B #\C #\D #\E #\F #\G #\H #\I #\J #\K #\L #\M #\N #\O
            #\P #\Q #\R #\S #\T #\U #\V #\W #\X #\Y #\Z
            #\_ #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9))

(define char-set:python-constant
  (char-set #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9))

(define lex-python-identifier
  (lex-char-set char-set:python-identifier))

(define lex-python-constant
  (lex-char-set char-set:python-constant))

(define lex-whitespace
  (lex-char-set char-set:whitespace))

(define lex-python
  (lex-consume
   (lex-any lex-whitespace
            (lex-tag 'open (lex-any* (map lex-string '("(" "[" "{"))))
            (lex-tag 'close (lex-any* (map lex-string '(")" "]" "}"))))
            (lex-all (lex-tag 'special (lex-string "def"))
                     lex-whitespace
                     (lex-tag 'function lex-python-identifier))
            (lex-tag 'comment (lex-delimited "#" #:until "\n"))
            (lex-tag 'doc-comment (lex-delimited "\"\"\""))
            (lex-tag 'special (lex-filter python-reserved-word? lex-python-identifier))
            (lex-tag 'constant lex-python-constant)
            (lex-tag 'symbol lex-python-identifier)
            (lex-tag 'string (lex-any (lex-delimited "\"")
                                      (lex-delimited "'")))
            (lex-tag 'operator lex-python-operator)
            lex-python-separator)))
