
(define sumibi-version "0.0.1")
(define driver (dbi-make-driver "mysql"))

;; ɾ���Х�� ( skip-2�ťޥ륳�� 2�ťޥ륳�� 1�ťޥ륳�� 2�ťޥ륳�� skip-2�ťޥ륳��)
(define sumibi-evaluate-balance   '(0.1 0.3 0.1 0.3 0.1))

;; ���꤬���դ���ñ���ɾ���ͷ׿�
(define sumibi-evaluate-okurigana (/ 1.0 30.0))
