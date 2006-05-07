;;
;; DBI �Υ��������ѥ桼�ƥ���ƥ���
;;

(use dbi)
(use gauche.collection)
(use text.tr)

;;
;; DB�����С�����³���� ( DB�����С���MySQL���� )
;;
;;   DB�����С�����³�����餽�Υ��ͥ��������֤�
;;   �Ĥ��Ǥˡ����饤����Ȥ�utf8�Ǥ���ݤ�MySQL�˿��𤷤Ƥ���
;;
(define (sumibi-db-connect host dbname user password)
  (let* (
	 (conn
	  (guard (exc
		  ((is-a? exc <dbi-exception>)
		   ((display "error  : ")(display (ref exc 'message))(newline)
		    (display "host   : ")(display host)(newline)
		    (display "dbname : ")(display dbname)(newline)
		    (display "user   : ")(display user)(newline)
		    (exit 1))))
		 (dbi-connect
		  (format #f "dbi:mysql:~a;host=~a" dbname host)
		  :username user 
		  :password password)))
	 (query (dbi-prepare
		 conn
		 "SET CHARACTER SET utf8;"))
	 (result (dbi-execute query)))
    conn))

	 

;; SQL��SELECT���ޥ�ɤ�ȯ�Ԥ��ơ���̤�ꥹ�ȤǼ�������
;; �����η��ϡ����δؿ����ѤΥե����ޥåȤ�Ϳ����
;; ��)
;;   �ƽФ�
;;     (sumibi-select-query conn "SELECT * FROM t;" "dds")
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
(define (sumibi-select-query conn sql format-string)
  (let* (
	 (_ 
	  (guard (exc
		  ((is-a? exc <dbi-exception>)
		   ((display "error: ")(display (ref exc 'message))(newline)
		    (display "query: ")(display sql)(newline)
		    (exit 1))))
		 (dbi-execute 
		  (dbi-prepare conn sql))))
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
(define (sumibi-query conn sql)
  (guard (exc
	  ((is-a? exc <dbi-exception>)
	   ((display "error: ")(display (ref exc 'message))(newline)
	    (display "query: ")(display sql)(newline)
	    (exit 1))))
	 (dbi-execute 
	  (dbi-prepare conn sql))))


;; ��ñ�ʻ��Ԥ�
(if #f
    (begin
      (define sumibi-debug #f)
      (load "~/.sumibi")
      (define (main args)  (sumibi-db-test))))
    
(define (sumibi-db-test)
  (let* (
	 (conn
	  (sumibi-db-connect 
	   sumibi-sumibidb-host
	   sumibi-sumibidb-name
	   sumibi-sumibidb-user
	   sumibi-sumibidb-password))
	 (result
	  (sumibi-select-query
	   conn
	   "show tables;" "s")))
    (print result)
    ))



