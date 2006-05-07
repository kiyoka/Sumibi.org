(use file.util)
(use dbd.mysql)

(define sumibi-debug #f)

(define sumibi-version 
  " $Date: 2006/05/07 11:41:56 $ on CVS " ;;VERSION;;
  )

;; 評価バランス ( skip-2重マルコフ 2重マルコフ 1重マルコフ 2重マルコフ skip-2重マルコフ)
(define sumibi-evaluate-balance   '(0.1 0.3 0.1 0.3 0.1))

;; 送りがな付きの単語の評価値計数
(define sumibi-evaluate-okurigana (/ 1.0 30.0))

;; 外部との動作インターフェースモード ( 'std  か 'cgi )
(define sumibi-interface 'std)

;; ユーザー設定を読み込む
(if (file-exists? "./.sumibi")
    (load         "./.sumibi")
    (when (file-exists? (expand-path "~/.sumibi"))
	  (load         "~/.sumibi")))

;; 単語修飾用メソッド記号リスト
(define sumibi-method-list '( 
			     (k . k)
			     (h . h)
			     (e . l)
			     (l . l)
			     (j . j)))
