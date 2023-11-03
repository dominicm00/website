;; Copyright © 2018-2021 David Thompson <davet@gnu.org>
;; Copyright © 2022 Dominic Martinez <dom@dominicm.dev>
;; SPDX-FileCopyrightText: 2022 Dominic Martinez <dom@dominicm.dev>
;;
;; SPDX-License-Identifier: GPL-3.0-or-later

(define-module (util)
  #:use-module (ice-9 rdelim)
  #:use-module (ice-9 curried-definitions)
  #:use-module (srfi srfi-19)
  #:use-module (srfi srfi-171)
  #:use-module (haunt artifact)
  #:use-module (haunt builder blog)
  #:use-module (haunt html)
  #:use-module (haunt post)
  #:export (date
            stylesheet
            anchor
            link
            centered-image
            raw-snippet
            static-page-generator
            flatten
            thought-posts
            rambling-posts
            post-has-tag)
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

(define (tag-filter-generator tag)
  (lambda (posts)
    (or (assoc-ref (posts/group-by-tag posts) tag)
        '())))

(define thought-posts (compose posts/reverse-chronological
                               (tag-filter-generator "thought")))
(define rambling-posts (compose posts/reverse-chronological
                                (tag-filter-generator "rambling")))

(define (post-has-tag post tag)
  (member tag (post-ref post 'tags)))
