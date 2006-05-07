;;
;; DBI のアクセス用ユーティリティー
;;


(define-module sumibi.dbiutil
  (use dbi)
  (use gauche.collection)
  (use text.tr)
  (export sumibi-dbi-connect
	  sumibi-dbi-read-query
	  sumibi-dbi-slice-result
	  sumibi-dbi-write-query))
(select-module sumibi.dbiutil)

;;
;; DBサーバーに接続する ( DBサーバーはMySQL固定 )
;;
;;   DBサーバーに接続したらそのコネクションを返す
;;   ついでに、クライアントがutf8である旨をMySQLに申告しておく
;;
(define (sumibi-dbi-connect host dbname user password)
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

	 

;; SQLのSELECTコマンドを発行して、結果をリストで取得する
;; カラムの型は、この関数専用のフォーマットで与える
;; 例)
;;   呼出し
;;     (sumibi-select-query conn "SELECT * FROM t;" "dds")
;;   format-string のルール
;;     d ... 数値型
;;     s ... 文字列型
;;   結果リスト
;;     (
;;       (             ;; １行目
;;         (10
;;         (20
;;         ("value1")
;;       )
;;       (             ;; ２行目
;;         (100
;;         (200
;;         ("value2")
;;       )
;;    )
;;
(define (sumibi-dbi-read-query conn sql format-string)
  (let* (
	 (_ 
	  (guard (exc
		  ((is-a? exc <dbi-exception>)
		   ((display "error: ")(display (ref exc 'message))(newline)
		    (display "query: ")(display sql)(newline)
		    (exit 1))))
		 (dbi-do conn sql)))
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


;; sumibi-select-query で求めた結果から、第一カラムの値のリストを作る
;;
(define (sumibi-dbi-slice-result rows)
  (when (null? rows)
	rows)
  (map
   (lambda (x)
     (car x))
   rows))




;; SQLのSELECT以外のクエリを発行する
;;
(define (sumibi-dbi-write-query conn sql)
  (guard (exc
	  ((is-a? exc <dbi-exception>)
	   ((display "error: ")(display (ref exc 'message))(newline)
	    (display "query: ")(display sql)(newline)
	    (exit 1))))
	 (dbi-do conn sql)))


(define (sumibi-dbi-test)
  (let* (
	 (conn
	  (sumibi-dbi-connect 
	   sumibi-sumibidb-host
	   sumibi-sumibidb-name
	   sumibi-sumibidb-user
	   sumibi-sumibidb-password))
	 (result
	  (sumibi-dbi-read-query
	   conn
	   "show tables;" "s")))
    (print result)
    ))

;; 簡単な試験を行う
(if #f
    (begin
      (define sumibi-debug #f)
      (load "~/.sumibi")
      (sumibi-dbi-test)))


(provide "sumibi/dbiutil")



