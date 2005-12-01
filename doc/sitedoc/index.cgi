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
     (let ((long-mode     (cgi-get-parameter "long" params))
	   (darkside-mode (cgi-get-parameter "darkside" params)))
       `(,(cgi-header)                                                    
	 ,(html-doctype)                                                  
	 ,(html:html                                                      
	   (html:head
	    (html:meta :http-equiv "Content-Type"        :content "text/html; charset=utf-8")
	    (html:meta :http-equiv "Content-Script-Type" :content "text/javascript")
	    (html:meta :http-equiv "Content-Style-Type"  :content "text/css")
	    (html:meta :name "description"               :content
		       (string-append "海外の英語版PCからでもスイスイ日本語入力できる無料サイトです。インストール不要。日本語でGoogle検索もできます。"
				      "Sumibi.org provides roman to japanese conversion system and other services."))
	    (html:meta :name "keywords"                  :content
		       "ローマ字,日本語,Google検索,Ajax,海外,留学,オープンソース,漢字変換,海外旅行,ワーキングホリデー")
	    (html:link :rel "stylesheet" :href "sumibi.css" :type "text/css")
	    (html:title "Sumibi.org ローマ字を日本語に変換できる無料サイト")
	    (html:link :rel "shortcut icon" :href "/favicon.ico")
	    (html:link :rel "icon" :href "/favicon.png" :type "image/png"))
	   (html:body
	    :onLoad "setFocusToQ()"
	    (html:div :style "text-align: center; "
		      (html:br)
		      (html:img :src "xmas-17.gif" :border "0" :alt "xmas_image_L")
		      (html:span :class "subtitle"
				 "世界の果てから漢字変換")
		      (html:img :src "xmas-19.gif" :border "0" :alt "xmas_image_R")
		      (html:br)
		      (html:img :src "sumibi_org_logo.png" :alt "Sumibi.org LOGO")
		      (html:br)

		      (html:span :class "subtitle"
				 "Sumibi.orgはローマ字を日本語に変換できる、今すぐ使える無料サイトです。"
				 (html:br)
				 "Sumibi.org ha ro-maji wo nihongo ni henkan suru muryou saito desu. From romaji to kanji.")
		      (html:br)
		      (if long-mode
			  (html:a :href "http://www.sumibi.org/"     "Google検索モード(暗号化OFF)")
			  (html:a :href "https://sumibi.org/?long=1" "長文作成モード(暗号化ON)"))
		      " / "
		      (html:a :href "sumibi/sumibi.html"         "Documents")
		      " / "
		      (html:a :href "sumibi/privacy_policy.html" "Privacy Policy")
		      " / "
		      (html:a :href "sumibi/faq.html"            "FAQ"))
		    
	    (html:div :style "text-align: center; "
		      (html:form :id "gform" :method "get" :action "http://www.google.co.jp/custom" :target "_top"
				 (html:input :type "hidden" :id "server" :name "server" :value "testing"  :onClick "select_server(this.value)")
				 (if long-mode
				     (html:div
				      (html:div :style "text-align: center; "
						(html:p "[長文作成モード]")
						(html:textarea :id "q" :name "q" :cols "60" :rows "5")
						))
				     (html:div
				      (html:p
				       (html:a :href "http://www.google.com/"
					       (html:img :src "http://www.google.com/logos/Logo_25wht.gif" :border "0" :alt "Google" :align "middle"))
				       (html:input :type "text" :id "q" :name "q" :size "41" :maxlength "2048")
				       (html:input :type "submit" :name "sa" :value "Google検索"))))
				 (html:input :type "hidden" :name "client" :value "pub-5721837636688174")
				 (html:input :type "hidden" :name "forid"  :value "1")
				 (html:input :type "hidden" :name "ie"     :value "UTF-8")
				 (html:input :type "hidden" :name "oe"     :value "UTF-8")
				 (html:input :type "hidden" :name "cof"    :value "GALT:#008000;GL:1;DIV:#336699;VLC:663399;AH:center;BGC:FFFFFF;LBGC:336699;ALC:0000FF;LC:0000FF;T:000000;GFNT:0000FF;GIMP:0000FF;LH:25;LW:80;L:http://www.sumibi.org/sumibi_org_logo.png;S:http://www.sumibi.org/;LP:1;FORID:1;")
				 (html:input :type "hidden" :name "hl"     :value "ja"))
		    
		      (html:div :id "progress")
		      (html:div :id "ime")
		      (html:div :id "hist"))
	  
	    (html:div :style "text-align: center; "

		      ;; お知らせメッセージ notice.txt 
		      (if (file-exists? "./notice.txt")
			  (html:div :class "notice"
				    (html:p
				     (port->string (open-input-file "./notice.txt"))))
			  ""))
	    (html:fieldset :class "fieldset"
	     (html:legend :class "legend" "使い方")
	     (html:ul
	      (html:li "単語をスペースで区切って入力し、確定ボタンを押すと日本語に変換されます。 (例: ryokou ni kiteimasu. → 旅行に来ています。)")
	      (if long-mode
		  (html:li "助詞『は』『を』『と』『に』等 はスペースで区切って入力します。(例: kaigairyokou hoken ha →  海外旅行保険は)")
		  (html:li "スペースは、スペースを二回入力して下さい。 (例: wa-kinguhoride-&nbsp;&nbsp;&nbsp;o-sutoraria → ワーキングホリデー&nbsp;&nbsp;オーストラリア)"))
	      
	      (if long-mode
		  (html:li
		   "このページは長文作成用です。Google検索を行う場合は、"
		   (html:a :href "http://www.sumibi.org/" "Google検索モード(暗号化OFF)")
		   "』ページが便利です。")
		  (html:li
		   "このページからGoogle検索ができます。メール等長文を書く場合は『"
		   (html:a :href "https://sumibi.org/?long=1" "長文作成モード(暗号化ON)")
		   "』ページが便利です。"))))
			   

		   
	    (html:div :style "text-align: center; "
		      ;; --- Ad ---
		      (cond
		       (long-mode
			(if (file-exists? "./ad1_s.txt")
			    (port->string (open-input-file "./ad1_s.txt"))
			    ""))
		       (#t
			(if (file-exists? "./ad1.txt")
			    (port->string (open-input-file "./ad1.txt"))
			    ""))))

	    (html:div :style "text-align: right; "
		      ;; --- 日本時間の表示 ---
		      "現在の日本時間:"
		      (sys-strftime "%m月%d日 %k:%M %Z" (sys-localtime (current-time)))
		      "&nbsp;"
		      "&nbsp;"
		      "&nbsp;"
		      "&nbsp;"
		      "&nbsp;"
		      "&nbsp;"
		      "&nbsp;"
		      (html:a :href "mailto:kiyoka@sumibi.org" "メールでのお問い合わせ(ローマ字でもOKです)"
			      (html:img :alt "MailTo" :border "0" :src "sumibi_mailto.gif")))
	    (html:div :class "copyright"
		      "Sumibi Engine:Copyright&copy 2005, "
		      (html:a :href "http://www.netfort.gr.jp/~kiyoka/diary/" "Kiyoka Nishiyama") " / Sumibi Ajax:Copyright&copy 2005, Kato Atsushi"
		      (html:br)
		      "Software version = $Date: 2005/12/01 15:10:56 $ ")

	    (if (not long-mode)
		(html:div :style "text-align: center; "
			  ;; --- FLOSS関連ロゴ ---
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
			  (html:br)

			  ;; --- Ad ---
			  (cond
			   (long-mode
			    (if (file-exists? "./ad2_s.txt")
				(port->string (open-input-file "./ad2_s.txt"))
				""))
			   (#t
			    (if (file-exists? "./ad2.txt")
				(port->string (open-input-file "./ad2.txt"))
				"")))

			  (html:a :href "http://www.godaddy.com/gdshop/ssl/ssl_opensource.asp"
				  (html:img :src "http://imagesak.godaddy.com/assets/ssl/img_cert_turbo_gd.jpg" 
					    :width "88" :height "62"
					    :border "0" :alt "SourceForge.jp"))
			  
			  (html:a :href "http://creativecommons.org/licenses/GPL/2.0/"
				  (html:img :alt "CC-GNU GPL" :border "0" :src "http://creativecommons.org/images/public/cc-GPL-a.png"))
			  
			  (html:a :href "http://sourceforge.jp/"
				  (html:img :src "http://sourceforge.jp/sflogo.php?group_id=1476" :width "96" :height "31" :border "0" :alt "SourceForge.jp"))
			  
			  ;; --- No Software Patents ---
			  (html:a :href "http://www.NoSoftwarePatents.com"
				  (html:img :src "./nswpat80x15.png" :width "80" :height "15" :border "0" :alt "No Software Patents!"))

			  ;; --- mickeynet.com ---
			  (html:a :href "http://www.mickeynetusa.com/ranking/counter/incount.asp?countid=174" :target "_blank"
				  (html:img :src "http://www.mickeynet.com/e_ranklink/img/mickeynet130_35.gif" :width "130" :height "35" :border "0"))
		    
			  ;; --- 4travel ---
			  (if (not long-mode)
			      (html:a :href "http://4travel.jp/r.php?r=link"
				      (html:img :src "http://4travel.jp/img/logo_88x31.gif" :border "0" :alt "旅行のクチコミサイト フォートラベル")
				      (html:br)
				      "旅行のクチコミサイト フォートラベル")
			      "")
			  )
		"")

	    (html:br)
	    (html:br)

;;; --- 海外旅行者のための解説文章 ---
	    (html:div
	     (html:h1 "海外旅行者の強い味方 Sumibi.org")
	    
	     (html:h3 "手ぶらで海外に行きたい、でもメールも送りたい")
	     (html:p
	      "Sumibi.org (炭火.org) は海外のインターネットカフェや海外ホテルのビジネスセンターなどから"
	      "日本語でメールやブログを書いたりできるサイトです。"
	      "日本語入力(IME)の入っていない英語版Windowsからでも日本語入力できます。"
	      "海外からYahooやGoogleで『sumibi』と検索するとこのサイトが出てきます。"
	      "海外から日本語でメールを送りたい時はWebメールサービスに入っておくと便利ですね。"
	      "有名な無料Webメールサービスは"
	      (html:a :href "http://mail.yahoo.co.jp/"                      "Yahoo!メール")
	      "、"
	      (html:a :href "http://mail.goo.ne.jp/goomail/index.ghtml"     "gooメール")
	      "等があります。自分に合ったものを選びましょう。")

	     ;; --- Ad ---
	     (cond
	      (long-mode
	       (if (file-exists? "./ad3_s.txt")
		   (port->string (open-input-file "./ad3_s.txt"))
		   ""))
	      (#t
	       (if (file-exists? "./ad3.txt")
		   (port->string (open-input-file "./ad3.txt"))
		   "")))

;;; --- ホスティング依頼メッセージ ---
	     (html:br)
	   
	     (html:div :class "footer"
		       (html:p "本サイト(Sumibi.org)は小規模なハードウェア及びネットワーク資源を使ってホスティングしております。"
			       "そこで、Sumibi.orgを無償でホスティングできる環境をご提供いただける企業様を募集しています。"
			       "ご提供いただいた企業様におきましては、Sumibi.orgに優先して広告掲載させて頂きます。")
		       )))

	   (html:script :type "text/javascript" :src "ajax/Sumibi.js")
	   (html:script :type "text/javascript" :src "ajax/SumibiSOAP.js")
	   (html:script :type "text/javascript" :src "ajax/ajax_sumibi.js")
	   (html:script :type "text/javascript" :src "ajax/SumibiCustomize.js")
	   (if long-mode
"
<script>
<!--
function google_mode() { return false; }
-->
</script>
"
"
<script>
<!--
function google_mode() { return true; }
-->
</script>
")
	   (if darkside-mode
"
<script>
<!--
function amazon_mode() { return true; }
-->
</script>
"
"
<script>
<!--
function amazon_mode() { return false; }
-->
</script>
")
	   ))))))
