(use file.util)


(define sumibi-debug #f)

(define sumibi-version "0.0.1")
(define driver (dbi-make-driver "mysql"))

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
