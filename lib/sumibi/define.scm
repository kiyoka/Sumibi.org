;;
;; sumibiの定義値
;;
(define-module sumibi.define
  (use file.util)
  (use dbd.mysql)
  (export 
   sumibi-debug
   sumibi-version
   sumibi-evaluate-balance
   sumibi-evaluate-okurigana
   sumibi-interface
   sumibi-method-list
   sumibi-sumibidb-host
   sumibi-sumibidb-name
   sumibi-sumibidb-user
   sumibi-sumibidb-password
   sumibi-sumiyakidb-host
   sumibi-sumiyakidb-name
   sumibi-sumiyakidb-user
   sumibi-sumiyakidb-password))

(select-module sumibi.define)


(define sumibi-debug #f)

(define sumibi-version 
  " $Date: 2006/06/05 14:44:01 $ on CVS " ;;VERSION;;
  )

;; 評価バランス ( skip-2重マルコフ 2重マルコフ 1重マルコフ 2重マルコフ skip-2重マルコフ)
(define sumibi-evaluate-balance   '(0.1 0.5 0.1 0.5 0.1))

;; 送りがな付きの単語の評価値計数
(define sumibi-evaluate-okurigana (/ 1.0 30.0))

;; 外部との動作インターフェースモード ( 'std  か 'cgi )
(define sumibi-interface 'std)


;;
;; DBサーバーに接続するためのパラメータ ( DBサーバーソフトウェアはMySQL固定 )
;;
(define sumibi-sumibidb-host       "localhost")
(define sumibi-sumibidb-name       "")
(define sumibi-sumibidb-user       "")
(define sumibi-sumibidb-password   "")

(define sumibi-sumiyakidb-host     "localhost")
(define sumibi-sumiyakidb-name     "")
(define sumibi-sumiyakidb-user     "")
(define sumibi-sumiyakidb-password "")


;; 単語修飾用メソッド記号リスト
(define sumibi-method-list '( 
			     (k . k)
			     (h . h)
			     (e . l)
			     (l . l)
			     (j . j)))

;; ユーザー設定を読み込む
(if (file-exists? "./.sumibi")
    (load         "./.sumibi")
    (when (file-exists? (expand-path "~/.sumibi"))
	  (load         "~/.sumibi")))



(provide "sumibi/define")
