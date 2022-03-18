#lang racket

;; expression syntax

(struct input
  (id)
  #:transparent)

(struct value
  (value)
  #:transparent)

(struct format
  (format)
  #:transparent)

(struct var
  (id)
  #:transparent)

; statement syntax

(struct assign
  (var expr)
  #:transparent)

(struct assign-null
   (var)
  #:transparent)

(struct sprint
  (expr)
  #:transparent)


(provide (all-defined-out))

