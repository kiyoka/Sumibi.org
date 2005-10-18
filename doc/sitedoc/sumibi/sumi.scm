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
      (p "このドキュメントは『炭』(Sumibi辞書)のダウンロードとインストールについて解説したものです。")))

    (*section
     "炭とは"
     "About Sumi"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (ul
       (li "炭とは、Sumibi辞書のことです。")
       (li "Internet上にドキュメント群をコーパスとして利用してsumiyaki(炭焼き)というツールで構築しています。")
       (li "炭の作成には膨大な時間がかかるため、このページで配布しています。")
       (li "形式は、MySQLのmysqldumpイメージです。"))))

    (*section
     "ダウンロード"
     "Download"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (ul
       (li "Sumibiの初期状態辞書 (6.1M) " (*link "[sumi_bincho_1_starter.sql.gz]" "sumi_bincho_1_starter.sql.gz"))
       (p "SKKJISYO関連のみ読みこんだものです。")
       (li "small辞書")
       (ul
	(li "とりあえず版(商用利用不可) (33M) " (*link "[sumi_bincho_1_small_hisyouyou.sql.gz]" "sumi_bincho_1_small_hisyouyou.sql.gz")
	(p "Linux JF文書全てと、Wikipedia日本語版の一部を読みこんだ辞書です。"
	   "Linux JF文書を使った結果、商用利用ができません。")
	(p "商用利用のできる辞書を構築するため、Linux JFを使わない方向で辞書を作りなおすことを考えています。")
	
	(li "正式版(商用利用可能)" "[sumi_bincho_1_small.sql.gz]")
	(p "Wikipedia日本語版だけを読みこんだ辞書です。商用利用が可能です。")
	(p "2006年 1月ごろの完成予定です。")))
       (li "medium辞書")
       (p "僕の所有マシンの処理性能からすると 2006年3月から 6月くらいの完成予定です。"
	  "すごい性能のマシンをお持ちの方に手伝っていただけると、完成がもっと早まる可能性があります。"
	  "(もし、Athron64 +3000 メインメモリ2GByteのマシンを使えば今の約 1/10の時間で完了することがわかっていますが、
現在その強力なマシンはSumibi.orgの変換サーバー専用機として運用していますので、辞書構築に使うことはできません。)")

       (p
	"(Athron64 +3000 2GByte RAM) : (Celeron 1G 512MByte RAM) = 10 : 1")
       (li "large辞書, huge辞書")
       (p "medium辞書が完成次第、作成していく予定です。コンピューターの性能次第で完成時期が決まります。"))))

    (*section
     "インストール"
     "Install"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (p "インストール方法は gzipで圧縮を解いて、" (*link "SumibiServerSetup" "sumibi_server_setup.html")
	 "で示す方法でMySQLに流し込んで下さい。")))

    (*section
     "辞書の著作権・ライセンスについて"
     "About License"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (p
       (p "Sumibi用辞書データ sumi_bincho_1_* は以下のコンテンツ(素材)を利用して作成されています。")
       (ol
	(li "SKKJISYO関連")
	(p "この辞書群を加工してSKK-JISYO.sumbi_starterという辞書を作成し、それをsumiyakiツールで読みこんだ状態をSumibi辞書の初期状態としています。"
	   "SKK-JISYO.sumbi_starterを作成する手順については CVS上のdict/Makefile で自動化されています。")
	(table 
	 (thead
	  (tr  (td "辞書名") (td "ライセンス")))
	 (tbody
	  (tr   (td "SKK-JISYO.L")                (td "GPL"))
	  (tr   (td "SKK-JISYO.geo")              (td "GPL"))
	  (tr   (td "SKK-JISYO.jinmei")           (td "GPL"))
	  (tr   (td "SKK-JISYO.propernoun")       (td "GPL"))
	  (tr   (td "SKK-JISYO.station")          (td "GPL"))
	  (tr   (td "SKK-JISYO.zipcode")          (td "public domain"))
	  (tr   (td "SKK-JISYO.office.zipcode")   (td "public domain"))
	  ))

	(li "Linux JF文書")
	(p (*link "JF 文書の著作権・再配布・リンクについて" "http://www.linux.or.jp/JF/copyright.html") 
	   "を読む限り、ライセンスについては各文書に従う必要あります。一部商用利用の再配布に制限を掛けてある文書が含まれています。"
	   "これを含むSumibi辞書をダウンロードして使用する場合は、商用利用ができないことになります。")

	(p "※とりあえず版(商用利用不可) (33M) " (*link "[sumi_bincho_1_small_hisyouyou.sql.gz]" "sumi_bincho_1_small_hisyouyou.sql.gz") "では"
	   (*link "Linux JF文書のhtml版" "http://www.linux.or.jp/JF/JFdocs/JFhtml.tar.gz") "全てを読みこんでいます。")

	(li "Wikipedia日本語版")
	(p "ライセンスは、" ,W:GFDL "です。")
	(p (*link "Wikipedia:著作権情報" "http://ja.wikipedia.org/wiki/Wikipedia:%E8%91%97%E4%BD%9C%E6%A8%A9") "に解説が掲載されていますので、参照してください。")
	(p "上記のページには『ウィキペディアのコンテンツは、他の人々に対して同様の自由を認め、ウィキペディアがそのソースであることを
知らせる限りにおいて、複製、改変、再配布することができます。』と解説されています。")
	(p "つまり、Sumibi辞書がWikipedia日本語版を含んでいても、その旨を明記すれば再配布可能です。")))))

    ,W:sf-logo
    ))


;; ページの出力
(output 'sumi (L:body))
