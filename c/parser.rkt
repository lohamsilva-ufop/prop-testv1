#lang racket

(require parser-tools/yacc
         "lexer.rkt"
         "c-syntax.rkt")

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
              [(PRINTF OPENP texto VIRGULA variaveis CLOSEP PVIRGULA)(fprint $3 $5)]
           
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

    (texto [(STRING)(value $1)])

    (variaveis [(IDENTIFICADOR) (var $1)]
               [(IDENTIFICADOR VIRGULA variaveis) (var $1)])
       

    (expressao [(NUMERO) (value $1)]
               [(IDENTIFICADOR) (var $1)]
               [(STRING) (value $1)])

    )))

(define (parse ip)
  (prop-testv1-parser (lambda () (next-token ip))))

(provide parse)


