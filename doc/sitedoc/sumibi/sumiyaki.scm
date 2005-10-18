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
      (ul
       (li "このドキュメントは『sumiyaki』(Sumibi辞書構築ツール)についての解説です。")
       (li "sumiyakiはCVSリポジトリにしか存在しません。セットアップは若干煩雑なのですが御了承ください。"))))

    (*section
     "sumiyakiとは"
     "About Sumi"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (ul
       (li "sumiyakiとは、Sumibi辞書のことです。")
       (li "Internet上にドキュメント群をコーパスとして辞書構築します。"))))

    (*section
     "入手方法・セットアップ"
     "How to setup"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (ul
       (li "ツールのインストール方法については、" (*link "SumibiServerSetup" "sumibi_server_setup.html")
	   "で示す方法でライブラリ群をインストールしてください。")
       (li "その後、sumiyakiというスクリプトをパスの通った場所にコピーしてください。")
       (li "※ sumiyaki も sumibiと共通の設定ファイル ~/.sumibi で接続するデータベースサーバを指定します。"))))

    (*section
     "sumiyakiコマンドの使いかた"
     "How to execute"
     (*en
      (p "No documents in English, sorry..." ))
     (*subsection
      "データベースの作成"
      "Creating database"
      (*en
       (p "No documents in English, sorry..." ))
      (*ja
       (ul
	(li "MySQLデータベースの作成")
	(program "echo 'create database sumi_bincho_1  DEFAULT CHARACTER SET utf8;' | mysql -u アドミンユーザー")
	(li "テーブルの初期化")
	(program "sumiyaki -c")
	(li "SKK形式辞書の読み込み")
	(program "sumiyaki -i SKK辞書データ")
	(li "コンテンツの読み込み")
	(ul
	 (li "読みこむファイルはプレーンテキストのみです。")
	 (li "文字コードは、内部で自動的にUTF-8に変換するので、SJIS,EUC,UTF-8のいづれでもOKです。")
	 (li "※ htmlファイルなどは、w3m -dump コマンド等で全てプレーンテキストに変換してから読み込ませてください。"))
	(program "sumiyaki -l プレーンテキストファイル")
	(li "辞書のサマリー表示")
	(program "sumiyaki -s > logファイル")))))

    (*section
     "炭焼き作業の実際"
     "Practical sumiyaki"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (ul
       (li "複数のテキストファイルをsumiyakiで読みこむ方法")
       (p "find を使って複数ファイルを順に読みこんでいきます。")
       (program "
find データディレクトリ -name '*.txt' -exec sumiyaki -l {} \; > log")
       (li ""))))

    ,W:sf-logo
    ))


;; ページの出力
(output 'sumiyaki (L:body))
