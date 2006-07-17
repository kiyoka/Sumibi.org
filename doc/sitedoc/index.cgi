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
	    (cond
	     (long-mode
	      (html:div :style "text-align: center; "
			(html:span :class "subtitle"
				   "世界の果てから漢字変換")
			(html:br)
			(html:img :src "sumibi_org_WASHIlogo_small.png" :alt "Sumibi.org LOGO")
			"  [長文作成モード]  "))
	     (else
	      (html:div :style "text-align: center; "
			(html:br)
			(html:span :class "subtitle"
				   "世界の果てから漢字変換")
			(html:br)
			(html:img :src "sumibi_org_WASHIlogo.png" :alt "Sumibi.org LOGO")
			(html:br)
			
			(html:span :class "subtitle"
				   "Sumibi.orgはローマ字を日本語に変換できる、今すぐ使える無料サイトです。"
				   (html:br)
				   "Sumibi.org ha ro-maji wo nihongo ni henkan suru muryou saito desu. From romaji to kanji.")
			(html:br)
			)))
		    
	    (html:div :style "text-align: center; "
		      (html:form :id "gform" :method "get" :action "http://www.google.co.jp/custom" :target "_top"
				 (html:input :type "hidden" :id "server" :name "server" :value "testing"  :onClick "select_server(this.value)")
				 (if long-mode
				     (html:div :style "text-align: center; "
					       (html:textarea :id "q" :name "q" :cols "90%" :rows "12")
					       )
				     (html:div
				      (html:p
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
	      (html:li "ローマ字で単語を入力し、スペースを入力すると日本語に変換されます。 (例: ryokou ni kiteimasu. → 旅行に来ています。)")
	      (if long-mode
		  (html:li
		   "このページは長文作成用です。Google検索を行う場合は『"
		   (html:a :href "http://www.sumibi.org/" "Google検索モード")
		   "』ページが便利です。")
		  (html:li
		   "このページからGoogle検索ができます。メール等長文を書く場合は『"
		   (html:a :href "http://sumibi.org/?long=1" "長文作成モード")
		   "』ページが便利です。"))
	      (if long-mode
		  (html:li "助詞『は』『を』『と』『に』等 はスペースで区切って入力します。(例: watashi ha ongaku ga sukidesu.  →  私は音楽が好きです。)")
		  (html:li "スペースは、スペースを二回入力して下さい。 (例: wa-rudokappu&nbsp;&nbsp;&nbsp;doitu →  ワールドカップ&nbsp;&nbsp;ドイツ)"))))
	    (html:br)
	    
	    (html:div :style "text-align: center; "
		      ;; --- Ad ---
		      (cond
;;		       (long-mode
;;			(if (file-exists? "./ad1_s.txt")
;;			    (port->string (open-input-file "./ad1_s.txt"))
;;			    ""))
		       (#t
			(if (file-exists? "./ad1.txt")
			    (port->string (open-input-file "./ad1.txt"))
			    ""))))

	    (html:br)
	    (html:div :style "text-align: center; "
		      (html:a :href "sumibi/faq.html"            "Q&A")
		      " / "
		      (html:a :href "sumibi/privacy_policy.html" "Privacy Policy")
		      " / "
		      (html:a :href "sumibi/sumibi.html"         "Documents"))
	    (html:br)
		      
	    (html:div :class "copyright"
		      "Sumibi Engine:Copyright&copy 2005,2006 Kiyoka Nishiyama"
		      "("
		      (html:a :href "http://www.netfort.gr.jp/~kiyoka/diary/" "開発者ブログ")
		      ")"
		      "("
		      (html:a :href "mailto:kiyoka@netfort.gr.jp" "メール")
		      ")"
		      " / Sumibi Ajax:Copyright&copy 2005,2006 Kato Atsushi"
		      "("
		      (html:a :href "http://d.hatena.ne.jp/ktat/" "開発者ブログ")
		      ")"
		      "&nbsp;"
		      "&nbsp;"
		      "&nbsp;"
		      "&nbsp;"
		      "&nbsp;"
		      "&nbsp;"
		      "&nbsp;"
		      "&nbsp;"
		      "&nbsp;"
		      "&nbsp;"
		      "&nbsp;"
		      "&nbsp;"
		      "現在の日本時間:"
		      (sys-strftime "%m月%d日 %k:%M" (sys-localtime (current-time))))
	    (html:br)
	    (html:br)
	    )
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
