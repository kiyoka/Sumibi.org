;;
;; コーパスを読み込んで、テーブルに登録する
;;

(define-module sumibi.corpus
  (use gauche.regexp)
  (use srfi-1)
  (use dbi)
  (use gauche.collection)
  (use util.combinations)
  (use text.tr)
  (use text.kakasi)
  (use sumibi.define)
  (use sumibi.romkan)
  (use sumibi.dbiutil)
  (export sumibi-corpus-load))
(select-module sumibi.corpus)


;; 送りがなの処理を追加してマッチするかどうかをチェックする
(define (sumibi-decide-id-with-okuri tango rows conn)
  (let*
      (
       ;; 漢字部分と送り部分を分割して確認する
       (match (rxmatch #/([あ-ん]+)$/ tango))
       ;; 漢字部分と送り部分を分割して確認する
       (kanji
	(or (rxmatch-before match)
	    tango))
       (okuri-kana
	(if match
	    (match)
	    ""))
       (okuri-roman
	(romkan-kana->roman okuri-kana))
       (okuri
	(if (< 0 (string-length okuri-roman))
	    (substring okuri-roman 0 1)
	    ""))
       )

    (when sumibi-debug
	  (begin
	    (display (format "kanji=~s okuri=~s" kanji okuri))
	    (newline)))

    (cond ((= 0 (string-length kanji))
	   ;; 平仮名のみの場合
	   rows)
	  (#t
	   ;; 漢字が含まれている場合
	   (let* (
		  (sql
		   (format "SELECT id, tango, okuri FROM word WHERE tango = ~s and okuri = ~s;" kanji okuri))
		  (rows
		   (sumibi-dbi-slice-result
		    (sumibi-dbi-read-query conn sql "d"))))

	     (when sumibi-debug
		   (begin
		     (display " #1# ") (display sql) (display "   ")
		     (display rows) (newline)))

	     ;; 送りがなを送りがなテーブルに登録する
	     (when (< 0 (length rows))
		   (begin
		     (sumibi-register-okuri okuri-kana conn)
		     (when sumibi-debug
			   (display (format "OKURI: kanji=~s okuri=~s okuri-kana=~s" kanji okuri okuri-kana)))))
	     rows)))))
	    


;; 送り仮名が形態素解析で分離されているものを、辞書を使って結合可能かチェックする
(define (sumibi-is-exist-series-word tango next-tango conn)
  (if (romkan-is-hiragana next-tango)
      (let* (
	     (okuri
	      (substring 
	       (romkan-kana->roman next-tango)
	       0 1))
	     (sql
	      (format "SELECT id, tango, okuri FROM word WHERE tango = ~s and okuri = ~s;" tango okuri))
	     (rows
	      (sumibi-dbi-slice-result
	       (sumibi-dbi-read-query conn sql "d"))))

	(< 0 (length rows)))
      #f))




;; 送りがなを送りがなテーブルに登録する
(define (sumibi-register-okuri kana conn)
  (let* (
	 (okuri
	  (substring  
	   (romkan-kana->roman 
	    kana)
	   0 1))
	 (sql1
	  (format "INSERT LOW_PRIORITY IGNORE okuri (okuri, kana, freq_base) VALUES( ~s, ~s, 1 );"
		  okuri
		  kana))
	 (sql2
	  (format "UPDATE LOW_PRIORITY okuri SET freq_base=freq_base+1 WHERE okuri = ~s AND kana = ~s;"
		  okuri
		  kana))

	 (_
	  (when sumibi-debug
		(begin
		  (display "#3# ") (display sql1) (display "   ") (display sql2)
		  (newline))))

	 (_
	  (sumibi-dbi-write-query conn 
				  sql1
				  ))
	 (_
	  (sumibi-dbi-write-query conn 
				  sql2
				  ))))
  #t)


;; 送り仮名が形態素解析で分離してしまっている連語を統合する
(define (sumibi-union-series-word wakachi-list conn)
  (cond ((null? wakachi-list)
	 '())
	((> 2 (length wakachi-list))
	 wakachi-list)
	(else
	   (if
	    (sumibi-is-exist-series-word 
	     (car wakachi-list)
	     (cadr wakachi-list)
	     conn)
	    (begin
	      (display (format "#2# GOT okuri( ~s ~s )" (car wakachi-list) (cadr wakachi-list)))
	      (newline)

	      ;; 送りがな部を結合する
	      (cons
	       (string-append
		(car wakachi-list)
		(cadr wakachi-list))
	       (sumibi-union-series-word (cddr wakachi-list) conn)))
	    (cons
	     (car wakachi-list)
	     (sumibi-union-series-word (cdr wakachi-list)  conn))))))



;; コーパスの単語からDB中のidを決定する
(define (sumibi-tango->tango-id tango conn)
  (let* (
	 (sql     
	  (format "SELECT id, tango, okuri FROM word WHERE tango = ~s AND tango IS NOT NULL;" tango))
	 (rows
	  (sumibi-dbi-slice-result
	   (sumibi-dbi-read-query conn sql "d")))
	 )
    (when sumibi-debug
	  (begin
	    (display "#3# ") (display sql) (display "   ")
	    (display rows) (newline)))
	  
    (cond ((rxmatch #/^[\.0-9０-９]+$/ tango)
	   ;; 数字のみで構成される場合、数値型レコードのIDをもとめて返す (小数点もOK)
	   (sumibi-dbi-slice-result
	    (sumibi-dbi-read-query conn "SELECT id FROM word WHERE kind = 'n';" "d")))

	  ((not (null? rows))
	   ;; そのままの文字列でデータベースから結果が取得できた場合
	   rows)

	  (else
	   ;; 送りがなの処理を追加してマッチするかどうかをチェックする
	   (let* ((result (sumibi-decide-id-with-okuri tango rows conn)))
	     (cond (
		    
		    ;; 新規の単語を学習する(英単語、ひらがな、カタカナ語で未定義の単語を、word テーブルに追加する)
		    (and
		     (null? result)
		     (rxmatch #/^[a-zA-Zあ-んア-ンー]+$/ tango))
		    
		    (let* (
			   (yomiank (romkan-kana->roman tango))
			   (yomi    (romkan-katakana->hiragana tango))
			   (sql
			    (format "INSERT LOW_PRIORITY INTO word (id, kind, yomiank, yomi, okuri, tango, freq_base, freq_user) VALUES( NULL, 'c', ~s, ~s, '', ~s, 1, 0);"
				    yomiank
				    yomi
				    tango
				    ))
			   (_       (sumibi-dbi-write-query conn sql)))
		      
		      (when sumibi-debug
			    (begin
			      (display "#4# ") (display sql) 
			      (newline)))
		      
		      (sumibi-tango->tango-id tango conn)))

		   (else
		    ;; 学習処理なし
		    result)))))))



;; コーパスの１行を入力して わかち書きしたリストを返す
(define (sumibi-corpus-wakachi-gaki str)
  (let ((result #f))
    (kakasi-begin :JJ :s)
    (set! result (kakasi-convert str))
    (kakasi-end)
    result))


;; ペアの単語をテーブルに登録する
(define (register-pair-to-bigram pair-member conn table-name)
  (let (
	(first-word  (or (caar pair-member)
			 '()))
	(second-word (or (caadr pair-member)
			 '())))
	
    (when sumibi-debug
	  (begin
	    (display (format "#7(~s)#" table-name))
	    (display " /// ")
	    (display pair-member)
	    (display " /// ")
	    (newline)))

    ;; デカルト積を求めてDBに登録する。
    (for-each
     (lambda (x)
       (let* (
	      (sql1
	       (format "INSERT LOW_PRIORITY IGNORE ~a (id_m1, id_base, freq_base, freq_user) VALUES( ~d, ~d, 0, 0 );"
		       table-name
		       (car x)
		       (cadr x)))
	      (_       (sumibi-dbi-write-query conn sql1))
	      (sql2
	       (format "UPDATE LOW_PRIORITY ~a SET freq_base=freq_base+1 WHERE id_m1 = ~d and id_base = ~d;"
		       table-name
		       (car x)
		       (cadr x)))
	      (_       (sumibi-dbi-write-query conn sql2))
	      (sql3
	       (format "UPDATE LOW_PRIORITY word SET freq_base=freq_base+1 WHERE id = ~d;"
		       (car x)))
	      (_       (sumibi-dbi-write-query conn sql3))
	      (sql4
	       (format "UPDATE LOW_PRIORITY word SET freq_base=freq_base+1 WHERE id = ~d;"
		       (cadr x)))
	      (_       (sumibi-dbi-write-query conn sql4))
	      )
	 (when sumibi-debug
	       (begin
		 (display " ;;; ")
		 (display sql1)
		 (display " ;;; ")
		 (display sql2)
		 (display " ;;; ")
		 (display sql3)
		 (display " ;;; ")
		 (display sql4)
		 (display " ;;; ")
		 (newline)))))

     (cartesian-product-right (list first-word second-word)))))


;; わかち書きされたリストからbigramテーブルに出現頻度を登録する
;; ( ((1 2 3 4) "単語") ((100 "を")) ... )
(define (register-to-bigram wakachi-list conn)
  (if (> 2 (length wakachi-list))
      #f
      (begin
	(register-pair-to-bigram (list 
				  (car wakachi-list)
				  (cadr wakachi-list))
				 conn
				 "bigram")
	(register-to-bigram (cdr wakachi-list) conn))))


;; わかち書きされたリストからskip_bigramテーブルに出現頻度を登録する
;; bigram テーブルとの違いは、隣接する単語どうしではなく、一つの単語を飛ばした単語どうしを登録する
;;  以下の例では [単語] と [登録] という単語が 組合せで登録される
;;   ( ((1 2 3 4) "単語") ((100 "を")) ((125 "登録")) ... )
(define (register-to-skip-bigram wakachi-list conn)
  (if (> 3 (length wakachi-list))
      #f
      (begin
	(register-pair-to-bigram (list 
				  (car wakachi-list)
				  (caddr wakachi-list))
				 conn
				 "skip_bigram")
	(register-to-skip-bigram (cdr wakachi-list) conn))))


;; コーパス全体を入力して 読点までを１行に分割する
;; (１行を１文字列としたリストを返す)
(define (corpus-split-to-sentence input-port)
  (let (
	(str
	 (port->string
	  input-port)))
    (map 
     (lambda (x)
       ;; 各行の最後に読点を付ける
       (string-append x "。"))
     (string-split
      (string-tr str "\n" "" :delete #t)
      #/[。．]/))))


;; コーパスを読み込んで、テーブルに登録する
(define (sumibi-corpus-load-from-port input-port conn)
  (let* (
	 (line-list
	  (corpus-split-to-sentence input-port)))
	 
    (for-each
     (lambda (x)
       (begin
	 (let* (
		;; ("笑う" "門" "に" "は")
		(word-list
		 (string-split
		  (sumibi-corpus-wakachi-gaki x)
		  #/[\s]+/))
		
		;; 複数の単語に分かれている送りがなを一つの単語に統合する
		(word-list (sumibi-union-series-word word-list conn))
		
		;; 各単語の単語IDをDBから求める
		(result
		 (map
		  (lambda (arg)
		    (list
		     (sumibi-tango->tango-id arg conn)
		     arg))
		  word-list))
		)
		       
	   ;; デバッグ表示
	   (when sumibi-debug
		 (begin
		   (display "#8# ")
		   (write result)
		   (newline)))
		       
	   ;; bigram テーブルに連鎖して出現する頻度を登録する
	   (register-to-bigram result conn)
	   ;; skip-bigram テーブルに連鎖して出現する頻度を登録する
	   (register-to-skip-bigram result conn))))

     line-list)))



;; 新規のコーパスファイルの場合だけ、ロードする。
(define (sumibi-corpus-load input-port input-file conn)
  (let* (
	 ;; 入力ファイルが、既に処理済みかどうかを調べる
	 (sql     (format "SELECT filename FROM file WHERE filename = ~s;" input-file))
	 (rows
	  (sumibi-dbi-slice-result
	   (sumibi-dbi-read-query conn
				  sql
				  "s"))))

    (if (< 0 (length rows))
	(begin
	  (display (format "#5# already load file [~s]   " input-file))
	  (newline))
	(begin
	  (sumibi-corpus-load-from-port input-port conn)
	  ;; 読み込んだファイル名をデータベースに登録する。
	  (let* (
		 (_       (sumibi-dbi-write-query conn 
						  (format "INSERT LOW_PRIORITY IGNORE file ( filename, date ) VALUES ( ~s, NOW() );" input-file)))))))))


(provide "sumibi/corpus")
