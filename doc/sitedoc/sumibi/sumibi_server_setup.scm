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
       (p "Sumibi ServerはCVSリポジトリにしか存在しません。セットアップは若干煩雑なのですが、御了承ください。")
       (p "注意!! : まだSumibiの辞書データを公開していません。しばらくお待ち下さい。"))))

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
	(p "下記はSumibi.orgサイト上で動作が確認されているバージョンです。(Debian sarge上で確認)")
	(p "※下記のバージョン以外の組合せでも動作するかも知れません")
	(table
	 (thead
	  (tr
	   (td "ソフトウェア名") (td "バージョン") (td "Debian sargeに含まれる")))
	 (tbody
	  (tr (td "Apache")            (td "1.3.x or 2.0.x")   (td "○"))
	  (tr (td "MySQL")             (td "4.1.x")            (td "○"))
	  (tr (td "Gauche")            (td "0.8.3 or later")   (td "○"))
	  (tr (td "Gauche-kakasi")     (td "0.1.0")            (td "×"))
	  (tr (td "Gauche-dbi" )       (td "0.1.4")            (td "×"))
	  (tr (td "Gauche-dbd-mysql" ) (td "0.1.4")            (td "×"))
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
	(p "リリースパッケージはまだありません。CVSから匿名CVSで直接ダウンロードしてください。")
	(program "
cvs -d:pserver:anonymous@cvs.sourceforge.jp:/cvsroot/sumibi login
cvs -z3 -d:pserver:anonymous@cvs.sourceforge.jp:/cvsroot/sumibi co sumibi
")
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
	(program "
mysqladmin -u アドミンユーザー  create sumi_bincho_1")
	(li "辞書DBをリストアする")
	(p "例)")
	(program "
mysql -u アドミンユーザー  sumi_bincho_1 < 辞書DBイメージ"))))

     (*subsection
      "sumibiエンジンのライブラリインストール"
      "Install the library files for sumibi engine"
      (*ja
       (ol
	(li "CVSの sumibi/lib 以下を Gaucheのライブラリパスにコピーしてください。")
	(p "例)")
	(program "
mkdir -p /usr/share/gauche/site/lib/sumibi/
/bin/cp sumibi/lib/* /usr/share/gauche/site/lib/sumibi/ "))))

     (*subsection
      "cgi関連のインストール"
      "install the cgi"
      (*ja
       (p
	(p "インストールすべきファイルは以下のものです。")
	(table
	 (thead
	  (tr
	   (td "CVS中のファイル") (td "コピー後の名前") (td "役割")))
	 (tbody
	  (tr (td "sumibi")              (td "sumibi")         (td "sumibiエンジン本体"))
	  (tr (td "dot.sumibi.sample")   (td ".sumibi")        (td "sumibiエンジン用設定ファイル"))
	  (tr (td "sumibi.cgi")          (td "sumibi.cgi")     (td "sumibiエンジンの入出力をSOAP 1.1プロトコルに変換するブリッジ")))))))

     (*subsection
      "sumibi と sumibi.cgi のインストール"
      "install the sumibi and sumibi.cgi"
      (*ja
       (ol
	(li "CVSの sumibi/sumibi と sumibi/server/sumibi.cgi を Apacheのcgi実行ディレクトリにコピーします。"))))

     (*subsection
      "sumibi エンジンの設定ファイル .sumibi を用意する"
      "Prepare .sumibi file"
      (*ja
       (ol
	(li "CVSの dot.sumibi.sample を cgi-binディレクトリに .sumibi という名前で保存します。")
	(li ".sumibiのDB接続の為のパラメータを正しい値に変更します。")
	(p "※ sumiyakidbの方は、得に設定の必要はありません。(こちらの設定は、辞書を鍛えるツールsumiyaki用です)")
	(program
"
;; sumiyaki db
(define sumibi-sumiyakidb-name       \"host=localhost;db=sumi_bincho_1\")
(define sumibi-sumiyakidb-user       \"username\")
(define sumibi-sumiyakidb-password   \"password\")

;; sumibi db
(define sumibi-sumibidb-name         \"host=localhost;db=sumi_bincho_1\")
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
