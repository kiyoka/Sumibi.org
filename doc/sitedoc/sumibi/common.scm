;; common definition file


(use util.list)

(define page-alist
  '(
    ( sumibi
      "Sumibi"
      "sumibi.html")
    ( el-stable
      "sumibi.el(STABLE)"
      "sumibi_el_stable.html")
    ( api-stable
      "SumibiWebAPI(STABLE)"
      "sumibi_api_stable.html")
    ( el-testing
      "sumibi.el(testing)"
      "sumibi_el_testing.html")
    ( api-testing
      "SumibiWebAPI(testing)"
      "sumibi_api_testing.html")
    ( server-setup
      "SumibiServerSetup"
      "sumibi_server_setup.html")
    ( faq
      "Q&A"
      "faq.html")
    ( privacy-policy
      "PrivacyPolicy"
      "privacy_policy.html")
    ( sumi
      "sumi"
      "sumi.html")
    ( sumiyaki
      "sumiyaki"
      "sumiyaki.html")
    ( romaji-table
      "RomajiTable"
      "romaji_table.html")
    ))


(define SmartDoc:abbrev-table
  ;; A table to expand abbreviations
  ;; It's a fully static table (it uses the quote rather than a quasi-quote)
  ;; Therefore, the table (the S-expression) can be saved into a file
  `(
    (W:sxml
     (*link "SXML" "http://okmij.org/ftp/Scheme/SXML.html"))
    (W:xml
     (*link "XML"  "http://www.w3.org/XML/"))
    (W:xml-infoset
     (*link "XML Infoset" "http://www.w3.org/TR/xml-infoset/"))
    (W:gauche
     (*link "Gauche" "http://www.shiro.dreamhost.com/scheme/gauche/index.html"))
    (W:GPL
     (*link "GNU General Public License (GPL2)" "http://www.gnu.org/licenses/gpl.html"))
    (W:CAcert
     (*link "CAcert.org" "http://www.cacert.org/"))
    (W:Sumibi.org
     (*link "Sumibi.org" "http://www.sumibi.org/"))
    (W:GFDL
     (*link "GFDL" "http://ja.wikipedia.org/wiki/Wikipedia:Text_of_GNU_Free_Documentation_License"))
    ;; sourceforge link logo
    (W:sf-logo
     (native
      (@ (format "html"))
      "
<hr>
  <!-- Creative Commons License -->
  <a href=\"http://creativecommons.org/licenses/GPL/2.0/\"><img alt=\"CC-GNU GPL\" border=\"0\" src=\"http://creativecommons.org/images/public/cc-GPL-a.png\" /></a>
  <!-- /Creative Commons License -->
  
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
  <a href=\"http://www.godaddy.com/gdshop/ssl/ssl_opensource.asp\"
     <img src=\"http://imagesak.godaddy.com/assets/ssl/img_cert_turbo_gd.jpg\"
  	width=\"88\" height=\"62\"
  	border=\"0\" alt=\"SourceForge.jp\">
  </a>

  <a href=\"http://sourceforge.jp/\"><img src=\"http://sourceforge.jp/sflogo.php?group_id=1476\" width=\"96\" height=\"31\" border=\"0\" alt=\"SourceForge.jp\"></a>

  <a href=\"http://www.mickeynetusa.com/ranking/counter/incount.asp?countid=174\" target=\"_blank\"
     <img src=\"http://www.mickeynet.com/e_ranklink/img/mickeynet130_35.gif\" width=\"130\" height=\"35\" border=\"0\">
  </a>
  <a href=\"http://www.NoSoftwarePatents.com\"
     <img src=\"../nswpat80x15.png\" width=\"80\" height=\"15\" border=\"0\" alt=\"No Software Patents!\">
  </a>
"
      ))))

(define (output key tree)
    
  (SXML->XML 
   SmartDoc:style-sheet 
   `(*TOP* 
     (*PI* xml "version='1.0' ")
     (doc (@ (xml:lang "ja"))
	  (head
	   (native
	    (@ (format "html"))
	    "<link rel=\"shortcut icon\" href=\"/favicon.ico\">  <link rel=\"icon\" href=\"/favicon.png\" type=\"image/png\">")
	   (title 
	    ,(car (assq-ref page-alist key)))
	   (author " Kiyoka Nishiyama ")
	   (hp " http://www.sumibi.org/ ")
	   (date " $Date: 2006/11/23 01:48:55 $ "))
	  (body

	   ;; navigation tab
	   (native
	    (@ (format "html"))
	    ,(list
	      "<div class=\"sumibi_menu\">"
	      (map
	       (lambda (x)
		 (if (equal? key (car x))
		     (format "[~a]"
			     (cadr x))
		     (format "[<a href=\"~a\">~a</a>]"
			     (caddr x)
			     (cadr x))))
	       page-alist)
	      "</div>"))


	   ,tree
	   )))))
