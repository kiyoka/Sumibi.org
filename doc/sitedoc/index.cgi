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
	   (qbox-value    (cgi-get-parameter "q" params)))
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
            :onLoad "document.getElementById('qbox').focus() ;select_server('testing')"
	    (cond
	     (long-mode
	      (html:div :style "text-align: center; "
			(html:span :class "subtitle"
				   "世界の果てから漢字変換")
			(html:br)
			(html:img :src "sumibi_org_WASHIlogo_small.png" :alt "Sumibi.org LOGO" :border 0)
			"  [長文作成モード]  "))
	     (else
	      (html:div :style "text-align: center; "
			(html:span :class "subtitle"
				   "世界の果てから漢字変換")
			(html:br)
                        (html:a :href "http://www.sumibi.org/"
                                (html:img :src "sumibi_org_WASHIlogo.png" :alt "Sumibi.org LOGO" :border 0))
			(html:br)
			
			(html:span :class "subtitle"
				   "Sumibi.orgはローマ字を日本語に変換できる、今すぐ使える無料サイトです。"
				   (html:br)
				   "Sumibi.org ha ro-maji wo nihongo ni henkan suru muryou saito desu. From romaji to kanji.")
			(html:br)
			)))
		    
	    (html:div :style "text-align: center; "
		      (html:form :id "gform" :method "get" :action "./index.cgi" :target "_top"
				 (if long-mode
				     (html:div :style "text-align: center; "
					       (html:textarea :id "qbox" :name "q" :cols "90%" :rows "12" :onKeyPress "Sumibi_key_process_in_text( 'qbox', event )")
					       )
				     (html:div
				      (html:p
				       (html:input :type "text" :id "qbox" :name "q" :size "41" :maxlength "2048" :onKeyPress "Sumibi_key_process_in_text( 'qbox', event )" :value
                                                   (if qbox-value
                                                       qbox-value
                                                       ""))
				       (html:input :type "submit" :name "sa" :value "Google検索"))))
				 (html:input :type "hidden" :name "client" :value "pub-5721837636688174")
				 (html:input :type "hidden" :name "forid"  :value "1")
				 (html:input :type "hidden" :name "ie"     :value "UTF-8")
				 (html:input :type "hidden" :name "oe"     :value "UTF-8")
				 (html:input :type "hidden" :name "cof"    :value "GALT:#008000;GL:1;DIV:#336699;VLC:663399;AH:center;BGC:FFFFFF;LBGC:336699;ALC:0000FF;LC:0000FF;T:000000;GFNT:0000FF;GIMP:0000FF;LH:25;LW:80;L:http://www.sumibi.org/sumibi_org_logo.png;S:http://www.sumibi.org/;LP:1;FORID:11")
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
            (if (not qbox-value)
                ""
                (if (< 0 (string-length qbox-value))
                    "
<!-- Google Search Result Snippet Begins -->
<div style=\"text-align: center;\" id=\"googleSearchUnitIframe\"></div>

<script type=\"text/javascript\">
   var googleSearchIframeName = 'googleSearchUnitIframe';
   var googleSearchFrameWidth = 650;
   var googleSearchFrameHeight = 1400;
   var googleSearchFrameborder = 0 ;
</script>
<script type=\"text/javascript\"
         src=\"http://www.google.com/afsonline/show_afs_search.js\">
</script>
<!-- Google Search Result Snippet Ends -->
"
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
		  (html:li "助詞『は』『を』『と』『に』等 はスペースで区切って入力します。(例: watashi ha ryokou ga sukidesu.  →  私は旅行が好きです。)")
                  (html:li "スペースは、スペースを二回入力して下さい。 (例: keitai&nbsp;&nbsp;&nbsp;rentaru →  携帯&nbsp;レンタル)"))
              (html:a :href "sumibi_video.gif"
                      (html:img :src "sumibi_usage_icon.png" :alt "Sumibi.org usage icon" :border 0 :width 100))))
            
	    (html:br)
	    
	    (html:div :style "text-align: center; "
		      ;; --- Ad ---
                      (if (file-exists? "./ad1.txt")
                          (port->string (open-input-file "./ad1.txt"))
                          ""))

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
		      (html:a :href "http://oldtype.sumibi.org/show-page/!kiyoka.blog" "開発者ブログ")
		      ")"
		      "("
		      (html:a :href "mailto:kiyoka@sumibi.org" "メール")
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
		      (sys-strftime "%m月%d日 %k:%M" (sys-localtime (current-time)))
		      "&nbsp;"
		      "&nbsp;"
                      (html:a :href "http://worldtickr.com/" "世界の時間を確認できるサイト")
                      )
	    (html:br)
	    (html:br)
	    (html:div :style "text-align: center; "
                      (if (file-exists? "./ad2.txt")
                          (port->string (open-input-file "./ad2.txt"))
                          ""))

            )
           (if long-mode
               (html:script :type "text/javascript"       "function google_mode() { return false; }")
               (html:script :type "text/javascript"       "function google_mode() { return true;  }"))
	   (html:script :type "text/javascript" :src "ajax/SumibiCustomize.js")
           (html:script :type "text/javascript" :src "ajax/Sumibi.js")
	   (html:script :type "text/javascript" :src "ajax/SumibiSOAP.js")
           (html:script :type "text/javascript" :src "ajax/ajax_sumibi.js")
           ))))))
