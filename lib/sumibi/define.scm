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
   sumibi-candidate-top-limit
   sumibi-evaluate-okurigana
   sumibi-dict-max-characters
   sumibi-word-times-rate
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
  " $Date: 2006/08/11 12:48:30 $ on CVS " ;;VERSION;;
  )

;; 評価バランス ( skip-2重マルコフ 2重マルコフ 1重マルコフ 2重マルコフ skip-2重マルコフ)
(define sumibi-evaluate-balance   '(0.5 0.5 0.1 0.5 0.5))

;; 出現頻度上位 N位を次の共起頻度計算のステージに乗せる
(define sumibi-candidate-top-limit  8)

;; 送りがな付きの単語の評価値計数
(define sumibi-evaluate-okurigana (/ 1.0 40.0))

;; 外部との動作インターフェースモード ( 'std  か 'cgi )
(define sumibi-interface 'std)

;; 辞書に登録する単語の最大文字数
(define sumibi-dict-max-characters 30)

;; ユーザー履歴中の頻度に対する重み(何倍するか)
(define sumibi-word-times-rate 2)

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
