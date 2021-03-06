#!/usr/local/bin/gosh /usr/local/bin/sxmlcnv


(load "./common.scm")


(define (L:body)
  '(
    (*section
     "Sumibiとは？"
     "What is Sumibi?"
     (*ja
      (p
       (img (@ (src "sumibi_picture.png")))
       (ul 
        (li "Sumibiはオープンソースの日本語入力メソッドです。")
        (li "Internet上のドキュメントを読み込んでひとりでに賢くなる新感覚の漢字変換エンジンを持っています。")
        (li (*link "sourceforge.jp" "http://sourceforge.jp/projects/sumibi/") "からダウンロードできます。")
        (li ,W:GPL "のもとで配布されています。(サンプル等はLGPLになっています。)"))))
     (*en
      (p
       (img (@ (src "sumibi_picture.png")))
       (ul 
        (li "Sumibi is an opensource software. ( roman to kanji input method. )")
        (li "Sumibi has unique kanji conversion engine. Sumibi's dictionary can be built from Intenet pages.")
        (li "It hosted on " (*link "sourceforge.jp" "http://sourceforge.jp/projects/sumibi/") " site.")
        (li "You can use and redistribute Sumibi under the terms of the " ,W:GPL)))))

    (*section 
     "さっそく使ってみる"
     "Use it now!"
     (*ja
      (ul
       (li (*link "Webブラウザから使う"       "http://www.sumibi.org/"))
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
       ;;(li (*link "Sumibi.orgサーバーの状態を見る" "/sumibi/mrtg/"))
       (li (*link "httpページへのアクセス統計を見る" "/sumibi/webalizer.public/"))
       ;;(li (*link "httpsページへのアクセス統計を見る" "/sumibi/webalizer_s.public/"))
       ))

     (*en
      (p
       ("sorry , Japanese only ..."))))
       
    (*section 
     "もっと使いこなす"
     "More and more..."
     (*ja
      (ul
       (li (*link "SumibiWebAPIを使う(安定版)"                 "sumibi_api_stable.html"))
       (li (*link "SumibiWebAPIを使う(テスト版)"               "sumibi_api_testing.html"))
       (li (*link "SumibiWebAPIをperlモジュールから呼びだす"   "sumibi_pm.html"))
       (li (*link "Sumibi Serverを自分で用意する"              "sumibi_server_setup.html"))
       (li (*link "辞書をダウンロードする"                     "sumi.html"))
       (li (*link "辞書を育てる"                               "sumiyaki.html"))
       ))
     (*en
      (p
       ("sorry , Japanese only ..."))))

    ,W:sf-logo
    ))


;; ページの出力
(output 'sumibi (L:body))
