;; common definition file


(define HTMLSlidy:abbrev-table
  ;; A table to expand abbreviations
  ;; It's a fully static table (it uses the quote rather than a quasi-quote)
  ;; Therefore, the table (the S-expression) can be saved into a file
  `(
    (W:infoteria
     (*link "インフォテリア株式会社" "http://www.infoteria.com/jp/"))
    (W:Gauche
     (*link "Gauche" "http://www.shiro.dreamhost.com/scheme/gauche/index.html"))
    (W:GPL
     (*link "GNU General Public License (GPL2)" "http://www.gnu.org/licenses/gpl.html"))
    (W:Sumibi.org
     (*link "Sumibi.org" "http://www.sumibi.org/"))
    (W:GFDL
     (*link "GFDL" "http://ja.wikipedia.org/wiki/Wikipedia:Text_of_GNU_Free_Documentation_License"))
    (W:kato
     (*link "Kato Atsushi" "http://d.hatena.ne.jp/ktat/"))
    ))

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
                      (content "HTML Tidy for Linux/x86 and Sxmlcnv")))
                  (title ,_title)
                  (meta
                   (@ (http-equiv "Content-Type")
                      (content "text/html; charset=utf-8")))
                  (meta
                   (@ (name "copyright")
                      (content
                       "Copyright &copy; 2006 Sumibi Project (Kiyoka Nishiyama)")))
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
                      (href "sumibi_sea.css")))
                  (script
                   (@ (type "text/javascript") (src "slidy.js"))))
                 (body
                  (div
                   (@ (class "background"))
                   (object
                    (@
                     ;;                (type "image/svg+xml")
                     (title ,_title)
                     (id "head-logo")
                     (data "sumibi_org_WASHIlogo.png"))
                    (a
                     (@ (href "http://www.sumibi.org/"))
                     (img
                      (@
                       (src "sea1.png")
                       (id "head-logo-fallback")
                       (alt "picture of sea"))))))
                  (div
                   (@ (class "background slanty"))
                   (img
                    (@
                     (src "sea1.png")
                     (alt "picture of sea"))))
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
                    (@ (src "sumibi_org_WASHIlogo_large.png ")
                       (class "cover")
                       (alt "Cover page images (Sumibi LOGO by WASHI)")))
                   (br
                    (@ (clear "all")))
                   (h1 ,_title)
                   (p
                    (a
                     (@ (href "http://www.netfort.gr.jp/~kiyoka/"))
                     "Kiyoka Nishiyama")
                    ",
<"
                    (a
                     (@ (href "mailto:kiyoka@netfort.gr.jp"))
                     "kiyoka@netfort.gr.jp")
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
