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
       (li "Sumibiの初期状態辞書 (6.1M) [md5=de099411b35c77567d0dcecd559ad0cc]"
	   (*link "[sumi_bincho_1_starter.sql.gz]" "sumibi_dist/sumi_bincho_1_starter.sql.gz"))
       (p "SKKJISYO関連のみ読みこんだものです。")
       (li "small辞書")
       (ul
	(li "正式版(商用利用可能) (48M) [md5=ab558521f736a1e6911d79149ad5cc95]"
	    (*link "[sumi_bincho_1_small.sql.gz]" "sumibi_dist/sumi_bincho_1_small.sql.gz"))
	(p "Wikipedia日本語版だけを約10000ファイル読みこんだ辞書です。商用利用が可能です。")
	(p "長期間使ってみた感覚では、日常的な喋り言葉以外の用途に使うには十分な変換精度を持っていると思います。")
	(p "喋り言葉の変換精度を上げるためにはこのsmall辞書を起点にして『はてな』などの喋り言葉が多く含まれる"
	   "コンテンツを多く読み込む必要があります。"))
       (li "medium辞書")
       (ul
	(li "正式版(商用利用可能) (115M) [md5=3f45b3881f4ee4c2b1b318c7521d2eb7]"
	    (*link "[sumi_bincho_1_medium.sql.gz]" "sumibi_dist/sumi_bincho_1_medium.sql.gz"))
	(p "Wikipedia日本語版だけを約50000ファイル読みこんだ辞書です。商用利用が可能です。")
	(p "長期間使ってみた感覚では、smallよりもさらに、変換精度が上がっています。")
	(p "但しsmallと同じように喋り言葉の変換精度は高くありません。"))
       (li "large辞書, huge辞書")
       (p "順次、作成していく予定です。コンピューターの性能次第で完成時期が決まります。"))))

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
	(p "この辞書群を加工してSKK-JISYO.sumibi_starterという辞書を作成し、それをsumiyakiツールで読みこんだ状態をSumibi辞書の初期状態としています。"
	   "SKK-JISYO.sumibi_starterを作成する手順については CVS上のdict/Makefile で自動化されています。")
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
