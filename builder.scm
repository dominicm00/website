(define-module (builder)
  #:use-module (util)
  #:use-module (haunt post)
  #:use-module (pages home)
  #:use-module (pages about)
  ;;#:use-module (pages essays)
  ;;#:use-module (pages notes)
  )

(define-public (builder site posts)

  (flatten
   (list
    (home-page site posts)
    ;;(essays site (essay-posts posts))
    ;;(notes site (note-posts posts))
	(about-me site))))
