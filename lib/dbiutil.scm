#!/usr/local/bin/gosh

;;
;; DBI のアクセス用ユーティリティー
;;

(use dbi)
(use gauche.collection)
(use text.tr)


;; SQLのSELECTコマンドを発行して、結果をリストで取得する
;; カラムの型は、この関数専用のフォーマットで与える
;; 例)
;;   呼出し
;;     (sumibi-select-squery "SELECT * FROM t;" "dds" query)
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


;; sumibi-select-query で求めた結果から、第一カラムの値のリストを作る
;;
(define (sumibi-result-slice rows)
  (when (null? rows)
	rows)
  (map
   (lambda (x)
     (car x))
   rows))




;; SQLのSELECT以外のクエリを発行する
;;
(define (sumibi-query query sql)
  (guard (exc
	  ((is-a? exc <dbi-exception>)
	   ((display "error: ")(display (ref exc 'message))(newline)
	    (display "query: ")(display sql)(newline)
	    (exit 1))))
	 (dbi-execute-query query sql)))

