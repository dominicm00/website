;;; Copyright © 2022 Dominic Martinez <dom@dominicm.dev>
;;;
;;; This program is free software; you can redistribute it and/or
;;; modify it under the terms of the GNU General Public License as
;;; published by the Free Software Foundation; either version 3 of the
;;; License, or (at your option) any later version.
;;;
;;; This program is distributed in the hope that it will be useful, but WITHOUT
;;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
;;; FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
;;; more details.
;;;
;;; You should have received a copy of the GNU General Public License along with
;;; this program. If not, see <http://www.gnu.org/licenses/>.

(define-module (theme)
  #:use-module (haunt builder blog)
  #:use-module (haunt post)
  #:use-module (srfi srfi-19)
  #:use-module (util))

(define (%dm/layout site title body)
  `((doctype html)
    (html
     (head
      (meta (@ (charset "utf-8")))
      (title ,title)
      ,(stylesheet "normalize")
      ,(stylesheet "dominicm"))
     (body
      (div
       (@ (id "site-container"))
       ,body)))))

(define (%dm/collection site title posts prefix)
  (define (post-uri post)
    (string-append "/" (or prefix "") "/" (post-slug post)))

  `((h1 (@ (id "collection-title"))
        ,title)
    ,@(map (lambda (post)
             `(div
               (@ (class "post-container"))
               (a (@ (href ,(post-uri post)))
                  (h2 ,(post-ref post 'title)))
               (p ,(date->string (post-date post)
                                 "~Y/~m/~d"))))
           posts)))

(define-public %dm/blog-theme
  (theme #:name "dominicm"
         #:layout %dm/layout
         #:collection-template %dm/collection))

(define-public %dm/static-page
  (static-page-generator %dm/blog-theme))
