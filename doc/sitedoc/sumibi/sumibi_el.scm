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
      (p "このドキュメントは、sumibi.el 0.1.1についての解説です。")))

    (*section
     "sumibi.elの特徴"
     "features"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (ul
       (li "モードレス")
       (p "日本語入力モードという概念がありません。バッファに入力したローマ字文字列を直接漢字変換できます。")
       (p "もう日本語入力モードで英単語を入力してしまってイライラするということがありません。")
       (li "簡単インストール")
       (p "sumibi.elをパスの通った所に置き、ロードするだけで即使えます。")
       (p "(Sumibi Serverをwosumibi.orgで提供していますので、即動かすことができます。)")
       (li "シンプルなユーザーインターフェース")
       (p "なるべく少ないキーで操作できるように設計しています。短い時間で使えるはずです。"))))

    (*section
     "インストール"
     "How to install"
     (*en
      (p "No documents in English, sorry..." ))

     (*ja
      (ol
       (li "Emacsにapel-10.6以上をインストールします。")
       (li "sumibi.elをEmacsのロードパスにコピーします。")
       (li "CAcert.crtを適当な場所にコピーします。 (例: /home/xxxx/emacs ディレクトリーなど )")
       (li "curl 7.9.5以上をSSL機能を有効にしてビルドし、インストールします。")
       (p "以下のディストリビューションでは curlが標準でサポートされていることを確認しました。")
       (ul
	(li "Debian GNU/Linux 3.0")
	(li "Red Hat Enterprise 3.0")
	(li "cygwin ( 最新版 )"))
       (p "httpsプロキシーサーバーを使用するには以下の例のように環境変数を設定する必要があります。")
       (program
	"export http_proxy=http://your.proxy.server:8080/")
       (li ".emacsに次のコードを追加します。")
       (program
	";; CAcert.crtの保存パス\n"
	"(setq sumibi-server-cert-file \"/home/xxxx/emacs/CAcert.crt\")\n"
	"(load \"sumibi.el\")\n"
	"(global-sumibi-mode 1)")
       (p 
	"※変数 sumibi-server-cert-file を nil にするとSSL証明書を利用しなくても通信できます。"
	"但し、この設定ではSumibi Serverとの通信の安全性が低下しますので、"
	"sumibi.orgで提供しているSumibi Serverを利用する場合は、SSL証明書の使用をおすすめします。")
       (li "Emacsを再起動し、Emacsのモードラインに \"Sumibi\"の文字が表示されれば成功です。")
       (p
	(img (@ (src "modeline.png")))))))


    (*section 
     "キー操作"
     "Key bindings"

     (*en
      (p "No documents in English, sorry..." ))

     (*subsection
      "変換"
      #f
      (*ja
       (ol
	(li "基本的な使いかた")
	(p "Emacsのモードラインに\"Sumibi\"の文字が出ていれば C-jキーでいきなり変換できます。")
	(ul
	 (li "(入力例)")
	 (program
	  "sumibi de oishii yakiniku wo tabeyou . [C-j]")
	 (li "(結果  )")
	 (program
	  "炭火でおいしい焼肉を食べよう。"))
	(li "'/' 記号で変換範囲を限定する。")
	(ul
	 (li "(入力例)")
	 (program
	  "sumibi de oishii /yakiniku wo tabeyou . [C-j]")
	 (li "(結果  )")
	 (program
	  "sumibi de oishii 焼肉を食べよう。"))
	(li ".h と .k メソッドでひらがな・カタカナに固定する。")
	(ul
	 (li "(入力例)")
	 (program
	  "sumibi.h de oishii.k yakiniku wo tabeyou . [C-j]")
	 (li "(結果  )")
	 (program
	  "すみびでオイシイ焼肉を食べよう。")))))

     (*subsection 
      "候補選択"
      #f
      (*ja
       (ol
	(li "とにかく候補選択を開始するには")
	(ul
	 (li "カーソルが文末にある状態で[C-j]を押す。")
	 (p
	  (img (@ (src "before_select1.png"))))
	 (li "C-jを押すと、候補選択モードに移行します。")
	 (p
	  (img (@ (src "select1.png")))))
	(li "候補選択したい箇所から候補選択を開始するには")
	(ul
	 (li "候補選択したい部分にカーソルを合わせて[C-j]を押す。")
	 (p
	  (img (@ (src "before_select2.png"))))
	 (li "候補選択モードに移行します。")
	 (p
	  (img (@ (src "select2.png")))))
	(li "候補の順送り")
	(ul
	 (li "[C-j]で次の変換候補が順番に出てきます。")
	 (p
	  (img (@ (src "select3.png")))))

	(li "候補選択キー操作一覧")
	(table 
	 (thead
	  (tr  (td "キー操作") (td "アクション")))
	 (tbody
	  (tr   (td "C-m")   (td "候補選択確定"))
	  (tr   (td "C-g")   (td "候補選択キャンセル"))
	  (tr   (td "C-b")   (td "前方の文節に移動"))
	  (tr   (td "C-f")   (td "後方の文節に移動"))
	  (tr   (td "C-a")   (td "最初の文節に移動"))
	  (tr   (td "C-e")   (td "最後の文節に移動"))
	  (tr   (td "C-j")   (td "次の候補に切りかえる"))
	  (tr   (td "space") (td "次の候補に切りかえる"))
	  (tr   (td "C-n")   (td "次の候補に切りかえる"))
	  (tr   (td "C-p")   (td "前の候補に切りかえる")))))))
	 

     (*subsection
      "変換のコツ"
      #f
      (*ja
       (ul
	(li "なるべく長い文章で変換する。")
	(p
	 "Sumibiエンジンはなるべく長い文章を一括変換したほうが変換精度が上がります。\n"
	 "理由は、Sumibiエンジンの仕組みにあります。\n"
	 "Sumibiエンジンは文脈中の単語の列びから、統計的にどの単語が相応しいかを判断します。\n")
	(li "SKKの辞書に含まれていそうな単語を指定する。")
	(p
	 "SKKに慣れている人でないと感覚がつかめないかもしれませんが、\"変換精度\"のような多くの複合語\n"
	 "は最初から辞書に登録されているので、\"henkanseido\"と言う風に指定すると、確実に変換できます。\n")))))

    ,W:sf-logo
    ))


;; ページの出力
(output 'el (L:body))


