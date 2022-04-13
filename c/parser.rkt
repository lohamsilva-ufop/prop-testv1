#lang racket

(require parser-tools/yacc
         "lexer.rkt"
         "c-syntax.rkt")

(define (text texto)
texto)

(define (process s)
  (let* ([s1 (proc (string->list s) '() '())])
    (stringfy s1)))

(define (stringfy s)
  (map (lambda (p) (if (list? p)
                       (list->string p)
                       p)) s))

(define (proc s cur ac)
  (match s
    ['() (reverse (cons (reverse cur) ac))]
    [(cons #\% (cons c s1))
     (match c
       [#\d (proc s1 '() (cons 'd (cons (reverse cur) ac)))]
       [_   (proc s1 (cons #\% (cons c cur)) ac)])]
    [(cons c s1)
     (proc s1 (cons c cur) ac)]))

(define prop-testv1-parser
  (parser
   (start declaracoes)
   (end EOF)
   (tokens value-tokens var-tokens syntax-tokens)
   (src-pos)
   (error
    (lambda (a b c d e)
      (begin
        (printf "a = ~a\nb = ~a\nc = ~a\nd = ~a\ne = ~a\n"
                a b c d e) (void))))
   (grammar

    (declaracoes [() '()]
     [(comandos declaracoes)(cons $1 $2)])

    (comandos [(PRINTF OPENP expressao CLOSEP PVIRGULA)(sprint $3)]
              [(PRINTF OPENP texto VIRGULA variaveis CLOSEP PVIRGULA)(fprint (process $3) $5)]
           
              [(SCANF OPENP IDENTIFICADOR CLOSEP PVIRGULA)(input (var $3))]

              [(INT IDENTIFICADOR ATRIBUIDOR expressao PVIRGULA)(assign (var $2) $4)]
              [(INT IDENTIFICADOR PVIRGULA)(assign-null (var $2))]

              [(CHAR IDENTIFICADOR ATRIBUIDOR expressao PVIRGULA)(assign (var $2) $4)]
              [(CHAR IDENTIFICADOR PVIRGULA)(assign-null (var $2))]
              
              [(FLOAT IDENTIFICADOR ATRIBUIDOR expressao PVIRGULA)(assign (var $2) $4)]
              [(FLOAT IDENTIFICADOR PVIRGULA)(assign-null (var $2))]
              
              [(DOUBLE IDENTIFICADOR ATRIBUIDOR expressao PVIRGULA)(assign (var $2) $4)]
              [(DOUBLE IDENTIFICADOR PVIRGULA)(assign-null (var $2))]
              
              [(IDENTIFICADOR ATRIBUIDOR expressao PVIRGULA)(assign (var $1) $3)])

    (texto [(STRING)(text $1)])

    (variaveis [(IDENTIFICADOR) (list $1)]
               [(IDENTIFICADOR VIRGULA variaveis) (cons $1 $3)])
       

    (expressao [(NUMERO) (value $1)]
               [(IDENTIFICADOR) (var $1)]
               [(STRING) (value $1)])

    )))

(define (parse ip)
  (prop-testv1-parser (lambda () (next-token ip))))

(provide parse)


