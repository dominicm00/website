(define-module (pages main)
  #:use-module (theme)
  #:use-module (util))

(define-public main-page
  (%dm/static-page
   "Dominic Martinez's Site"
   "index.html"
   `((h1 "About me")
     (p "Some cool info")
     ,(link "Posts" "/posts/index.html"))))
