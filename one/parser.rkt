#lang racket

(require parser-tools/yacc
         "lexer.rkt"
         "one-syntax.rkt")

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

    (comandos [(INPUT IDENTIFICADOR ATRIBUIDOR input_declaracao PVIRGULA)(input (var $2) $4)]
              [(INPUT IDENTIFICADOR PVIRGULA)(assign-null (var $2))])

    (input_declaracao [(OPENCH INT VIRGULA expressao_boleana CLOSECH)
                       (input_declaracao $4)])
    
    (expressao_boleana [(NUMERO) (value $1)]
                       [(IDENTIFICADOR) (var $1)]
                       [(expressao_boleana MENOR expressao_boleana) (menor $1 $3)]
                       [(expressao_boleana MAIOR expressao_boleana) (maior $1 $3)]
                       [(expressao_boleana IGUAL expressao_boleana) (igual $1 $3)])
    )))

(define (parse ip)
  (prop-testv1-parser (lambda () (next-token ip))))

(provide parse)


