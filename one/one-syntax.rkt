#lang racket

;; expression syntax

(struct value
  (value)
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

(struct input
  (id declaracao)
  #:transparent)

(struct input_declaracao
  (expr)
  #:transparent)

(struct menor
  (left right)
  #:transparent)

(struct maior
  (left right)
  #:transparent)

(struct igual
  (left right)
  #:transparent)


(provide (all-defined-out))

