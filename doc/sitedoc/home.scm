#!/usr/local/bin/gosh /usr/local/bin/sxmlcnv


(load "common.scm")


(define (L:body)
  '(body 
    (center
     (a (@ (href "mailto:kiyoka@netfort.gr.jp"))
	"email: Kiyoka Nishiyama"))

    (*section
     "Sumibiとは？" #f
     (ul 
      (li "Sumibiはオープンソースのローマ字かな漢字変換システムです。")
      (li "Internet上のドキュメントを読み込んでひとりでに賢くなる新感覚の日本語入力方式です。")
      (li ,W:GPL "のもとで配布されています。"))
     (*subsection
      "特徴" #f
      (ul 
       (li ""))))

    (*section 
     "とりあえず使ってみる。" #f
     (ul
      (li (*link "Webブラウザから使う" "ajax/"))
      (li (*link "Emacsに組みこむ" "sumibi_emacs.html"))))))



;; ページの出力
(output "Home" (L:body))
