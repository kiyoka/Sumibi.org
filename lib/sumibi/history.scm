;;
;; ユーザー変換履歴データベースの管理
;;

(define-module sumibi.history
  (use gauche.regexp)
  (use srfi-1)
  (use srfi-13)
  (use dbi)
  (use text.html-lite)
  (use sumibi.define)
  (use sumibi.romkan)
  (use sumibi.dbiutil)
  (export
   sumibi-init-history
   sumibi-add-history
   sumibi-debug-history
   sumibi-word-times-in-history
   )
  (select-module sumibi.history))


;; ユーザー履歴データベースを作成する
(define (sumibi-init-history conn)
  ;; h_wordデータベースの作成
  (sumibi-dbi-write-query conn
                          (string-append
                           "CREATE TEMPORARY TABLE IF NOT EXISTS h_word ("
                           "id INT NOT NULL,"
                           "freq_base INT NOT NULL,"
                           "PRIMARY KEY (id)"
                           " )  ;" ))
  ;; h_bigramデータベースの作成
  (sumibi-dbi-write-query conn
                          (string-append
                           "CREATE TEMPORARY TABLE IF NOT EXISTS h_bigram ("
                           "id_m1   INT NOT NULL,"
                           "id_base INT NOT NULL,"
                           "freq_base INT NOT NULL,"
                           "PRIMARY KEY (id_m1, id_base)"
                           " )  ;" ))
         
  ;; h_bigramデータベースの作成
  (sumibi-dbi-write-query conn
                          (string-append
                           "CREATE TEMPORARY TABLE IF NOT EXISTS h_skip_bigram ("
                           "id_m1   INT NOT NULL,"
                           "id_base INT NOT NULL,"
                           "freq_base INT NOT NULL,"
                           "PRIMARY KEY (id_m1, id_base)"
                           " )  ;" )))


;; ユーザー変換履歴を追加する
(define (sumibi-add-history str conn)

  ;; "単語ID 単語ID 単語ID" の様な文字列を数値のリストに変換する
  (define (convert-to-id-list str)
    (map
     string->number
     (string-split (string-trim-both str) #/[ ]+/)))

  ;; 単漢字出現頻度の生成
  (define (make-history-word str)
    (convert-to-id-list str))

  ;; 隣接する単語の共起頻度の生成
  (define (make-history-bigram str)
    (let1 bigram (convert-to-id-list str)
          (map
           (lambda (x) x)
           (zip
            (drop-right  bigram 1)
            (drop        bigram 1)))))

  ;; 1つ単語をスキップして隣接する単語共起頻度の生成
  (define (make-history-skip-bigram str)
    (let1 bigram (convert-to-id-list str)
          (map
           (lambda (x) x)
           (zip
            (drop-right  bigram 2)
            (drop        bigram 2)))))

  (let (
        (word        
         (make-history-word          str))
        (bigram
         (make-history-bigram        str))
        (skip-bigram 
         (make-history-skip-bigram   str)))

    ;; データベースにユーザー履歴から求めた共起頻度を追加する
    (for-each
     (lambda (id)
       (sumibi-dbi-write-query conn (format "INSERT IGNORE INTO h_word VALUES ( ~a, 0 );" id))
       (sumibi-dbi-write-query conn (format "UPDATE h_word SET freq_base = freq_base + 1 WHERE id = ~a ;" id)))
     word)
    (for-each
     (lambda (x)
       (sumibi-dbi-write-query conn (format "INSERT IGNORE INTO h_bigram VALUES ( ~a, ~a, 0 );" (car x) (cadr x)))
       (sumibi-dbi-write-query conn (format "UPDATE h_bigram SET freq_base = freq_base + 1 WHERE id_m1 = ~a AND id_base = ~a;" (car x) (cadr x))))
     bigram)
    (for-each
     (lambda (x)
       (sumibi-dbi-write-query conn (format "INSERT IGNORE INTO h_skip_bigram VALUES ( ~a, ~a, 0 );" (car x) (cadr x)))
       (sumibi-dbi-write-query conn (format "UPDATE h_skip_bigram SET freq_base = freq_base + 1 WHERE id_m1 = ~a AND id_base = ~a;" (car x) (cadr x))))
     skip-bigram)))


;; 指定IDの単語の出現回数を求める
(define (sumibi-word-times-in-history id conn)
  (let1 _result
        (sumibi-dbi-read-query conn 
                               (format "SELECT freq_base, id FROM h_word WHERE `id` = '~a';" id)
                               "dd")
        (if (< 0 (length _result))
            (*
             sumibi-word-times-rate
             (caar _result))
            0)))


;; 一行コマンドの対話に入る前の初期化
(define (sumibi-debug-history conn)
  (list
   (html:h3 "single-freq:")
   (html:p (write-to-string
            (sumibi-dbi-read-query conn 
                                   "SELECT id, freq_base FROM h_word ORDER BY freq_base;"
                                   "dd")))
   (html:h3 "bigram-freq:")
   (html:p (write-to-string
            (sumibi-dbi-read-query conn 
                                   "SELECT id_m1, id_base, freq_base FROM h_bigram ORDER BY freq_base;"
                                   "ddd")))
   (html:h3 "skip-bigram-freq:")
   (html:p (write-to-string
            (sumibi-dbi-read-query conn 
                                   "SELECT id_m1, id_base, freq_base FROM h_skip_bigram ORDER BY freq_base;"
                                   "ddd")))))
   

