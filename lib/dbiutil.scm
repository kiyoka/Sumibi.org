#!/usr/local/bin/gosh

;;
;; DBI �Υ��������ѥ桼�ƥ���ƥ���
;;

(use dbi)
(use gauche.collection)
(use text.tr)


;; SQL��SELECT���ޥ�ɤ�ȯ�Ԥ��ơ���̤�ꥹ�ȤǼ�������
;; �����η��ϡ����δؿ����ѤΥե����ޥåȤ�Ϳ����
;; ��)
;;   �ƽФ�
;;     (sumibi-select-squery "SELECT * FROM t;" "dds" query)
;;   format-string �Υ롼��
;;     d ... ���ͷ�
;;     s ... ʸ����
;;   ��̥ꥹ��
;;     (
;;       (             ;; ������
;;         (10
;;         (20
;;         ("value1")
;;       )
;;       (             ;; ������
;;         (100
;;         (200
;;         ("value2")
;;       )
;;    )
;;
(define (sumibi-select-query query sql format-string)
  (let* (
	 (_ 
	  (guard (exc
		  ((is-a? exc <dbi-exception>)
		   ((display "error: ")(display (ref exc 'message))(newline)
		    (display "query: ")(display sql)(newline)
		    (exit 1))))
		 (dbi-execute-query query sql)))
	 (format-list '())
	 (__
	  (dotimes (i (string-length format-string))
		   (set! format-list (append format-list (list (cons i (string (string-ref format-string i))))))))
	 (result
	  (map
	   (lambda (row)
	     (map
	      (lambda (x)
		(cond
		 ((string=? (cdr x) "d")
		  (let ((res (dbi-get-value row (car x))))
		    (if res
			(string->number res)
			0)))
		 ((string=? (cdr x) "s")
		  (let ((res (dbi-get-value row (car x))))
		    (if res
			res
			"")))))
	      format-list))
	   _)))
    result))


;; sumibi-select-query �ǵ�᤿��̤��顢��쥫�����ͤΥꥹ�Ȥ���
;;
(define (sumibi-result-slice rows)
  (when (null? rows)
	rows)
  (map
   (lambda (x)
     (car x))
   rows))




;; SQL��SELECT�ʳ��Υ������ȯ�Ԥ���
;;
(define (sumibi-query query sql)
  (guard (exc
	  ((is-a? exc <dbi-exception>)
	   ((display "error: ")(display (ref exc 'message))(newline)
	    (display "query: ")(display sql)(newline)
	    (exit 1))))
	 (dbi-execute-query query sql)))

