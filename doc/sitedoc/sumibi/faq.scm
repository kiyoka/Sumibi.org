#!/usr/local/bin/gosh /usr/local/bin/sxmlcnv


(load "./common.scm")


(define (L:body)
  '(
    (*section
     "Sumibi.orgサイトについて"
     "about Sumibi.org site"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (p
       (subsection
	(@ (title 
	    "このサイトは何をするサイトですか？"))
        (p
         "『手ぶらで海外に行きたい、でも日本語でメールを送りたい』を実現するためのサイトです。")
	(p
	 (*link "Sumibi.org" "http://www.sumibi.org/")
	 "(炭火.org) は海外の日本語入力できないパソコンからでも、日本語でメールやブログを書いたりできる無料サイトです。")
	(p
	 "海外のインターネットカフェ等の日本語入力(IME)の入っていない英語版Windowsなどから簡単に日本語入力できます。"
	 "やっぱりお友達やご家族にはちゃんとした日本語でメールを出したいですよね。")
	(p
	 "また、すばやく日本語でGoogle検索ができるので、海外から日本語で調べものができます。"
	 "留学先の大学や、図書館の英語Windows等からでも、日本語でGoogle検索できます。"
	 "日本語での資料検索などにお役立て下さい。")
	(p
	 "Sumibi.orgサイトは海外からYahooやGoogleで『sumibi』と検索すると、このサイトが出てきます。"
	 "海外から日本語でメールを送りたい時はWebメールサービスに入っておく"
	 "と便利ですね。有名な無料Webメールサービスは"
	 (*link "Yahoo!メール" "http://mail.yahoo.co.jp/")
	 "、"
	 (*link "gooメール" "http://mail.goo.ne.jp/goomail/index.ghtml")
	 "等があります。自分に合ったものを選びましょう。"))
       (subsection
	(@ (title "無料ですか？"))
	(p "はい、無料です。海外に行くたびに無料の日本語変換サイトがあればいいなと思っていたので、作ってしまいました。")
	(p "[ソフトウェア技術者の方へ]")
	(p "SumibiはGPLライセンスを採用したオープンソースソフトウェアです。無保証、再配布ともに自由です。さらに、気にいったらご自分のサイトに組みこむことも可能です。")))))

    (*section
     "使い方について"
     "How to use"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (p
       (subsection
	(@ (title "平仮名を入力するには？"))
	(p "hiragana.h という風にローマ字で入力した単語に .h を付けます。")
	(p "なお、.h を付けなくても変換候補には平仮名の候補が必ず入っていますので、それを選択してください。"))

       (subsection
	(@ (title "カタカナを入力するには？"))
	(p "katakana.k という風にローマ字で入力した単語に .k を付けます。")
	(p "なお、.k を付けなくても変換候補にはカタカナの候補が必ず入っていますので、それを選択してください。"))

       (subsection
	(@ (title "アルファベットのまま入力するには？"))
	(p "sumibi.l という風にローマ字で入力した単語に .l を付けます。(または .e でも同じ意味になります)")
	(p "なお、.l を付けなくても変換候補にはアルファベットの候補が必ず入っていますので、それを選択してください。"))

       (subsection
	(@ (title "『7時』など、数字の後の単語が変換されません。『7ji』になります。"))
	(p "数字と単語の間にスペースを入力します。")
	(p "例) 7 ji kara 8 ji made , → 7時から8時まで、")
	))))

    (*section
     "セキュリティーについて"
     "about security"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (p
       (subsection
	(@ (title "Sumibi.orgとの通信路は安全ですか？"))
	(p "Sumibi.orgのSumibiWebAPIではGoDaddy社提供の商用SSL証明書を使っています。")
	(p "クライアントがSSL通信をサポートしており、対応するSSL証明書がインストールされていれば安全に通信できます。")
	(p "SSL証明書を利用しているかどうかはあなたがどのような形でSumibi.orgにアクセスしているかで変わります。")
	(ul
	 (li "Webブラウザから利用した場合")
	 (p "通信路の暗号化されていません。")
	 (p "理由は、Sumibi.orgのサーバーの負荷軽減です。ご了承ください。")
	 (p "基本的にWebブラウザからSumibi.orgを利用して入力された文章は、ブログやWebメールから送信されるものが中心だと思われますので、暗号化されていなくても問題ないと考えています。")
	 (li "SumibiWebAPIを直接利用した場合")
	 (p "SSLで暗号化されたSOAP通信が可能です。Sumibi.orgで公開しているSumibiWebAPIはSSLでアクセス可能です。")
	 (li "Emacsから利用した場合")
	 (p "sumibi.elには sumibi.orgに対応するSSL証明書が組み込まれています。")
	 (p "よって後は、変数 sumibi-server-url のスキームが https: になっており、且つ、変数 sumibi-server-use-cert が t になっていればSSL証明書を使った安全な通信が行なわれます。" )))
       (subsection
	(@ (title "sumibi.orgとの通信情報はどこへ行くのですか？"))
	(p "単純に捨てられ、記録には残りません。")
	(p "SumibiのクライアントはHTTPのPOSTメソッドで変換依頼を出しており、"
	   "それを受けたApache Webサーバーはリクエスト元の IPアドレス、ユーザーエージェント等"
	   "combined形式(標準ログ形式)でアクセスを記録しています。")
	(p "その中には、変換される文章等は含まれません。")))))
    

    (*section
     "Sumibiプロジェクトについて"
     "About Sumibi Project"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (p
       (subsection
	(@ (title "名前の由来は？"))
        (p
         (img (@ (src "sumibi_picture.png"))))
        (p "日本語由来で覚えやすく、他に使われていない言葉から選びました。")
	(p "『肉リリースには炭火』というキーワードにマッチするという点が決め手になりました。"
	   "後に、辞書を炭と呼び、辞書を育てるツールとして『炭焼き』と名づけました。ユーザーは炭焼き職人となり、自分で作った炭で文章を変換する(炭火を起こす)というイメージで全体の整合が取れたところも気にいっています。イメージと一緒に覚えてもらえると良いかなと思います。"))
       (subsection
	(@ (title "Sumibiの開発動機はなんですか？"))
	(p "沢山ありますが、既存の日本語入力メソッドに満足できなかったため開発をスタートしました。"
	   " SKK、yc.el( cannaクライアントです。)の二つをメインに使っていましたが、"
	   "どちらも一長一短あり、両方のいいところをそれぞれ取り込めばもっと良い"
	   "日本語入力システムが作れると考えたところから始まりました。")
	(p "SKKの良いところは、文節の区切りの認識ミスがない所です。(単文節変換なので当然ですが...)。"
	   "他にも、文節毎に送り仮名の開始位置を指定することで、手で直接書いているような小回りのきく操作感が得られるところが良いです。")
	(p "yc.elの良いところは、漢字変換モードを取り去ったところです。UNDO機能なども良く出来ています。")
	(p "この両方の特徴を同時に満たす方法は無いかと考えてたどりついたのが Sumibiです。"))
     
       (subsection
	(@ (title "なぜ変換エンジンも作ったのですか？"))
	(p "ひとりでに賢くなる変換エンジンが作成できるかどうか実証してみたかったというのが理由です。")
	(p "最近の日本語処理関連の書籍を読むと統計的アプローチの話題が沢山紹介されています。")
	(p "コンピューターのパワーが上がってきた今、そろそろパソコンのパワーでも実現できるのではないかと考えました。"))
	
       (subsection
	(@ (title "分かち書きのどこが良いのですか？"))
	(p "bunsetu de kugiru の様に分かち書きをすれば、文節の区切り間違いが入る余地が無くなります。"
	   "Sumibiでは、文節区切りは人間が指定したほうが、結果的に人間のストレスが減って使いやすいのではないかという考え方にもとづいています。")
	(p "MicrosoftのIMEや JustsystemのATOKなど有名な日本語入力システムは連文節変換方式を採用していますが、"
	   "文節の区切り間違いは完全には無くなりません。"
	   "また、文節の間違いを訂正する操作も煩雑でシンプルさを欠きます。")
	(p "そこで、Sumibiでは変換前に人間が文節区切りを分かち書きで指示し、間違いの入る余地をなくします。"
	   "結果的に、覚えるキー操作は減ります。")
	(p "その副産物として、Webブラウザからでも使える日本語入力システムとして発展しています。")
	)
       (subsection
	(@ (title "プロジェクトに貢献したいのですが、何か出来ることはありますか？"))
	(p "本サイト(Sumibi.org)は基本的にkiyoka(Sumibi作者)個人の資材で運用しています。運用のための資材等を提供頂けると大変助かります。"
	   "ご提供いただいた企業様におきましては、Sumibi.orgに優先して広告掲載させて頂きます。"
	   )
	(p "2006年6月現在、Sumibi Projectに機材などを御提供頂いている企業様は以下の通りです。本当にすばらしい企業様ばかりです。ありがとうございます。")
	(table
	 (thead
	  (tr
	   (td "企業名") (td "提供機材等")))
	 (tbody
	  (tr (td (*link "インフォテリア株式会社" "http://www.infoteria.com/jp/"))  (td "Sumibi.orgのホスティング用サーバーマシン( CPU:Athron64x2 RAM:4GByte )"))
	  (tr (td (*link "GoDaddy.com" "https://www.godaddy.com/gdshop/ssl/ssl_opensource.asp?se=%2B"))     (td "Turbo SSL Secure Certificate (sumibi.orgドメインのSSL証明書)")))))
       )))

    (*section
     "Sumibi.orgのWebサービス利用について"
     "About sumibi.org"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (p
       (subsection
	(@ (title "Sumibi.orgのSumibiWebAPIを呼び出すのに許可は要りますか？"))
	(p (*link "SumibiWebAPI" "http://www.sumibi.org/sumibi/sumibi_api_testing.html") " には技術的にも手続き的にも制限を設けていません。"
	   "御自由に呼び出してもらってかまいません。")
	(p "但し、その場合はできるかぎり"
	   (*link "メーリングリスト" "http://lists.sourceforge.jp/mailman/listinfo/sumibi-dev")
	   "に入って頂き、ノウハウ等の情報共有を行なって頂ければ幸いです。"))
       (subsection
	(@ (title "sumibi.orgのセキュリティーはどうなっているのですか？"))
	(p "最大限の努力を持って、セキュリティーを確保しています。"
	   "但し、何事にも100%はありませんので、完全に保証はできません。")
	(p "今後も最大限の監視体制でサーバー運用を行っていきます。"
	   "サーバー運用は大変な作業であり、もしsumibi.orgのホスティングを"
	   "行って頂ける方がいらっしゃればそちらに移らせて頂きたいと思っています。")
	(p "求む、サーバー管理者!"))

       (subsection
	(@ (title "Sumibi ServerのURL一覧はありますか？"))
	(p "変換サーバーのURL一覧です。")
	(table
	 (thead
	  (tr
	   (td "意味") (td "対応配布バージョン") (td "URL")))
	 (tbody
	  (tr
	   (td "安定板")
	   (td "Sumibi x.偶数.x")
	   (td "https://sumibi.org/cgi-bin/sumibi/stable/sumibi.cgi"))
	  (tr
	   (td "テスト版")
	   (td "Sumibi x.奇数.x")
	   (td "https://sumibi.org/cgi-bin/sumibi/testing/sumibi.cgi"))
	  (tr
	   (td "不安定版")
	   (td "Sumibi CVSバージョン")
	   (td "https://sumibi.org/cgi-bin/sumibi/unstable/sumibi.cgi")))))
       
       (subsection 
	(@ (title "なぜこんなに変換レスポンスが悪いのですか？"))
	(p "理由は二つあります。")
	(ol
	 (li "変換サーバー(Sumibi Server)がCGIで構築されている。")
	 (p "CGIなのでクライアントからのリクエストにリアルタイムで応答するほどの速度は期待できません。")
	 (li "チューニングが足りない。")
	 (p "もっと効率の良いアルゴリズム・データ構造にすることによってレスポンスが改善するかもしれません。"
	    "但し、今のところはシンプルさを優先し、チューニングは後回しの予定です。")))
       )))


    ,W:sf-logo
    ))


;; ページの出力
(output 'faq (L:body))
