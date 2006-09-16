#!/usr/local/bin/gosh /usr/local/bin/sxmlcnv

(load "./common.scm")

(define (L:body)
  '(
    (*slide "Sumibiとは？"
            (*ul 
             (li "Sumibiはオープンソースの日本語入力メソッドです。")
             (li "Internet上のドキュメントを読み込んでひとりでに賢くなる新感覚の漢字変換エンジンを持っています。")
             (li (*link "sourceforge.jp" "http://sourceforge.jp/projects/sumibi/") "からダウンロードできます。")
             (li ,W:GPL "のもとで配布されています。(サンプル等はLGPLになっています。)")))
    
    (*slide "さっそく使ってみる"
            (*ul-inc
             (li (*link "Webブラウザから使う"       "http://www.sumibi.org/"))
             (li (*link "Emacsに組みこむ(安定版)"   "sumibi_el_stable.html"))
             (li (*link "Emacsに組みこむ(テスト版)" "sumibi_el_testing.html"))))))

;; ページの出力
(output "世界の果てから漢字変換Sumibiの開発 2006" (L:body))
