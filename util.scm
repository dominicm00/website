;;; This file contains code borrowed from David Thompson's blog, available at:
;;; https://git.dthompson.us/blog.git/
;;;
;;; Copyright © 2018-2021 David Thompson <davet@gnu.org>
;;; Copyright © 2022 Dominic Martinez <dom@dominicm.dev>
;;;
;;; This program is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by the Free
;;; Software Foundation; either version 3 of the License, or (at your option)
;;; any later version.
;;;
;;; This program is distributed in the hope that it will be useful, but WITHOUT
;;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
;;; FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
;;; more details.
;;;
;;; You should have received a copy of the GNU General Public License along with
;;; this program. If not, see <http://www.gnu.org/licenses/>.

(define-module (util)
  #:use-module (ice-9 rdelim)
  #:use-module (srfi srfi-19)
  #:use-module (haunt artifact)
  #:use-module (haunt builder blog)
  #:use-module (haunt html)
  #:export (date
            stylesheet
            anchor
            link
            centered-image
            raw-snippet
            static-page-generator)
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
  (lambda (title file-name body)
    (lambda (site posts)
      (serialized-artifact file-name
                           (with-layout theme site title body)
                           sxml->html))))
