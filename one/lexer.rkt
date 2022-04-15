#lang racket

(require parser-tools/lex
         (prefix-in : parser-tools/lex-sre))

(define-tokens value-tokens (NUMERO STRING))
(define-tokens var-tokens (IDENTIFICADOR))
(define-empty-tokens syntax-tokens
  (EOF
   ATRIBUIDOR
   VIRGULA
   PVIRGULA
   OPENCH
   CLOSECH
   INT
   FLOAT
   CHAR
   DOUBLE
   INPUT
   MENOR
   MAIOR
   IGUAL))

(define next-token
  (lexer-src-pos
   [(eof) (token-EOF)]
   [(:+ #\n whitespace)
    (return-without-pos (next-token input-port))]
   ["=" (token-ATRIBUIDOR)]
   [","  (token-VIRGULA)]
   [";" (token-PVIRGULA)]
   ["["  (token-OPENCH)]
   ["]"  (token-CLOSECH)]
   ["<"  (token-MENOR)]
   [">"  (token-MAIOR)]
   ["=="  (token-IGUAL)]
   ["int"  (token-INT)]
   ["float"  (token-FLOAT)]
   ["char"  (token-CHAR)]
   ["double"  (token-DOUBLE)]
   ["input" (token-INPUT)]
   [(:seq #\" (complement (:seq any-string #\" any-string)) #\")
    (token-STRING (substring lexeme 1 (sub1 (string-length lexeme))))]
   [(:: alphabetic (:* (:+ alphabetic numeric)))
    (token-IDENTIFICADOR lexeme)]
   [(:: numeric (:* numeric))
    (token-NUMERO (string->number lexeme))]
  [(:: numeric (:* numeric) "." (:: numeric (:* numeric)))
    (token-NUMERO (string->number lexeme))]))

(provide next-token value-tokens var-tokens syntax-tokens)


