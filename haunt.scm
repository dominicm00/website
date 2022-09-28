(use-modules (haunt asset)
             (haunt site)
             (haunt builder blog)
             (haunt builder atom)
             (haunt reader skribe))

(site #:title "Dominic's Website"
      #:domain "dominicm.dev"
      #:default-metadata
      '((author . "Dominic Martinez")
        (email  . "dom@dominicm.dev"))
      #:readers (list skribe-reader)
      #:builders (list (blog)
                       (atom-feed)
                       (atom-feeds-by-tag)))
