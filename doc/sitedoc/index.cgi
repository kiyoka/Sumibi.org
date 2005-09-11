#!/usr/local/bin/gosh
;;
;; Sumibi.org's top page
;;
(use www.cgi)
(use text.tree)
(use text.html-lite)


(define (main args)                                                      
  (cgi-main                                                              
   (lambda (params)                                                     
     `(,(cgi-header)                                                    
       ,(html-doctype)                                                  
       ,(html:html                                                      
	 (html:head
	  (html:meta :http-equiv "Content-Type"        :content "text/html; charset=utf-8")
	  (html:meta :http-equiv "Content-Script-Type" :content "text/javascript")
	  (html:meta :http-equiv "Content-Style-Type"  :content "text/css")
	  (html:link :rel "stylesheet" :href "sumibi.css" :type"text/css")
	  (html:title "Sumibi.org ローマ字を日本語に変換できる無料サイト")
	  (html:link :rel "shortcut icon" :href "/favicon.ico")
	  (html:link :rel "icon" :href "/favicon.png" :type "image/png"))
	 (html:body                                                     
	  (html:div :style "text-align: center; "
		    (html:br)
		    (html:span :style "color:#6d5550;"
			       "世界の果てから漢字変換")
		    
		    (html:br)
		    (html:img :src "sumibi_org_logo.png" :alt "Sumibi.org LOGO")
		    (html:br)

		    (html:span :style "color:#6d5550;"
			       "Sumibi.orgはローマ字を日本語に変換できる、今すぐ使える無料サイトです。"
			       (html:br)
			       "Sumibi.org ha ro-maji wo nihongo ni henkan suru muryou saito desu . From romaji to kanji .")
		    (html:br)
		    (if (cgi-get-parameter "long" params)
			(html:a :href "http://www.sumibi.org/"     "Google検索モード(暗号化OFF)")
			(html:a :href "https://sumibi.org/?long=1" "長文作成モード(暗号化ON)"))
		    " / "
		    (html:a :href "sumibi/sumibi.html"  "Documents")
		    " / "
		    (html:a :href "sumibi/faq.html"     "FAQ"))
		    
	  (html:div :style "text-align: center; "
		    (html:form :method "get" :action "http://www.google.co.jp/custom" :target "_top"
			       (html:input :type "hidden" :id "server" :name "server" :value "testing"  :onClick "select_server(this.value)")
			       (if (cgi-get-parameter "long" params)
				   (html:div :style "text-align: center; "
					     (html:p "長文作成モード")
					     (html:textarea :id "q" :name "q" :cols "60" :rows "5"))
				   (html:div
				    (html:p
				     (html:a :href "http://www.google.com/"
					     (html:img :src "http://www.google.com/logos/Logo_25wht.gif" :border "0" :alt "Google" :align "middle"))
				     (html:input :type "text" :id "q" :name "q" :size "41" :maxlength "2048")
				     (html:input :type "submit" :name "sa" :value "検索"))))
			       (html:input :type "hidden" :name "client" :value "pub-5721837636688174")
			       (html:input :type "hidden" :name "forid"  :value "1")
			       (html:input :type "hidden" :name "ie"     :value "UTF-8")
			       (html:input :type "hidden" :name "oe"     :value "UTF-8")
			       (html:input :type "hidden" :name "cof"    :value "GALT:#008000;GL:1;DIV:#336699;VLC:663399;AH:center;BGC:FFFFFF;LBGC:336699;ALC:0000FF;LC:0000FF;T:000000;GFNT:0000FF;GIMP:0000FF;LH:25;LW:80;L:http://www.sumibi.org/sumibi_org_logo.png;S:http://www.sumibi.org/;LP:1;FORID:1;")
			       (html:input :type "hidden" :name "hl"     :value "ja"))
		    
		    (html:div :id "progress")
		    (html:div :id "ime")
		    (html:div :id "hist"))
	  
	  (html:ul
	   (html:li "単語をスペースで区切って入力します。 (例: ryokou ni kiteimasu . → 旅行に来ています。)")
	   (html:li "句読点 、。はスペースの後に , . を入力します。(例: arigatou . → ありがとう。) ")
	   (html:li "スペースは、スペースを二回入力して下さい。 (例: wa-kinguhoride-&nbsp;&nbsp;&nbsp;o-sutoraria → ワーキングホリデー&nbsp;&nbsp;オーストラリア)"))

	  (html:div :style "text-align: right; "
		    (html:a :href "mailto:kiyoka@sumibi.org" "メールでのお問い合わせ(ローマ字でもOKです)"
			    (html:img :alt "MailTo" :border "0" :src "sumibi_mailto.gif"))
		    (html:br)
		    (html:span :style "color:#6d5550;"
			       "Sumibi.org provides roman to japanese conversion system and other services."))
	  (html:div :class "copyright"
		    "Sumibi Engine:Copyright&copy 2005, Kiyoka / Sumibi Ajax:Copyright&copy 2005, Ktat"
		    (html:br)
		    "Software version = $Date: 2005/09/11 15:11:01 $ ")


	  ;;; --- 海外旅行者のための解説文章 ---
	  (if (cgi-get-parameter "long" params)
	      (html:p "")
	      (html:div
	       (html:h1 "海外旅行者の強い味方 Sumibi.org")
		  
	       (html:h3 "手ぶらで海外に行きたい、でもメールも送りたい")
	       (html:p
		"Sumibi.org (炭火.org) は海外のインターネットカフェや海外ホテルのビジネスセンターなどから"
		"日本語でメールを書いたりブログを書いたりできるサイトです。")
	       (html:p
		"日本語入力(IME)の入っていない英語版Windowsからでも日本語入力できます。")
	       (html:p
		"このページからGoogle検索ができ、メール等長文を書く場合は『"
		(html:a :href "https://sumibi.org/?long=1" "長文作成モード(暗号化ON)")
		"』ページが便利です。")
		  
	       ;;	  (html:p
	       ;;	   "海外のホテルにはビジネスセンターという施設があり、Internet接続されたPCが置いてあります。(料金の相場は30分 5ドルから10ドル程度です。)")
	       ;;	  (html:p
	       ;;	   "また、ライブラリ(共有書庫)にも無料でInternetが利用できるPCを開放しているホテルもあります。(『バリ島のマヤ ウブド』が無料でした。)")
	       ;;	  (html:p
	       ;;	   "世界的にブログが流行している現在、無料PCをホテルのライブラリ(共有書庫)に置くようになってきています。")
		  
	       ;;	  (html:p
	       ;;	   "でも、そのほとんどは日本語入力IMEがインストールされておらず、困ることが多いでしょう。"
	       ;;	   "そういう時にSumibiが大活躍します。")
		  
		  
	       (html:h3 "『手ぶらで海外』を実践する方法")
	       ;;	  (html:ol
	       ;;	   (html:li "あなたの行く予定のホテルにPCが有るか、料金はいくらか聞いておきます。")
	       ;;	   (html:p "( ついでに、日本語が表示できるかどうか確認しておくと良いでしょう。)")
	       ;;	   (html:li "『sumibi.org』という言葉を覚えておきます。")
	       (html:p "海外からgoogle で 『sumibi.org』を検索するとこのサイトが最初に出てきます。")
		  
	       (html:h3 "海外から日本語でメールを送りたい時")
	       (html:p "海外に行く前にWebメールサービスに入っておきます。")
	       (html:p "goo Mailや、Yahoo Mail、 Hotmail等が有名な無料Webメールサービスです。"
		       "自分に合ったものを選びましょう。")))
	  
	  (html:hr)

	  ;;; --- FLOSS関連ロゴ ---
	  (html:a :href "http://www.godaddy.com/gdshop/ssl/ssl_opensource.asp"
		  (html:img :src "http://imagesak.godaddy.com/assets/ssl/img_cert_turbo_gd.jpg" :border "0" :alt "SourceForge.jp"))

	  (html:a :href "http://sourceforge.jp/"
		  (html:img :src "http://sourceforge.jp/sflogo.php?group_id=1476" :width="96" :height "31" :border "0" :alt "SourceForge.jp"))

	  (html:a :href "http://creativecommons.org/licenses/GPL/2.0/"
		  (html:img :alt "CC-GNU GPL" :border "0" :src "http://creativecommons.org/images/public/cc-GPL-a.png"))

	  (html:br)
	  "This software is licensed under the "
	  (html:a :href "http://creativecommons.org/licenses/GPL/2.0/"
		  "CC-GNU GPL")

"  
  <!--

  <rdf:RDF xmlns=\"http://web.resource.org/cc/\"
     xmlns:dc=\"http://purl.org/dc/elements/1.1/\"
     xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\">
  <Work rdf:about=\"\">
     <license rdf:resource=\"http://creativecommons.org/licenses/GPL/2.0/\" />
     <dc:type rdf:resource=\"http://purl.org/dc/dcmitype/Software\" />
  </Work>

  <License rdf:about=\"http://creativecommons.org/licenses/GPL/2.0/\">
     <permits rdf:resource=\"http://web.resource.org/cc/Reproduction\" />
     <permits rdf:resource=\"http://web.resource.org/cc/Distribution\" />
     <requires rdf:resource=\"http://web.resource.org/cc/Notice\" />
     <permits rdf:resource=\"http://web.resource.org/cc/DerivativeWorks\" />
     <requires rdf:resource=\"http://web.resource.org/cc/ShareAlike\" />
     <requires rdf:resource=\"http://web.resource.org/cc/SourceCode\" />
  </License>

  </rdf:RDF>

  -->
"


	  )
	 (html:script :type "text/javascript" :src "ajax/Sumibi.js")
	 (html:script :type "text/javascript" :src "ajax/SumibiSOAP.js")
	 (html:script :type "text/javascript" :src "ajax/ajax_sumibi.js")

	 )))))


