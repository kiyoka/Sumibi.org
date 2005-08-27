#!/usr/local/bin/gosh /usr/local/bin/sxmlcnv


(load "./common.scm")


(define (L:body)
  '(body
    ,L:tab

    (*section
     "このドキュメントについて"
     "About this document"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (p
       (p "このドキュメントは" ,W:Sumibi.org "で提供しているような変換サービスをご自分のサイトにセットアップする方法を解説します。")
       (p "Sumibi ServerはCVSリポジトリにしか存在しません。セットアップは若干煩雑なのですが、御了承ください。"))))

    (*section
     "Sumibi Serverとは？"
     "About Sumibi Server"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (p
       (img (@ (src "shichirin.png")))
       (ul
	(li "Sumibi Serverは、Sumibiの漢字変換サービスを提供するサーバです。")
	(li "SOAP 1.1に準拠したAPIで変換サービスを提供します。")
	(li "SOAPに対応したあらゆる言語から利用することができます。")))))
    (*section
     "ソフトウェア構成"
     "Structure"
     (*en
      (p "No documents in English, sorry..." ))
     (*subsection
      "構成図"
      "Structure"
      (*ja
       (p "以下の図ように沢山のソフトウェアコンポーネントを組みあわせて構成されます")
       ;;(img (@ (src "modeline.png")))
       )))

    (*section
     "入手方法"
     "How to get it"
     (*en
      (p "No documents in English, sorry..." ))
     (*subsection
      "ダウンロード場所"
      "Download"
      (*ja
       (p
	(p "リリースパッケージはまだありません。CVSから匿名CVSで直接ダウンロードしてください。")
	(program "
cvs -d:pserver:anonymous@cvs.sourceforge.jp:/cvsroot/sumibi login
cvs -z3 -d:pserver:anonymous@cvs.sourceforge.jp:/cvsroot/sumibi co sumibi
")
	))))
    
    ,W:sf-logo
    ))


;; ページの出力
(output 'server-setup (L:body))
