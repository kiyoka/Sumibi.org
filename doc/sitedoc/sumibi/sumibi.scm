#!/usr/local/bin/gosh /usr/local/bin/sxmlcnv


(load "./common.scm")


(define (L:body)
  '(body
    ,L:tab

    (*section
     "Sumibiとは？"
     "What is Sumibi?"
     (*ja
      (ul 
       (li "Sumibiはオープンソースの日本語入力メソッドです。")
       (li "Internet上のドキュメントを読み込んでひとりでに賢くなる新感覚の漢字変換エンジンを持っています。")
       (li (*link "sourceforge.jp" "http://sourceforge.jp/projects/sumibi/") "にて、開発しています。")
       (li ,W:GPL "のもとで配布されています。")))
     (*en
      (ul 
       (li "Sumibi is an opensource software. ( roman to kanji input method. )")
       (li "Sumibi has unique kanji conversion engine. Sumibi's dictionary can be built from Intenet pages.")
       (li "It hosted on " (*link "sourceforge.jp" "http://sourceforge.jp/projects/sumibi/") " site.")
       (li "You can use and redistribute Sumibi under the terms of the " ,W:GPL))))

    (*section 
     "さっそく使ってみる"
     "Use it now!"
     (*ja
      (ul
       (li (*link "Webブラウザから使う" "http://www.sumibi.org/sumibi-ajax/"))
       (li (*link "Emacsに組みこむ(安定版)"   "sumibi_el_stable.html"))
       (li (*link "Emacsに組みこむ(テスト版)" "sumibi_el_testing.html"))))
     (*en
      (p
       ("sorry , Japanese only ..."))))

    (*section 
     "もっと知る"
     "Learn more..."
     (*ja
      (ul
       (li (*link "よくある質問を読む" "faq.html"))
       (li (*link "Sumibi.orgの状態を見る" "/sumibi/mrtg/"))))
     (*en
      (p
       ("sorry , Japanese only ..."))))
       
;;    (*section 
;;     "もっと使いこなす"
;;     "More and more..."
;;     (*ja
;;      (ul
;;       (li (*link "Sumibi Serverを自分で用意する" "http://www.sumibi.org/sumibi-ajax/"))
;;       (li (*link "辞書を育てる" "sumibi_el_ja.html"))))
;;     (*en
;;      (p
;;       ("sorry , Japanese only ..."))))

    ,W:sf-logo
    ))


;; ページの出力
(output 'sumibi (L:body))
