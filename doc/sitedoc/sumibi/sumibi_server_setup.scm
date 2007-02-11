#!/usr/local/bin/gosh /usr/local/bin/sxmlcnv


(load "./common.scm")


(define (L:body)
  '(
    (*section
     "このドキュメントについて"
     "About this document"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (p
       (p "このドキュメントは" ,W:Sumibi.org "で提供しているような変換サービスをご自分のサイトにセットアップする方法を解説します。")
       (p "Sumibi Serverは 0.5.5以上のソースディストリビューションに含まれています。"))))

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
      "システム構成図"
      "Structure of Sumibi system"
      (*ja
       (p
	(p "Sumibiシステムは沢山のソフトウェアコンポーネントから構成されています。")
	(figure (@ (title "sumibi system diagram")
		   (src "sumibi_system_diagram")
		   (style "width:50%"))))))
     (*subsection
      "Sumibi Serverのセットアップに必要なソフトウェア"
      "Sumibi Server depends on these software"
      (*ja
       (p
	(p "下記は " ,W:Sumibi.org "サイト上で動作が確認されているバージョンです。(Debian sarge上で確認)")
	(p "※下記のバージョン以外の組合せでも動作するかも知れません")
	(table
	 (thead
	  (tr
	   (td "ソフトウェア名") (td "バージョン") (td "Debian sargeに含まれる")))
	 (tbody
	  (tr (td "Apache")            (td "1.3.x or 2.0.x")   (td "○"))
	  (tr (td "MySQL")             (td "4.1.x")            (td "○"))
	  (tr (td "Gauche")            (td "0.8.7 or later")   (td "×"))
	  (tr (td "Gauche-kakasi")     (td "0.1.0")            (td "×"))
	  (tr (td "Gauche-dbd-mysql" ) (td "0.2.2 or later")   (td "×"))
	  (tr (td "Perl")              (td "5.8.x or later")   (td "○"))
	  (tr (td "Perl SOAP::Lite")   (td "0.60 or later")    (td "○"))
	  (tr (td "Perl Jcode.pm")     (td "any version")      (td "○")))))))
     )

    (*section
     "入手方法"
     "How to get it"
     (*en
      (p "No documents in English, sorry..." ))
     (*subsection
      "Sumibi Serverのダウンロード方法"
      "How to Download"
      (*ja
       (p
	(p "リリースパッケージを以下のサイトからダウンロードしてください。(0.5.5以上)")
	(*link "download" "http://sourceforge.jp/projects/sumibi/")
	))))
    
    (*section
     "セットアップ"
     "How to Setup"
     (*en
      (p "No documents in English, sorry..." ))

     (*subsection
      "MySQLに辞書DBをリストアする"
      "Restore dictionary DB"
      (*ja
       (ol
	(li "sumibiエンジンからアクセスするためのアカウントを作成する")
	(p "※ 読みだし専用アカウントで構いません")
	(li "辞書DBを作成する")
	(p "例)")
	(program "echo 'create database sumi_bincho_1  DEFAULT CHARACTER SET utf8;' | mysql -u アドミンユーザー")
	(li "辞書DBをリストアする")
	(p "例)")
	(program "mysql -u アドミンユーザー  sumi_bincho_1 < 辞書DBイメージ"))))

     (*subsection
      "SumibiServerのデプロイ(設置)"
      "deploy the sumibi server"
      (*ja
       (p
	"以下の手順でSumibiWebAPI(SOAPプロトコル)でアクセス可能なSumibiサーバーを設置可能です。"
	(ol
	 (li "Sumibiのディストリビューションを展開し、make deployします")
	 (p "例)")
	 (program "
tar zxf sumibi-0.5.5.tar.gz
cd sumibi-0.5.5
make deploy
cd ..
ls -al
")
	 (li "その結果、次のファイルが生成されます。")
	 (table
	  (thead
	   (tr
	    (td "ファイル名") (td "役割")))
	  (tbody
	   (tr (td "sumibi")            (td "sumibiエンジン本体"))
	   (tr (td "sumibi.cgi")        (td "sumibiエンジンの入出力をSOAP 1.1プロトコルに変換するブリッジ"))
	   (tr (td "sumibi-0.5.5/lib")  (td "sumibiエンジンが使用するライブラリ"))))))))
      
     (*subsection
      "sumibi エンジンの設定ファイル .sumibi を用意する"
      "Prepare .sumibi file"
      (*ja
       (ol
	(li "Sumibiのディストリビューションに含まれる dot.sumibi.sample を deployした sumibi本体と同じディレクトリに .sumibi という名前で保存します。")
	(li ".sumibiのDB接続の為のパラメータを正しい値に変更します。")
	(program
"
;; sumiyaki db
(define sumibi-sumiyakidb-host       \"myhostname\")
(define sumibi-sumiyakidb-name       \"sumi_bincho_1\")
(define sumibi-sumiyakidb-user       \"username\")
(define sumibi-sumiyakidb-password   \"password\")

;; sumibi db
(define sumibi-sumibidb-host         \"myhostname\")
(define sumibi-sumibidb-name         \"sumi_bincho_1\")
(define sumibi-sumibidb-user         \"username\")
(define sumibi-sumibidb-password     \"password\")

;; debug flag
(set! sumibi-debug #f)
"
)))))

    ,W:sf-logo
    ))


;; ページの出力
(output 'server-setup (L:body))
