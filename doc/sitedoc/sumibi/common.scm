;; common definition file



(define page-alist
  '(
    ( sumibi    
      "Sumibi"
      "sumibi.html")
    ( el-stable
      "sumibi.el (stable)"
      "sumibi_el_stable.html")
    ( el-testing
      "sumibi.el (testing)"
      "sumibi_el_testing.html")
    ( api-testing
      "Sumibi Web API (testing)"
      "sumibi_api_testing.html")
    ( faq
      "FAQ"
      "faq.html")))


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
    ;; sourceforge link logo
    (W:sf-logo
     (native
      (@ (format "html"))
      "
<hr>
hosted by 
<a href=\"http://sourceforge.jp/\"><img src=\"http://sourceforge.jp/sflogo.php?group_id=1476\" width=\"96\" height=\"31\" border=\"0\" alt=\"SourceForge.jp\"></a>
"
      ))
    ;; link tab
    (L:tab
     (native
      (@ (format "html"))
      ,(map
	(lambda (x)
	  (format "[<a href=\"~a\">~a</a>]"
		  (caddr x)
		  (cadr x)))
	page-alist)))
     
    ))


(define (output key tree)
    
  (SXML->XML 
   SmartDoc:style-sheet 
   `(*TOP* 
     (*PI* xml "version='1.0' ")
     (doc (@ (xml:lang "ja"))
	  (head (title 
		 ,(cadr (assoc key page-alist)))
		(author " Kiyoka Nishiyama ")
		(hp " http://www.sumibi.org/ ")
		(date " $Date: 2005/06/26 14:07:38 $ "))
	  ,tree
	  ))))


	  

