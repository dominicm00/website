(define-module (builder)
  #:use-module (util)
  #:use-module (haunt post)
  #:use-module (pages home)
  #:use-module (pages about)
  ;;#:use-module (pages essays)
  ;;#:use-module (pages notes)
  #:use-module (ice-9 curried-definitions))

(define-public (builder site posts)
  (define ((post-in-dir directory) post)
    (string=? directory (car (string-split (post-file-name post) #\/))))
  (define essay-posts (filter (post-in-dir "essays") posts))
  (define note-posts (filter (post-in-dir "notes") posts))

  (flatten
   (list
    (home-page site posts)
    ;;(essays site essay-posts)
    ;;(notes site note-posts)
	(about-me site))))
