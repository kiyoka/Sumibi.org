#!/usr/local/bin/gosh /usr/local/bin/sxmlcnv


(load "./common.scm")


(define (L:body)
  '(body
    (center
     (a (@ (href "mailto:kiyoka@netfort.gr.jp"))
	"email: Kiyoka Nishiyama"))

    (*section
     "Sumibiとは？"
     "What is Sumibi?"
     (*ja
      (ul 
       (li "Sumibiはオープンソースのローマ字漢字変換入力メソッドです。")
       (li "Internet上のドキュメントを読み込んでひとりでに賢くなる新感覚の変換エンジンを持っています。")
       (li (*link "sourceforge.jp" "http://sourceforge.jp/projects/sumibi/") "にて、開発しています。")
       (li ,W:GPL "のもとで配布されています。")))
     (*en
      (ul 
       (li "Sumibi is an opensource software. ( roman to kanji input method. )")
       (li "Sumibi has unique kanji conversion engine. Sumibi's dictionary can be built from Intenet pages.")
       (li "It hosted on " (*link "sourceforge.jp" "http://sourceforge.jp/projects/sumibi/") " site.")
       (li "You can use and redistribute Sumibi under the terms of the " ,W:GPL))))

    (*section 
     "とりあえず使ってみる。"
     "Use it now!"
     (*ja
      (ul
       (li (*link "Webブラウザから使う" "ajax/"))
       (li (*link "Emacsに組みこむ" "sumibi_el.html"))))
     (*en
      (ul
       (li (*link "on your Web browser" "ajax/"))
       (li (*link "on Emacs editor" "sumibi_el.html")))))

    ,W:sf-logo
    ))


;; ページの出力
(output "Home" (L:body))
