#lang racket

(require parser-tools/yacc
         "lexer.rkt"
         "c-syntax.rkt")

(define prop-testv1-parser
  (parser
   (start declaracoes)
   (end EOF)
   (tokens value-tokens var-tokens format-tokens syntax-tokens)
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
       

    (expressao [(NUMERO) (value $1)]
               [(IDENTIFICADOR) (var $1)]
               [(STRING) (value $1)])

    (formato   [(FINT) (format $1)]
               [(FCHAR)(format $1)]
               [(FFLOAT)(format $1)]
               [(FDOUBLE)(format $1)])
    )))

(define (parse ip)
  (prop-testv1-parser (lambda () (next-token ip))))

(provide parse)


