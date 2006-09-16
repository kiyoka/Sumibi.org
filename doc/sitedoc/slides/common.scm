;; common definition file


(define HTMLSlidy:abbrev-table
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


(define HTMLSlidy:style-sheet
  `(
    (*link				; (*link keyword url)
     *macro*
     . ,(lambda (_link keyword url)
	  `(a (@ (href ,url)) ,keyword)))

    ;; (*slide title elem ...)
    (*slide
     *macro*
     . ,(lambda (_section title . elem)
          `(div (@ (class "slide"))
                (h1 ,title)
                ,elem)))

    ;; (*ul elem ...)
    ;; normal html <ul> tag
    (*ul
     *macro*
     . ,(lambda (_ul . elem)
          `(ul
            ,elem)))

    ;; (*ul class="incremental" elem ...)
    ;; normal html <ul> tag
    (*ul-inc
     *macro*
     . ,(lambda (_ul . elem)
          `(ul (@ (class "incremental"))
               ,elem)))

    ;; (*insert-file path)
    ;; expand contents of file at path
    (*insert-file
     *macro*
     . ,(lambda (_insert-file file-name)
	  `(program
	    ,(port->string (open-input-file file-name)))))


    ;; expand an abbreviation according to the HTMLSlidy:abbrev-table
    ;; (unquote abbrev-tag)
    (,(string->symbol "unquote")
     *macro*
     . ,(lambda (tag abbrev-tag)
	  (cond
	   ((assq abbrev-tag HTMLSlidy:abbrev-table) => cadr)
	   (else (error "Unknown abbreviation: " abbrev-tag)))))
    ))
   
   
(define (output _title tree)
  (SXML->XML 
   HTMLSlidy:style-sheet 
   `(*TOP* (*PI* xml "version='1.0' ")
           (html (@ (xmlns "http://www.w3.org/1999/xhtml")
                    (xml:lang "en")
                    (lang "en-US"))
                  
            (head
             (meta
              (@ (name "generator")
                 (content
                  "HTML Tidy for Linux/x86 (vers 1st November 2003), see www.w3.org")))
             (title "HTML Slidy")
             (meta
              (@ (http-equiv "Content-Type")
                 (content "text/html; charset=utf-8")))
             (meta
              (@ (name "copyright")
                 (content
                  "Copyright (c) 2005 W3C (MIT, ERCIM, Keio)")))
             (meta
              (@ (name "font-size-adjustment") (content "-2")))
             (link
              (@ (type "text/css")
                 (rel "stylesheet")
                 (media "screen, projection, print")
                 (href "slidy.css")))
             (link
              (@ (type "text/css")
                 (rel "stylesheet")
                 (media "screen, projection, print")
                 (href "w3c-blue.css")))
             (script
              (@ (type "text/javascript") (src "slidy.js"))))
            (body
             (div
              (@ (class "background"))
              (img
               (@ (src "icon-blue.png")
                  (id "head-icon")
                  (alt "")))
              (object
               (@ (type "image/svg+xml")
                  (title _title)
                  (id "head-logo")
                  (data "w3c-logo-blue.svg"))
               (a
                (@ (href "http://www.w3.org/"))
                (img
                 (@ (src "w3c-logo-blue.gif")
                    (id "head-logo-fallback")
                    (alt "W3C logo"))))))
             (div
              (@ (class "background slanty"))
              (img
               (@ (src "w3c-logo-slanted.jpg")
                  (alt "slanted W3C logo"))))
             (div
              (@ (class "slide cover"))
              (img
               (@ (src "../Slidy/bullet.png")
                  (class "hidden")
                  (alt "")))
              (img
               (@ (src "../Slidy/fold.gif")
                  (class "hidden")
                  (alt "")))
              (img
               (@ (src "../Slidy/unfold.gif")
                  (class "hidden")
                  (alt "")))
              (img
               (@ (src "../Slidy/fold-dim.gif")
                  (class "hidden")
                  (alt "")))
              (img
               (@ (src "../Slidy/nofold-dim.gif")
                  (class "hidden")
                  (alt "")))
              (img
               (@ (src "../Slidy/unfold-dim.gif")
                  (class "hidden")
                  (alt "")))
              (img
               (@ (src "../Slidy/bullet-fold.gif")
                  (class "hidden")
                  (alt "")))
              (img
               (@ (src "../Slidy/bullet-unfold.gif")
                  (class "hidden")
                  (alt "")))
              (img
               (@ (src "../Slidy/bullet-fold-dim.gif")
                  (class "hidden")
                  (alt "")))
              (img
               (@ (src "../Slidy/bullet-nofold-dim.gif")
                  (class "hidden")
                  (alt "")))
              (img
               (@ (src "../Slidy/bullet-unfold-dim.gif")
                  (class "hidden")
                  (alt "")))
              (img
               (@ (src "keys.jpg")
                  (class "cover")
                  (alt "Cover page images (keys)")))
              (br
               (@ (clear "all")))
              (h1
               "HTML Slidy: Slide Shows in XHTML")
              (p
               (a
                (@ (href "http://www.w3.org/People/Raggett/"))
                "Dave Raggett")
               ",
<"
               (a
                (@ (href "mailto:dsr@w3.org"))
                "dsr@w3.org")
               ">"
               (br)
               (br)
               (br)
               (br)
               (br)
               (em
                "Hit the space bar for next slide")))

             ,tree
             )))))

