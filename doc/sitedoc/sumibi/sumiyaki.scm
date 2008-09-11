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
       (li "sumiyakiは 0.5.5以上のソースディストリビューションに含まれています。"))))

    (*section
     "sumiyakiとは"
     "About Sumi"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (ul
       (li "sumiyakiとは、Sumibi辞書構築ツールの名前です。")
       (li "Internet上の無数のドキュメント群をコーパスとして辞書構築するためのツールです。"))))

    (*section
     "入手方法"
     "How to get it"
     (*en
      (p "No documents in English, sorry..." ))
     (*subsection
      "sumiyakiツールのダウンロード方法"
      "How to Download"
      (*ja
       (p
	(p "リリースパッケージを以下のサイトからダウンロードしてください。(0.5.5以上)")
	(*link "download" "http://sourceforge.jp/projects/sumibi/")
	))))
    

    (*section
     "セットアップ"
     "How to setup"
     (*en
      (p "No documents in English, sorry..." ))
     (*subsection
      "sumiyakiのインストール"
      "install of sumiyaki"
      (*ja
       (p
	"以下の手順でsumiyakiツールをインストールします。"
	(ol
	 (li "Sumibiのディストリビューションを展開し、make installします")
	 (p "例)")
	 (program "
tar zxf sumibi-0.5.5.tar.gz
cd sumibi-0.5.5
make install
")))))
     
     (*subsection
      "sumibi エンジンの設定ファイル .sumibi を用意する"
      "Prepare .sumibi file"
      (*ja
       (ol
	(li "Sumibiのディストリビューションに含まれる dot.sumibi.sample を ~/.sumibi という名前で保存します。")
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

    (*section
     "sumiyakiコマンドの使いかた"
     "How to use sumiyaki"
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
       (li "コンテンツの読み込み・辞書学習")
       (program "sumiyaki -l プレーンテキストファイル")
       (ul
	(li "読み込むファイルはプレーンテキストのみです。")
	(p "※ htmlファイルなどは、w3m -dump コマンド等を使って全てプレーンテキストに変換してから読み込ませてください。")
	(li "文字コードは、sumiyakiコマンドが読みこみ時に自動的にUTF-8に変換するので、SJIS,EUC,UTF-8どれでもOKです。")
	(li "辞書学習処理の概要は以下の通りです。")
	(p "元の文章情報がそのまま辞書に蓄積される訳けではありません。")
	(p "読み込んだ文章に出現した隣接する語・1単語離れて隣接する語の共起頻度のカウントを行ないます。")
	(p "初めて出現したカタカナ語、ひらがな語、送り仮名のパターンも学習し辞書に登録されていきます。(これも出現頻度を記録します)"))
       (li "辞書のサマリー表示")
       (program "sumiyaki -s > logファイル"))))

    (*section
     "炭焼き作業の実際"
     "Practical sumiyaki"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (ul
       (li "テキストファイルの読み込みをする前の準備")
       (p "Sumibi辞書用MySQLデータベースの作成〜SKKJISYOの読込までを行った辞書データを" (*link "炭(Sumibi用辞書)" "sumi.html")
	  "のページで配布していますので、それを使えば準備段階の手間を省けます。")
       (li "複数のテキストファイルをsumiyakiで読み込む方法")
       (p "find を使って複数ファイルを順に読み込んでいきます。(以下はコマンド実行例です)")
       (program "find データディレクトリ名 -name '*.txt' -exec sumiyaki -l {} \; > log")
       (li "実際にWikipedia日本語版のプレーンテキストデータを読み込む方法")
       (program "find ./data -name '*.txt' -exec sumiyaki -l {} \; > log"))))

    (*section
     "Wikipedia日本語版をsumiyaki用プレーンテキストに変換する"
     "Creating Wikipedia data for sumiyaki"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (p
       (*subsection
	"プレーンテキストに変換済みのデータ"
	"Download generated data"
	(*en
	 (p "No documents in English, sorry..." ))
	(*ja
	 (ul
	  (li (*link "プレーンテキスト変換済みWikipedia日本語版 (166M) [md5=5199a7e92fdf2152951f43f94c2a77f0]" "sumibi_dist/wikipedia_ja_text.tar.gz")
	      "をダウンロードする")
	  (li "プレーンテキストに変換するのは面倒なのであらかじめ変換したデータを配布します。")
	  (li "このデータのライセンスはWikipedia日本語版のオリジナルのライセンスを加工したものなので、" ,W:GFDL "です。"))))
	 
       (*subsection
	"プレーンテキストに変換する手順(上記データをダウンロードする場合は以下の作業は不要です)"
	"How to convert"
	(*en
	 (p "No documents in English, sorry..." ))
	(*ja
	 (ul
	  (li "WikiepdiaのXMLアーカイブをダウンロードする")
	  (ul
	   (li (*link "XMLフォーマットのWikipedia日本語版 2005年7月13日のスナップショット (176M) [md5=b09538c3a1bf7b3d039d091993ae64ac]" "sumibi_dist/20050713_pages_current.xml.gz")
	       "をダウンロードする")
	   (li "このデータのライセンスは" ,W:GFDL "です。")
	   (li "Wikipedia本家のサイトでは最新のスナップショットしか置いていないため、"
	       "本サイトではコンバート処理の再現性を優先して上記の2005年7月13日のスナップショットを再配布しています。"))

	  (li "xmlからプレーンテキストデータを抽出するツール" (*link "xml2sql-0.2" "http://test.wikipedia.jp/Xml2sql") "をダウンロードしてビルドします。")
	  (ul
	   (p "作者のマシンで実験した限りでは、2005年7月13日版よりも新しいスナップショットでは、" (*link "xml2sql-0.2" "http://test.wikipedia.jp/Xml2sql")
	      "というバージョンではxmlフォーマットの読み込みに失敗しました。")
	   (p "特別な理由がない場合は、本サイトで配布しているアーカイブを使って下さい。"))
	  (li "xml2sqlでmysqlimport形式に変換する")
	  (program "
gunzip -c 20050713_pages_current.xml.gz | xml2sql
")
	  (p "※複数の.txt ファイルが生成されますが、このうちの text.txtだけを使用します。")
	  (li "次のperlスクリプトで./dataディレクトリに1行を1ファイルで出力する。(ついでに不要な記号も除去する)")
	  (program "
#!/usr/bin/perl

my( $no ) = 1;

foreach ( <> ) {
    s/\[\[//g;
    s/\]\]//g;
    s/<\/?[^>]+>//g;
    s/\\n/ /g;
    $line = $_;
    open( FP, sprintf( \">data/%07d.txt\", $no++ ));
    print FP $line;
    close FP;
}
")))))))

    ,W:sf-logo
    ))


;; ページの出力
(output 'sumiyaki (L:body))
