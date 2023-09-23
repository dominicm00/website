;; Copyright © 2018-2021 David Thompson <davet@gnu.org>
;; Copyright © 2022 Dominic Martinez <dom@dominicm.dev>
;; SPDX-FileCopyrightText: 2022 Dominic Martinez <dom@dominicm.dev>
;;
;; SPDX-License-Identifier: GPL-3.0-or-later

(define-module (util)
  #:use-module (ice-9 rdelim)
  #:use-module (srfi srfi-19)
  #:use-module (srfi srfi-171)
  #:use-module (haunt artifact)
  #:use-module (haunt builder blog)
  #:use-module (haunt html)
  #:export (date
            stylesheet
            anchor
            link
            centered-image
            raw-snippet
            static-page-generator
            flatten)
  #:replace (link))

(define (date year month day)
  "Create a SRFI-19 date for the given YEAR, MONTH, DAY"
  (let ((tzoffset (tm:gmtoff (localtime (time-second (current-time))))))
    (make-date 0 0 0 0 day month year tzoffset)))

(define (stylesheet name)
  `(link (@ (rel "stylesheet")
            (href ,(string-append "/css/" name ".css")))))

(define* (anchor content #:optional (uri content))
  `(a (@ (href ,uri)) ,content))

(define (link name uri)
  `(a (@ (href ,uri)) ,name))

(define* (image-generator class)
  (lambda (uri alt)
    `(img (@ (class ,class)
             (src ,url)
             ,@(if alt
                   `((alt ,alt))
                   '())))))

(define (raw-snippet code)
  `(pre (code ,(if (string? code) code (read-string code)))))

(define (static-page-generator theme)
  (lambda (site title file-name body)
    (serialized-artifact file-name
                         (with-layout theme site title body)
                         sxml->html)))

(define (flatten l)
  (list-transduce tflatten rcons l))
