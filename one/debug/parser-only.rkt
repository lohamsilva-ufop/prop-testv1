#lang racket


(module reader racket
  (require "../parser.rkt")
  (provide (rename-out [prop-testv1-read read]
                       [prop-testv1-read-syntax read-syntax]))


  (define (prop-testv1-read in)
    (syntax->datum
     (prop-testv1-read-syntax #f in)))

  (define (prop-testv1-read-syntax path port)
    (datum->syntax
     #f
     `(module prop-testv1-mod racket
        ,@(parse port)))))
