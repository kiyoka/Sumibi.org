#!/usr/local/bin/gosh /usr/local/bin/sxmlcnv


(load "./common.scm")


(define (L:body)
  '(body
    (center
     (a (@ (href "mailto:kiyoka@netfort.gr.jp"))
	"email: Kiyoka Nishiyama"))

    (*section
     "Sumibiとは？" #f
     (ul 
      (li "Sumibiはオープンソースのローマ字漢字変換入力メソッドです。")
      (li "Internet上のドキュメントを読み込んでひとりでに賢くなる新感覚の変換エンジンを持っています。")
      (li (*link "sourceforge.jp" "http://sourceforge.jp/projects/sumibi/") "にて、開発しています。")
      (li ,W:GPL "のもとで配布されています。")))

    (*section 
     "とりあえず使ってみる。" #f
     (ul
      (li (*link "Webブラウザから使う" "ajax/"))
      (li (*link "Emacsに組みこむ" "sumibi_el.html"))))

    (*section
     "特徴" #f
     (ul 
      (li "ローマ字入力のみをサポートします。")
      (li "分かち書きで文節区切りを指定します。")
      ))
    ,W:sf-logo
    ))


;; ページの出力
(output "Home" (L:body))
