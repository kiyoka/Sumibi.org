(use file.util)
(use dbd.mysql)

(define sumibi-debug #f)

(define sumibi-version 
  " $Date: 2006/03/05 11:54:58 $ on CVS " ;;VERSION;;
  )
(define driver (dbi-make-driver "mysql"))

;; ɾ���Х�� ( skip-2�ťޥ륳�� 2�ťޥ륳�� 1�ťޥ륳�� 2�ťޥ륳�� skip-2�ťޥ륳��)
(define sumibi-evaluate-balance   '(0.1 0.3 0.1 0.3 0.1))

;; ���꤬���դ���ñ���ɾ���ͷ׿�
(define sumibi-evaluate-okurigana (/ 1.0 30.0))

;; �����Ȥ�ư��󥿡��ե������⡼�� ( 'std  �� 'cgi )
(define sumibi-interface 'std)

;; �桼����������ɤ߹���
(if (file-exists? "./.sumibi")
    (load         "./.sumibi")
    (when (file-exists? (expand-path "~/.sumibi"))
	  (load         "~/.sumibi")))

;; ñ�콤���ѥ᥽�åɵ���ꥹ��
(define sumibi-method-list '( 
			     (k . k)
			     (h . h)
			     (e . l)
			     (l . l)
			     (j . j)))
