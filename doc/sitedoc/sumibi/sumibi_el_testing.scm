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
      (p "このドキュメントは、sumibi.el 0.3.2についての解説です。")))

    (*section
     "sumibi.elの特徴"
     "features"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (ul
       (li "簡単インストール")
       (p "sumibi.elをロードするだけで即使えます。")
       (p "(変換サーバーはsumibi.orgで提供しています。自分で変換サーバーを用意しなくても使い始めることができます。)")
       (li "モードレス")
       (p "日本語入力モードという概念がありません。Emacsバッファに入力したローマ字文字列を直接、漢字変換できます。")
       (p "もう日本語/英単の切り替えでイライラするということがありません。")
       (li "シンプルなユーザーインターフェース")
       (p "なるべく少ないキーで操作できるように設計しています。短い時間で覚えることができます。"))))

    (*section
     "インストール"
     "How to install"
     (*en
      (p "No documents in English, sorry..." ))

     (*ja
      (ol
       (li "sumibi.elをEmacsのロードパスにコピーします。")
       (p "Emacsのロードパスを調べるには、Emacs 起動後、 M-x describe-variable で変数説明コマンドを実行し、"
	  "変数 load-path を指定して内容を調べてください。")
       (li "curl をインストールします。")
       (p "ほとんどのディストリビューションで curl コマンドがサポートされています。")
       (p "以下のディストリビューションでは curlが標準でサポートされていることを確認しました。")
       (ul
	(li "Debian GNU/Linux 3.0 及び 3.1")
	(li "Red Hat Enterprise 3.0 及び 4.0")
	(li "Cygwin ( 最新版 )"))
       (p "httpsプロキシーサーバーを使用するには以下の例のように環境変数を設定する必要があります。")
       (program
	"export http_proxy=http://your.proxy.server:8080/\n"
	"export https_proxy=http://your.proxy.server:8080/")
       (li ".emacsに次のコードを追加します。")
       (program
	"(load \"sumibi\")\n")
       (p 
	"※変数 sumibi-server-use-cert を nil にするとSSL証明書を利用しなくても通信できます。"
	"但し、この設定ではSumibi Serverとの通信の安全性が低下しますので、"
	"sumibi.orgで提供しているSumibi Serverを利用する場合は、SSL証明書を利用する事をお勧めします。")
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
	(li "文章の途中から候補選択を開始するには")
	(ul
	 (li "候補選択したい文節にカーソルを合わせて[C-j]を押す。")
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
	  (tr  (td "第一のキー操作") (td "第二のキー操作") (td "アクション")))
	 (tbody
	  (tr   (td "C-m")   (td "")      (td "候補選択確定"))
	  (tr   (td "C-g")   (td "q")     (td "候補選択キャンセル"))
	  (tr   (td "C-b")   (td "b")     (td "前方の文節に移動"))
	  (tr   (td "C-f")   (td "f")     (td "後方の文節に移動"))
	  (tr   (td "C-a")   (td "a")     (td "最初の文節に移動"))
	  (tr   (td "C-e")   (td "e")     (td "最後の文節に移動"))
	  (tr   (td "C-j")   (td "space") (td "次の候補に切りかえる"))
	  (tr   (td "C-n")   (td "n")     (td "次の候補に切りかえる"))
	  (tr   (td "C-p")   (td "p")     (td "前の候補に切りかえる"))
	  (tr   (td "")      (td "j")     (td "漢字の第一候補に切りかえる"))
	  )))))
	 

     (*subsection
      "変換のコツ"
      #f
      (*ja
       (ul
	(li "なるべく長い文章で変換する。")
	(p
	 "Sumibiエンジンはなるべく長い文章を一括変換したほうが変換精度が上がります。\n"
	 "理由は、Sumibiエンジンの仕組みにあります。\n"
	 "Sumibiエンジンは文脈から統計的にどの単語が相応しいかを判断します。\n")
	(li "SKKの辞書に含まれていそうな単語を指定する。")
	(p
	 "SKKに慣れている人でないと感覚がつかめないかもしれませんが、\"変換精度\"のような多くの複合語\n"
	 "は最初から辞書に登録されているので、\"henkanseido\"という風に指定すると、確実に変換できます。\n")))))

    (*section
     "対応環境"
     "Environment"
     (*en
      (p "No documents in English, sorry..." ))

     (*ja
      (ul
       (p "多くの環境で動くはずです。以下の環境で動作確認済みです。")
       (li "Emacs環境")
       (ul
	(li "Emacs 21.x以上")
	(li "XEmacs 21.x以上")
	(li "Meadow 2.00 + Cygwin最新版")
	(li "apel 10.3以上")
	(li "curl 7.9.5以上"))
       (li "ディストリビューション")
       (ul
	(li "Debian GNU/Linux 3.0/3.1")
	(li "RedHat Enterprise 3.0/4.0")
	(li "Cygwin最新版")))))

    (*section
     "カスタマイズ"
     "How to customize"
     (*en
      (p "No documents in English, sorry..." ))

     (*ja
      (ul
       (li "M-x customize-group を実行してグループに 'sumibi' を指定すればカスタマイズ画面が表示されます。")
       (li "sumibi.elには以下のカスタマイズ項目があります。")
       (ol
	(li "sumibi-server-url")
	(p "変換サーバーのURLを指定します。デフォルトでは sumibi.org の変換サーバーを使うようになっていますので"
	   "変更しなくても使えます。")
	(p "自前の変換サーバーを利用する場合はこの設定を自前サーバーのURLに変更してください。")
	(li "sumibi-server-cert-data")
	(p "sumibi.org 用のSSL証明書データです。")
	(li "sumibi-server-use-cert")
	(p "SSL証明書を[利用する/しない]を指定します。( t か nil で指定します。)")
	(li "sumibi-server-timeout")
	(p "変換サーバーとの通信タイムアウト秒数を指定します。")
	(li "sumibi-stop-chars")
	(p "C-j キーでローマ字を変換する時、変換文章の停止文字を指定します。\n"
	   "sumibi.elは C-j キーを押されるとカーソル位置から前方方向に sumibi-stop-chars で定義された停止文字にマッチするまでを捜査し、変換対象とします。")
	(li "sumibi-curl")
	(p "curlコマンドの絶対パスを指定します。通常は変更する必要はありません。")))))

    ,W:sf-logo
    ))


;; ページの出力
(output 'el-testing (L:body))


