
(define sumibi-version "0.0.1")
(define driver (dbi-make-driver "mysql"))

;; 評価バランス ( 1重マルコフ 2重マルコフ skip-2重マルコフ)
(define sumibi-evaluate-balance '(0.1 0.3 0.6))
