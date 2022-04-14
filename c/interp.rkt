#lang racket

(require "c-syntax.rkt")

(define (cria texto env)
   (match texto
     [(var "idade")(display (value-value (cdr (eval-expr env texto))))]
     [(var "peso")(display (value-value (cdr (eval-expr env texto))))]
     [(var "sexo")(display (value-value (cdr (eval-expr env texto))))]
     [else  (display texto)]
   )
 )

(define (montatexto texto)
  ;(car texto = tabela hash)
  ;(cdr texto = item da lista)
  (if (equal? (cdr texto) '())
  (display "")
  (begin
  (cria (first (cdr texto)) (car texto))
  (montatexto (cons  (car texto) (rest (cdr texto)))))))

  
(define (merge l1 l2)
   (match l1
     ['() empty]
     [(cons 'd t) (cons (car l2) (merge t (rest l2)))]
     [(cons h t) (cons h (merge t l2))]))


;; capturar um valOR
(define (read-value env v)
  (let ([x (read)])
      (hash-set env (var-id v) (value x)))) 
  
;; looking up an environment
;; lookup-env : environment * var -> environment * value

(define (lookup-env env v)
  (let* ([val (hash-ref env v #f)])
    (if val
        (cons env val)
        (cons (hash-set env v (value 0))
              (value 0)))))

(define (true-value? v)
  (eq? #t (value-value v)))

(define (op-value f env v1 v2)
  (cons env (value (f (value-value v1)
                      (value-value v2)))))

(define (eval-op f env e1 e2)
  (let* ([r1 (eval-expr env e1)]
         [r2 (eval-expr (car r1) e2)])
    (op-value f (car r2) (cdr r1) (cdr r2))))


;; eval-expr : env * expr -> env * expr

(define (eval-expr env e)
  (match e
    [(value val) (cons env (value val))]
    [(var v) (lookup-env env (var-id v))]))

;; evaluating a statement


(define (verify-var env v)
  (let* ([val (hash-ref env v #f)])
    (if val (#t) (#f))
  ))
; eval-assign : environment * var * expr -> environment

(define (eval-assign env v e)
  (let* ([res (eval-expr env e)])
    (hash-set env v (cdr res))))

;se a variavel for só declarada, cria-se no hash uma variavel com null
(define (eval-assign-null env v)
    (hash-set env v null))

; eval-stmt : environment * statement -> environment

(define (eval-stmt env s)
  (match s

;leitura de dados
    [(input (var v))
        (read-value env v)]
    
    [(assign v e) (eval-assign env (var-id v) e)]

    [(assign-null v) (eval-assign-null env (var-id v))]
      
;mostrar dados com formatação   
    [(fprint lista_texto lista_variaveis)
      (let* ([v (merge lista_texto lista_variaveis)]
             [texto (montatexto (cons env v))])
             (displayln texto))]
     
     ;(let* ([texto_recebido (eval-expr env e1)]
           ;[texto (value-value (cdr texto_recebido))]
         ;  [variavel (eval-expr env v)]
          ; [valor_variavel (value-value (cdr variavel))])
          ; (begin
            ; (make-texto texto valor_variavel)
          

    
;mostra os dados sem formatação 
    [(sprint e1)
     (let ([v (eval-expr env e1)])
       (begin
         (displayln (value-value (cdr v)))
         env))]))


(define (eval-stmts env blk)
  (match blk
    ['() env]
    [(cons s blks) (let ([nenv (eval-stmt env s)])
                       (eval-stmts nenv blks))]))


(define (prop-testv1-interp prog)
  (eval-stmts (make-immutable-hash) prog))

(provide prop-testv1-interp eval-expr)
