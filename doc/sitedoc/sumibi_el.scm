#!/usr/local/bin/gosh /usr/local/bin/sxmlcnv


(load "./common.scm")


(define (L:body)
  '(body
    (center
     (a (@ (href "mailto:kiyoka@netfort.gr.jp"))
	"email: Kiyoka Nishiyama"))

    (*section
     "インストール"
     #f
     (*ja
      (ol
       (li "Emacsにapel-10.6以上をインストールします。")
       (li "sumibi.elをEmacsのロードパスにコピーします。")
       (li "CAcert.crtを適当な場所にコピーします。 (例: /home/xxxx/emacs ディレクトリーなど )")
       (li "wget 1.9.1以上をSSL機能を有効にしてビルドし、インストールします。")
       (p "(cygwinに入っているwgetがそのまま利用できることを確認しています。)")
       (li ".emacsに次のコードを追加します。")
       (program
	";; CAcert.crtの保存パス\n"
	"(setq sumibi-server-cert-file \"/home/xxxx/emacs/CAcert.crt\")\n"
	"(load \"sumibi.el\")\n"
	"(global-sumibi-mode 1)")
       (p 
	"※変数 sumibi-server-cert-file を nil にするとSSL証明書を利用しなくても通信できます。"
	"但し、この設定ではSumibi Serverとの通信の安全性が下がりますので、"
	"sumibi.orgで提供しているSumibi Serverを利用する場合は、証明書の使用をおすすめします。")
       (li "Emacsを再起動し、Emacsのメニューバーに \"Sumibi\"の文字が表示されれば成功です。"))))

    (*section 
     "キー操作"
     #f
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
	(li "候補選択に入る")
	(p "変換直後の文字列の上にカーソルを移動し、C-jキーを押すと候補選択モードに移行します。")
	(ul
	 (li "(入力例)")
	 (program
	  "炭火でおいしい焼肉を食べよう。[C-j]")
	 (li "(結果  )")
	 (program
	  "|炭火でおいしい焼肉を食べよう。|")))))

     (*subsection
      "変換のコツ"
      #f
      (ul
       (li "なるべく長い文章で変換する。")
       (p
	"Sumibiエンジンはなるべく長い文章を一括変換したほうが変換精度が上がります。\n"
	"理由は、Sumibiエンジンの仕組みにあります。\n"
	"Sumibiエンジンは文脈の中の単語の列びから、統計的にどの単語が相応しいかを選択します。\n")
       (li "SKKの辞書に含まれていそうな単語を指定する。")
       (p
	"SKKに慣れている人でないと感覚がつかめないかもしれませんが、\"変換精度\"のような多くの複合語\n"
	"は最初から辞書に含まれているので、\"henkanseido\"と言う具合に指定すると、確実に変換できます。\n"))))

    ,W:sf-logo
    ))


;; ページの出力
(output "sumibi.el ( Emacs client )" (L:body))


