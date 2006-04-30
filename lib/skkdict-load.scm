;;
;; SKK の辞書を読み込んで、テーブルに登録する
;;

(use gauche.regexp)
(use srfi-1)
(use dbi)
(load "sumibi/romkan.scm")
(load "sumibi/dbiutil.scm")


;; 文字列を 1文字 1件のリストにして返す
(define (string->char-list str)
  (let ((len (string-length str))
	(li '())
	(i 0))
    (dotimes (i len)
	     (set! li (append li (list (substring str i (+ i 1))))))
    li))


;(print (last-pair (string->char-list "abcde")))
;(exit)


;; ひらがな解析
;;  "あa" を ("あ" "a") に分割する
(define (hira-analyze str)
  (let* ((char-list (string->char-list str))
	 (last (car (reverse char-list))))

    (if (and (rxmatch #/[あ-ん]/ (car char-list))
	     (rxmatch #/[a-z]/ last))
	(list (string-join (drop-right char-list 1) "")
	      last)
	(list (string-join char-list "")
	      ""))))
	  

;(display (hira-analyze "あいうa")) (newline)
;(display (hira-analyze "あいう"))  (newline)
;(display (hira-analyze "abc"))     (newline)
;(exit)



;; SKK辞書をロードしてデータベースに登録する
(define (sumibi-skkdict-load input-port conn)
  (for-each
   (lambda (x)
     (when (not (rxmatch #/^;/ x))
	   (begin
	     (when sumibi-debug
		   (begin
		     (display " ### ")
		     (display x)
		     (display " ### ")))

	     (let* (
		    ;; '("わらu" "/笑/嗤/")
		    (field (list
			    (string-scan x 
					 " "
					 'before)
			    (string-scan x 
					 " "
					 'after)))
		    ;; '("笑;ab" "嗤")
		    (_ (cdr (drop-right (string-split (cadr field) "/") 1)))
		    ;; '("笑" "嗤")
		    (words
		     (filter-map
		      (lambda (x)
			(if (rxmatch #/^\(/ x)
			    ;; S式は除外する
			    #f
			    ;; それ以外
			    (or (string-scan x 
					     ";"
					     'before)
				x)))
		      _))

		    ;; '("わら" "u")
		    (hira-list (hira-analyze (car field)))
		    ;; "wara"
		    (roman (romkan-kana->roman (car hira-list)))
		  
		    ;; result
		    (result
		     (list
		      (cons 'hira
			    (car hira-list))
		      (cons 'okuri
			    (cadr hira-list))
		      (cons 'kanji
			    (list words))))
		    )

	       ;; デバッグ表示
	       (for-each 
		(lambda (kanji-str)
		  (let*
		      ((query-string
			(format "INSERT LOW_PRIORITY INTO word VALUES (NULL, 's', ~s, ~s, ~s, ~s, 1, 0);" 
				(romkan-kana->roman (cdr (assoc 'hira result)))
				(cdr (assoc 'hira result))
				(cdr (assoc 'okuri result))
				kanji-str
				))

		       (result-set (sumibi-query conn
						 query-string
						 )))
		       
		    (when sumibi-debug
			  (begin
			    (display result)
			    (display " ### " )
			    (display query-string)
			    (newline)))))
		(cadr (assoc 'kanji result)))
	       ))))

     (port->string-list input-port)))




