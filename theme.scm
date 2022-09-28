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
  #:use-module (util))

(define (%dm/layout site title body)
  `((doctype html)
    (html
     (head
      (meta (@ (charset "utf-8")))
      (title ,title)
      ,(stylesheet "normalize")
      ,(stylesheet "dominicm"))
     (body ,body))))

(define-public %dm/blog-theme
  (theme #:name "dominicm"
         #:layout %dm/layout))

(define-public %dm/static-page
  (static-page-generator %dm/blog-theme))
