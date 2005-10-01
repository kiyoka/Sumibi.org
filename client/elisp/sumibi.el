;;;-*- mode: lisp-interaction; syntax: elisp -*-;;;
;;
;; "sumibi.el" is a client for Sumibi server.
;;
;;   Copyright (C) 2002,2003,2004,2005 Kiyoka Nishyama
;;   This program was derived from yc.el-4.0.13(auther: knak)
;;
;;     $Date: 2005/10/01 14:36:34 $
;;
;; This file is part of Sumibi
;;
;; Sumibi is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;; 
;; Sumibi is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;; 
;; You should have received a copy of the GNU General Public License
;; along with Sumibi; see the file COPYING.
;;
;;

;;;     $BG[I[>r7o(B: GPL
;;; $B:G?7HGG[I[85(B: http://sourceforge.jp/projects/sumibi/
;;; 
;;; $BITL@$JE@$d2~A1$7$?$$E@$,$"$l$P(BSumibi$B$N%a!<%j%s%0%j%9%H$K;22C$7$F%U%#!<%I%P%C%/$r$*$M$,$$$7$^$9!#(B
;;;
;;; $B$^$?!"(BSumibi$B$K6=L#$r;}$C$F$$$?$@$$$?J}$O$I$J$?$G$b(B
;;; $B5$7Z$K%W%m%8%'%/%H$K$4;22C$/$@$5$$!#(B
;;;
;;; $B%$%s%9%H!<%kJ}K!!";H$$$+$?$O0J2<$N(BWeb$B%5%$%H$K$"$j$^$9$N$G$"$o$;$F;2>H$7$F$/$@$5$$!#(B
;;;   http://www.sumibi.org/
;;;

;;; Code:

(require 'cl)

;;; 
;;;
;;; customize variables
;;;
(defgroup sumibi nil
  "Sumibi client."
  :group 'input-method
  :group 'Japanese)

(defcustom sumibi-server-url "https://sumibi.org/cgi-bin/sumibi/unstable/sumibi.cgi"
  "Sumibi$B%5!<%P!<$N(BURL$B$r;XDj$9$k!#(B"
  :type  'string
  :group 'sumibi)

(defcustom sumibi-server-cert-data
  "-----BEGIN CERTIFICATE-----
MIIC5zCCAlACAQEwDQYJKoZIhvcNAQEFBQAwgbsxJDAiBgNVBAcTG1ZhbGlDZXJ0
IFZhbGlkYXRpb24gTmV0d29yazEXMBUGA1UEChMOVmFsaUNlcnQsIEluYy4xNTAz
BgNVBAsTLFZhbGlDZXJ0IENsYXNzIDIgUG9saWN5IFZhbGlkYXRpb24gQXV0aG9y
aXR5MSEwHwYDVQQDExhodHRwOi8vd3d3LnZhbGljZXJ0LmNvbS8xIDAeBgkqhkiG
9w0BCQEWEWluZm9AdmFsaWNlcnQuY29tMB4XDTk5MDYyNjAwMTk1NFoXDTE5MDYy
NjAwMTk1NFowgbsxJDAiBgNVBAcTG1ZhbGlDZXJ0IFZhbGlkYXRpb24gTmV0d29y
azEXMBUGA1UEChMOVmFsaUNlcnQsIEluYy4xNTAzBgNVBAsTLFZhbGlDZXJ0IENs
YXNzIDIgUG9saWN5IFZhbGlkYXRpb24gQXV0aG9yaXR5MSEwHwYDVQQDExhodHRw
Oi8vd3d3LnZhbGljZXJ0LmNvbS8xIDAeBgkqhkiG9w0BCQEWEWluZm9AdmFsaWNl
cnQuY29tMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDOOnHK5avIWZJV16vY
dA757tn2VUdZZUcOBVXc65g2PFxTXdMwzzjsvUGJ7SVCCSRrCl6zfN1SLUzm1NZ9
WlmpZdRJEy0kTRxQb7XBhVQ7/nHk01xC+YDgkRoKWzk2Z/M/VXwbP7RfZHM047QS
v4dk+NoS/zcnwbNDu+97bi5p9wIDAQABMA0GCSqGSIb3DQEBBQUAA4GBADt/UG9v
UJSZSWI4OB9L+KXIPqeCgfYrx+jFzug6EILLGACOTb2oWH+heQC1u+mNr0HZDzTu
IYEZoDJJKPTEjlbVUjP9UNV+mWwD5MlM/Mtsq2azSiGM5bUMMj4QssxsodyamEwC
W/POuZ6lcg5Ktz885hZo+L7tdEy8W9ViH0Pd
-----END CERTIFICATE-----
"
  "Sumibi$B%5!<%P!<$HDL?.$9$k;~$N(BSSL$B>ZL@=q%G!<%?!#(B"
  :type  'string
  :group 'sumibi)

(defcustom sumibi-server-use-cert t
  "Sumibi$B%5!<%P!<$HDL?.$9$k;~$N(BSSL$B>ZL@=q$r;H$&$+$I$&$+!#(B"
  :type  'symbol
  :group 'sumibi)

(defcustom sumibi-server-timeout 10
  "Sumibi$B%5!<%P!<$HDL?.$9$k;~$N%?%$%`%"%&%H$r;XDj$9$k!#(B($BIC?t(B)"
  :type  'integer
  :group 'sumibi)
 
(defcustom sumibi-stop-chars ";:(){}<>"
  "*$B4A;zJQ49J8;zNs$r<h$j9~$`;~$KJQ49HO0O$K4^$a$J$$J8;z$r@_Dj$9$k(B"
  :type  'string
  :group 'sumibi)

(defcustom sumibi-replace-keyword-list '(
					 ("no" . "no.h")
					 ("ha" . "ha.h")
					 ("ga" . "ga.h")
					 ("wo" . "wo.h")
					 ("ni" . "ni.h")
					 ("de" . "de.h"))

  "Sumibi$B%5!<%P!<$KJ8;zNs$rAw$kA0$KCV49$9$k%-!<%o!<%I$r@_Dj$9$k(B"
  :type  'sexp
  :group 'sumibi)

(defcustom sumibi-curl "curl"
  "curl$B%3%^%s%I$N@dBP%Q%9$r@_Dj$9$k(B"
  :type  'string
  :group 'sumibi)

(defcustom sumibi-use-viper nil
  "*Non-nil $B$G$"$l$P!"(BVIPER $B$KBP1~$9$k!#(B"
  :type 'boolean
  :group 'sumibi)


(defvar sumibi-mode nil             "$B4A;zJQ49%H%0%kJQ?t(B")
(defvar sumibi-mode-line-string     " Sumibi")
(defvar sumibi-select-mode nil      "$B8uJdA*Br%b!<%IJQ?t(B")
(or (assq 'sumibi-mode minor-mode-alist)
    (setq minor-mode-alist (cons
			    '(sumibi-mode        sumibi-mode-line-string)
			    minor-mode-alist)))


;; $B%m!<%^;z4A;zJQ49;~!"BP>]$H$9$k%m!<%^;z$r@_Dj$9$k$?$a$NJQ?t(B
(defvar sumibi-skip-chars "a-zA-Z0-9 .,\\-+!\\[\\]?")
(defvar sumibi-mode-map        (make-sparse-keymap)         "$B4A;zJQ49%H%0%k%^%C%W(B")
(defvar sumibi-select-mode-map (make-sparse-keymap)         "$B8uJdA*Br%b!<%I%^%C%W(B")
(defvar sumibi-rK-trans-key "\C-j"
  "*$B4A;zJQ49%-!<$r@_Dj$9$k(B")
(or (assq 'sumibi-mode minor-mode-map-alist)
    (setq minor-mode-map-alist
	  (append (list (cons 'sumibi-mode         sumibi-mode-map)
			(cons 'sumibi-select-mode  sumibi-select-mode-map))
		  minor-mode-map-alist)))

;; $B%f!<%6!<3X=,<-=q(B
(defvar sumibi-kakutei-history '())


;;;
;;; hooks
;;;
(defvar sumibi-mode-hook nil)
(defvar sumibi-select-mode-hook nil)
(defvar sumibi-select-mode-end-hook nil)


;;--- $B%G%P%C%0%a%C%;!<%8=PNO(B
(defvar sumibi-debug nil)		; $B%G%P%C%0%U%i%0(B
(defun sumibi-debug-print (string)
  (if sumibi-debug
      (let
	  ((buffer (get-buffer-create "*sumibi-debug*")))
	(with-current-buffer buffer
	  (goto-char (point-max))
	  (insert string)))))


;;; sumibi basic output
(defvar sumibi-fence-start nil)		; fence $B;OC<0LCV(B
(defvar sumibi-fence-end nil)		; fence $B=*C<0LCV(B
(defvar sumibi-henkan-separeter " ")	; fence mode separeter
(defvar sumibi-henkan-buffer nil)	; $BI=<(MQ%P%C%U%!(B
(defvar sumibi-henkan-length nil)	; $BI=<(MQ%P%C%U%!D9(B
(defvar sumibi-henkan-revpos nil)	; $BJ8@a;OC<0LCV(B
(defvar sumibi-henkan-revlen nil)	; $BJ8@aD9(B

;;; sumibi basic local
(defvar sumibi-cand     nil)		; $B%+%l%s%HJ8@aHV9f(B
(defvar sumibi-cand-n   nil)		; $BJ8@a8uJdHV9f(B
(defvar sumibi-cand-n-backup   nil)	; $BJ8@a8uJdHV9f(B ( $B8uJdA*Br%-%c%s%;%kMQ(B )
(defvar sumibi-cand-max nil)		; $BJ8@a8uJd?t(B
(defvar sumibi-last-fix "")		; $B:G8e$K3NDj$7$?J8;zNs(B
(defvar sumibi-henkan-list nil)		; $BJ8@a%j%9%H(B
(defvar sumibi-repeat 0)		; $B7+$jJV$72s?t(B
(defvar sumibi-marker-list '())		; $BJ8@a3+;O!"=*N;0LCV%j%9%H(B: $B<!$N$h$&$J7A<0(B ( ( 1 . 2 ) ( 5 . 7 ) ... ) 
(defvar sumibi-timer    nil)            ; $B%$%s%?!<%P%k%?%$%^!<7?JQ?t(B

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; $BI=<(7O4X?t72(B
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar sumibi-use-fence t)
(defvar sumibi-use-color nil)

(defvar sumibi-init nil)
(defvar sumibi-server-cert-file nil)

;;
;; $B=i4|2=(B
;;
(defun sumibi-init ()

  ;; $B%F%s%]%i%j%U%!%$%k$r:n@.$9$k!#(B
  (defun sumibi-make-temp-file (base)
    (if	(functionp 'make-temp-file)
	(make-temp-file base)
      (concat "/tmp/" (make-temp-name base))))

  (when (not sumibi-init)
    ;; SSL$B>ZL@=q%U%!%$%k$r%F%s%]%i%j%U%!%$%k$H$7$F:n@.$9$k!#(B
    (setq sumibi-server-cert-file 
	  (sumibi-make-temp-file
	   "sumibi.certfile"))
    (sumibi-debug-print (format "cert-file :[%s]\n" sumibi-server-cert-file))
    (with-temp-buffer
      (insert sumibi-server-cert-data)
      (write-region (point-min) (point-max) sumibi-server-cert-file  nil nil))

    ;; Emacs$B=*N;;~(BSSL$B>ZL@=q%U%!%$%k$r:o=|$9$k!#(B
    (add-hook 'kill-emacs-hook
	      (lambda ()
		(delete-file sumibi-server-cert-file)))

    ;; $B%?%$%^!<%$%Y%s%H4X?t$NEPO?(B
    ;;    (setq sumibi-timer
    ;;	  (run-at-time 1 1
    ;;		       '(lambda ()
    ;;			  (message "sumibi-time-handler"))))


    ;; $B=i4|2=40N;(B
    (setq sumibi-init t)))


;;
;; $B%m!<%^;z$G=q$+$l$?J8>O$r(BSumibi$B%5!<%P!<$r;H$C$FJQ49$9$k(B
;;
(defun sumibi-soap-request (func-name arg-list)
  (let (
	(command
	 (concat
	  sumibi-curl " --silent --show-error "
	  (format " --max-time %d " sumibi-server-timeout)
	  (if sumibi-server-use-cert
	    (if (not sumibi-server-cert-file)
		(error "Error : cert file create miss!")
	      (format "--cacert '%s' " sumibi-server-cert-file))
	    " --insecure ")
	  (format " --header 'Content-Type: text/xml' " sumibi-server-timeout)
	  (format " --header 'SOAPAction:urn:SumibiConvert#%s' " func-name)
	  sumibi-server-url " "
	  (format (concat "--data '"
			  "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
			  "  <SOAP-ENV:Envelope xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\""
			  "   SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\""
			  "   xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\""
			  "   xmlns:xsi=\"http://www.w3.org/1999/XMLSchema-instance\""
			  "   xmlns:xsd=\"http://www.w3.org/1999/XMLSchema\">"
			  "  <SOAP-ENV:Body>"
			  "    <namesp1:%s xmlns:namesp1=\"urn:SumibiConvert\">"
			  (mapconcat
			   (lambda (x)
			     (format "    <in xsi:type=\"xsd:string\">%s</in>" x))
			   arg-list
			   " ")
			  "    </namesp1:%s>"
			  "  </SOAP-ENV:Body>"
			  "</SOAP-ENV:Envelope>"
			  "' ")
		  func-name
		  func-name
		  func-name
		  func-name
		  ))))

    (sumibi-debug-print (format "curl-command :%s\n" command))

    (let* (
	   (_xml
	    (shell-command-to-string
	     command))
	   (_match
	    (string-match "<s-gensym3[^>]+>\\(.+\\)</s-gensym3>" _xml)))
	   
      (sumibi-debug-print (format "curl-result-xml :%s\n" _xml))

      (if _match 
	  (decode-coding-string
	   (base64-decode-string 
	    (match-string 1 _xml))
	   'euc-jp)
	_xml))))

      
;;
;; $B%m!<%^;z$G=q$+$l$?J8>O$r(BSumibi$B%5!<%P!<$r;H$C$FJQ49$9$k(B
;;
(defun sumibi-henkan-request (yomi)
  (sumibi-debug-print (format "henkan-input :[%s]\n"  yomi))

  (message "Requesting to sumibi server...")
  (let* (
	 (result (sumibi-soap-request "doSumibiConvertSexp" (list yomi))))

    (sumibi-debug-print (format "henkan-result:%S\n" result))
    (if (eq (string-to-char result) ?\( )
	(progn
	 (message nil)
	 (condition-case err
	     (read result)
	   (end-of-file
	    (progn
	      (message "Parse error for parsing result of Sumibi Server.")
	      nil))))
      (progn
	(message result)
	nil))))


;; $BCV49%-!<%o!<%I$r2r7h$9$k(B
(defun sumibi-replace-keyword (str)
  (let (
	(word-list (split-string str)))
    (mapconcat
     (lambda (x)
       (let ((val (assoc x sumibi-replace-keyword-list)))
	 (if val
	     (cdr val)
	   x)))
     word-list
     " ")))


;; $B%j!<%8%g%s$r%m!<%^;z4A;zJQ49$9$k4X?t(B
(defun sumibi-henkan-region (b e)
  "$B;XDj$5$l$?(B region $B$r4A;zJQ49$9$k(B"
  (sumibi-init)
  (when (/= b e)
    (let* (
	   (yomi (buffer-substring-no-properties b e))
	   (henkan-list (sumibi-henkan-request (sumibi-replace-keyword yomi))))
      
      (if henkan-list
	  (progn
	    ;; $BJ8@a$,0l$D$N>l9g$@$1%f!<%6!<<-=q$rMxMQ$9$k(B
	    (when (>= 1 (length henkan-list))
	      (let ( 
		    (_ (assoc yomi sumibi-kakutei-history)))
		(when _
		  (setq henkan-list
			(list
			 (append
			  `((j ,(cdr _) 0 0))
			  (car henkan-list)))))))
		
	    (condition-case err
		(progn
		  (setq
		   ;; $BJQ497k2L$NJ];}(B
		   sumibi-henkan-list henkan-list
		   ;; $BJ8@aA*Br=i4|2=(B
		   sumibi-cand-n   (make-list (length henkan-list) 0)
		   ;; 
		   sumibi-cand-max (mapcar
				    (lambda (x)
				      (length x))
				    henkan-list))
		  
		  (sumibi-debug-print (format "sumibi-henkan-list:%s \n" sumibi-henkan-list))
		  (sumibi-debug-print (format "sumibi-cand-n:%s \n" sumibi-cand-n))
		  (sumibi-debug-print (format "sumibi-cand-max:%s \n" sumibi-cand-max))
		  ;;
		  t)
	      (sumibi-trap-server-down
	       (beep)
	       (message (error-message-string err))
	       (setq sumibi-select-mode nil))
	      (run-hooks 'sumibi-select-mode-end-hook)))
	nil))))


;; $B%+!<%=%kA0$NJ8;z<o$rJV5Q$9$k4X?t(B
(eval-and-compile
  (if (>= emacs-major-version 20)
      (progn
	(defalias 'sumibi-char-charset (symbol-function 'char-charset))
	(when (and (boundp 'byte-compile-depth)
		   (not (fboundp 'char-category)))
	  (defalias 'char-category nil))) ; for byte compiler
    (defun sumibi-char-charset (ch)
      (cond ((equal (char-category ch) "a") 'ascii)
	    ((equal (char-category ch) "k") 'katakana-jisx0201)
	    ((string-match "[SAHK]j" (char-category ch)) 'japanese-jisx0208)
	    (t nil) )) ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; undo $B>pJs$N@)8f(B
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; undo buffer $BB`HrMQJQ?t(B
(defvar sumibi-buffer-undo-list nil)
(make-variable-buffer-local 'sumibi-buffer-undo-list)
(defvar sumibi-buffer-modified-p nil)
(make-variable-buffer-local 'sumibi-buffer-modified-p)

(defvar sumibi-blink-cursor nil)
(defvar sumibi-cursor-type nil)
;; undo buffer $B$rB`Hr$7!"(Bundo $B>pJs$NC_@Q$rDd;_$9$k4X?t(B
(defun sumibi-disable-undo ()
  (when (not (eq buffer-undo-list t))
    (setq sumibi-buffer-undo-list buffer-undo-list)
    (setq sumibi-buffer-modified-p (buffer-modified-p))
    (setq buffer-undo-list t)))

;; $BB`Hr$7$?(B undo buffer $B$rI|5"$7!"(Bundo $B>pJs$NC_@Q$r:F3+$9$k4X?t(B
(defun sumibi-enable-undo ()
  (when (not sumibi-buffer-modified-p) (set-buffer-modified-p nil))
  (when sumibi-buffer-undo-list
    (setq buffer-undo-list sumibi-buffer-undo-list)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; $B8=:_$NJQ49%(%j%"$NI=<($r9T$&(B
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun sumibi-get-display-string ()
  (let ((cnt 0))
    (mapconcat
     (lambda (x)
       ;; $BJQ497k2LJ8;zNs$rJV$9!#(B
       (let ((word (nth (nth cnt sumibi-cand-n) x)))
	 (sumibi-debug-print (format "word:[%d] %s\n" cnt word))
	 (setq cnt (+ 1 cnt))
	 (cadr word)))
     sumibi-henkan-list
     "")))


(defun sumibi-display-function (b e select-mode)
  (setq sumibi-henkan-separeter (if sumibi-use-fence " " ""))
  (when sumibi-henkan-list
    ;; UNDO$BM^@)3+;O(B
    (sumibi-disable-undo)

    (delete-region b e)

    ;; $B%j%9%H=i4|2=(B
    (setq sumibi-marker-list '())

    (let (
	   (cnt 0))

      (setq sumibi-last-fix "")

      ;; $BJQ49$7$?(Bpoint$B$NJ];}(B
      (setq sumibi-fence-start (point-marker))
      (when select-mode (insert "|"))

      (mapcar
       (lambda (x)
	 (if (and
	      (not (eq (preceding-char) ?\ ))
	      (not (eq (point-at-bol) (point)))
	      (eq (sumibi-char-charset (preceding-char)) 'ascii)
	      (and
	       (< 0 (length (cadar x)))
	       (eq (sumibi-char-charset (string-to-char (cadar x))) 'ascii)))
	     (insert " "))

	 (let* (
		(start       (point-marker))
		(_n          (nth cnt sumibi-cand-n))
		(_max        (nth cnt sumibi-cand-max))
		(insert-word (cadr (nth _n x)))
		(ank-word    (cadr (assoc 'l x)))
		(_     
		 (if (eq cnt sumibi-cand)
		     (progn
		       (insert insert-word)
		       (message (format "[%s] candidate (%d/%d)" insert-word (+ _n 1) _max))
		       ;; $B%f!<%6!<<-=q$KEPO?$9$k(B
		       (setq sumibi-kakutei-history 
			     (append
			      `((,ank-word . ,insert-word))
			      sumibi-kakutei-history)))
		   (insert insert-word)))
		(end         (point-marker))
		(ov          (make-overlay start end)))

	   ;; $B3NDjJ8;zNs$N:n@.(B
	   (setq sumibi-last-fix (concat sumibi-last-fix insert-word))
	   
	   ;; $BA*BrCf$N>l=j$rAu>~$9$k!#(B
	   (overlay-put ov 'face 'default)
	   (when (and select-mode
		      (eq cnt sumibi-cand))
	     (overlay-put ov 'face 'highlight))

	   (push `(,start . ,end) sumibi-marker-list)
	   (sumibi-debug-print (format "insert:[%s] point:%d-%d\n" insert-word (marker-position start) (marker-position end))))
	 (setq cnt (+ cnt 1)))

       sumibi-henkan-list))

    ;; $B%j%9%H$r5U=g$K$9$k!#(B
    (setq sumibi-marker-list (reverse sumibi-marker-list))

    ;; fence$B$NHO0O$r@_Dj$9$k(B
    (when select-mode (insert "|"))
    (setq sumibi-fence-end   (point-marker))

    (sumibi-debug-print (format "total-point:%d-%d\n"
				(marker-position sumibi-fence-start)
				(marker-position sumibi-fence-end)))
    ;; UNDO$B:F3+(B
    (sumibi-enable-undo)
    ))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; $BJQ498uJdA*Br%b!<%I(B
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(let ((i 0))
  (while (<= i ?\177)
    (define-key sumibi-select-mode-map (char-to-string i)
      'sumibi-kakutei-and-self-insert)
    (setq i (1+ i))))
(define-key sumibi-select-mode-map "\C-m"                   'sumibi-select-kakutei)
(define-key sumibi-select-mode-map "\C-g"                   'sumibi-select-cancel)
(define-key sumibi-select-mode-map "q"                      'sumibi-select-cancel)
(define-key sumibi-select-mode-map "\C-b"                   'sumibi-select-prev-word)
(define-key sumibi-select-mode-map "\C-f"                   'sumibi-select-next-word)
(define-key sumibi-select-mode-map "\C-a"                   'sumibi-select-first-word)
(define-key sumibi-select-mode-map "\C-e"                   'sumibi-select-last-word)
(define-key sumibi-select-mode-map "\C-p"                   'sumibi-select-prev)
(define-key sumibi-select-mode-map "\C-n"                   'sumibi-select-next)
(define-key sumibi-select-mode-map "b"                      'sumibi-select-prev-word)
(define-key sumibi-select-mode-map "f"                      'sumibi-select-next-word)
(define-key sumibi-select-mode-map "a"                      'sumibi-select-first-word)
(define-key sumibi-select-mode-map "e"                      'sumibi-select-last-word)
(define-key sumibi-select-mode-map "p"                      'sumibi-select-prev)
(define-key sumibi-select-mode-map "n"                      'sumibi-select-next)
(define-key sumibi-select-mode-map sumibi-rK-trans-key      'sumibi-select-next)
(define-key sumibi-select-mode-map " "                      'sumibi-select-next)
(define-key sumibi-select-mode-map "j"                      'sumibi-select-kanji)
(define-key sumibi-select-mode-map "h"                      'sumibi-select-hiragana)
(define-key sumibi-select-mode-map "k"                      'sumibi-select-katakana)
(define-key sumibi-select-mode-map "l"                      'sumibi-select-alphabet)


;; $BJQ49$r3NDj$7F~NO$5$l$?%-!<$r:FF~NO$9$k4X?t(B
(defun sumibi-kakutei-and-self-insert (arg)
  "$B8uJdA*Br$r3NDj$7!"F~NO$5$l$?J8;z$rF~NO$9$k(B"
  (interactive "P")
  (sumibi-select-kakutei)
  (setq unread-command-events (list last-command-event)))

;; $B8uJdA*Br>uBV$G$NI=<(99?7(B
(defun sumibi-select-update-display ()
  (sumibi-display-function
   (marker-position sumibi-fence-start)
   (marker-position sumibi-fence-end)
   sumibi-select-mode))

;; $B8uJdA*Br$r3NDj$9$k(B
(defun sumibi-select-kakutei ()
  "$B8uJdA*Br$r3NDj$9$k(B"
  (interactive)
  ;; $B8uJdHV9f%j%9%H$r%P%C%/%"%C%W$9$k!#(B
  (setq sumibi-cand-n-backup (copy-list sumibi-cand-n))
  (setq sumibi-select-mode nil)
  (run-hooks 'sumibi-select-mode-end-hook)
  (sumibi-select-update-display))

;; $B8uJdA*Br$r%-%c%s%;%k$9$k(B
(defun sumibi-select-cancel ()
  "$B8uJdA*Br$r%-%c%s%;%k$9$k(B"
  (interactive)
  ;; $B%+%l%s%H8uJdHV9f$r%P%C%/%"%C%W$7$F$$$?8uJdHV9f$GI|85$9$k!#(B
  (setq sumibi-cand-n (copy-list sumibi-cand-n-backup))
  (setq sumibi-select-mode nil)
  (run-hooks 'sumibi-select-mode-end-hook)
  (sumibi-select-update-display))

;; $BA0$N8uJd$K?J$a$k(B
(defun sumibi-select-prev ()
  "$BA0$N8uJd$K?J$a$k(B"
  (interactive)
  (let (
	(n sumibi-cand))

    ;; $BA0$N8uJd$K@Z$j$+$($k(B
    (setcar (nthcdr n sumibi-cand-n) (- (nth n sumibi-cand-n) 1))
    (when (> 0 (nth n sumibi-cand-n))
      (setcar (nthcdr n sumibi-cand-n) (- (nth n sumibi-cand-max) 1)))
    (sumibi-select-update-display)))

;; $B<!$N8uJd$K?J$a$k(B
(defun sumibi-select-next ()
  "$B<!$N8uJd$K?J$a$k(B"
  (interactive)
  (let (
	(n sumibi-cand))

    ;; $B<!$N8uJd$K@Z$j$+$($k(B
    (setcar (nthcdr n sumibi-cand-n) (+ 1 (nth n sumibi-cand-n)))
    (when (>= (nth n sumibi-cand-n) (nth n sumibi-cand-max))
      (setcar (nthcdr n sumibi-cand-n) 0))

    (sumibi-select-update-display)))

;; $BA0$NJ8@a$K0\F0$9$k(B
(defun sumibi-select-prev-word ()
  "$BA0$NJ8@a$K0\F0$9$k(B"
  (interactive)
  (when (< 0 sumibi-cand)
    (setq sumibi-cand (- sumibi-cand 1)))
  (sumibi-select-update-display))

;; $B<!$NJ8@a$K0\F0$9$k(B
(defun sumibi-select-next-word ()
  "$B<!$NJ8@a$K0\F0$9$k(B"
  (interactive)
  (when (< sumibi-cand (- (length sumibi-cand-n) 1))
    (setq sumibi-cand (+ 1 sumibi-cand)))
  (sumibi-select-update-display))

;; $B:G=i$NJ8@a$K0\F0$9$k(B
(defun sumibi-select-first-word ()
  "$B:G=i$NJ8@a$K0\F0$9$k(B"
  (interactive)
  (setq sumibi-cand 0)
  (sumibi-select-update-display))

;; $B:G8e$NJ8@a$K0\F0$9$k(B
(defun sumibi-select-last-word ()
  "$B:G8e$NJ8@a$K0\F0$9$k(B"
  (interactive)
  (setq sumibi-cand (- (length sumibi-cand-n) 1))
  (sumibi-select-update-display))


;; $B;XDj$5$l$?(B type $B$N8uJd$K6/@)E*$K@Z$j$+$($k(B
(defun sumibi-select-by-type ( _type )
  (let* (
	 (n sumibi-cand)
	 (kouho (nth n sumibi-henkan-list))
	 (_element (assoc _type kouho)))

    ;; $BO"A[%j%9%H$+$i(B _type $B$G0z$$$?(B index $BHV9f$r@_Dj$9$k$@$1$GNI$$!#(B
    (when _element
      (setcar (nthcdr n sumibi-cand-n) (nth 3 _element))
      (sumibi-select-update-display))))

(defun sumibi-select-kanji ()
  "$B4A;z8uJd$K6/@)E*$K@Z$j$+$($k(B"
  (interactive)
  (sumibi-select-by-type 'j))

(defun sumibi-select-hiragana ()
  "$B$R$i$,$J8uJd$K6/@)E*$K@Z$j$+$($k(B"
  (interactive)
  (sumibi-select-by-type 'h))

(defun sumibi-select-katakana ()
  "$B%+%?%+%J8uJd$K6/@)E*$K@Z$j$+$($k(B"
  (interactive)
  (sumibi-select-by-type 'k))

(defun sumibi-select-alphabet ()
  "$B%"%k%U%!%Y%C%H8uJd$K6/@)E*$K@Z$j$+$($k(B"
  (interactive)
  (sumibi-select-by-type 'l))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; $B%m!<%^;z4A;zJQ494X?t(B
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun sumibi-rK-trans ()
  "$B%m!<%^;z4A;zJQ49$r$9$k!#(B
$B!&%+!<%=%k$+$i9TF,J}8~$K%m!<%^;zNs$,B3$/HO0O$G%m!<%^;z4A;zJQ49$r9T$&!#(B"
  (interactive)
;  (print last-command)			; DEBUG
  (cond
   
   (sumibi-select-mode
    ;; $BJQ49Cf$K8F=P$5$l$?$i!"8uJdA*Br%b!<%I$K0\9T$9$k!#(B
    (funcall (lookup-key sumibi-select-mode-map sumibi-rK-trans-key)))


   (t
    (cond

     ((eq (sumibi-char-charset (preceding-char)) 'ascii)
      ;; $B%+!<%=%kD>A0$,(B alphabet $B$@$C$?$i(B
      (let ((end (point))
	    (gap (sumibi-skip-chars-backward)))
	(when (/= gap 0)
	  ;; $B0UL#$N$"$kF~NO$,8+$D$+$C$?$N$GJQ49$9$k(B
	  (let (
		(b (+ end gap))
		(e end))
	    (when (sumibi-henkan-region b e)
	      (if (eq (char-before b) ?/)
		  (setq b (- b 1)))
	      (delete-region b e)
	      (goto-char b)
	      (insert (sumibi-get-display-string))
	      (setq e (point))
	      (sumibi-display-function b e nil)
	      (sumibi-select-kakutei))))))

     
     ((sumibi-kanji (preceding-char))
    
      ;; $B%+!<%=%kD>A0$,(B $BA43Q$G4A;z0J30(B $B$@$C$?$i8uJdA*Br%b!<%I$K0\9T$9$k!#(B
      ;; $B$^$?!":G8e$K3NDj$7$?J8;zNs$HF1$8$+$I$&$+$b3NG'$9$k!#(B
      (when (and
	     (<= (marker-position sumibi-fence-start) (point))
	     (<= (point) (marker-position sumibi-fence-end))
	     (string-equal sumibi-last-fix (buffer-substring 
					    (marker-position sumibi-fence-start)
					    (marker-position sumibi-fence-end))))
					    
	;; $BD>A0$KJQ49$7$?(Bfence$B$NHO0O$KF~$C$F$$$?$i!"JQ49%b!<%I$K0\9T$9$k!#(B
	(let
	    ((cnt 0))
	  (setq sumibi-select-mode t)
	  (run-hooks 'sumibi-select-mode-hook)
	  (setq sumibi-cand 0)		; $BJ8@aHV9f=i4|2=(B
	  
	  (sumibi-debug-print "henkan mode ON\n")
	  
	  ;; $B%+!<%=%k0LCV$,$I$NJ8@a$K>h$C$F$$$k$+$rD4$Y$k!#(B
	  (mapcar
	   (lambda (x)
	     (let (
		   (start (marker-position (car x)))
		   (end   (marker-position (cdr x))))
	       
	       (when (and
		      (< start (point))
		      (<= (point) end))
		 (setq sumibi-cand cnt))
	       (setq cnt (+ cnt 1))))
	   sumibi-marker-list)

	  (sumibi-debug-print (format "sumibi-cand = %d\n" sumibi-cand))

	  ;; $BI=<(>uBV$r8uJdA*Br%b!<%I$K@ZBX$($k!#(B
	  (sumibi-display-function
	   (marker-position sumibi-fence-start)
	   (marker-position sumibi-fence-end)
	   t))))
     ))))



;; $BA43Q$G4A;z0J30$NH=Dj4X?t(B
(defun sumibi-nkanji (ch)
  (and (eq (sumibi-char-charset ch) 'japanese-jisx0208)
       (not (string-match "[$B0!(B-$Bt$(B]" (char-to-string ch)))))

(defun sumibi-kanji (ch)
  (eq (sumibi-char-charset ch) 'japanese-jisx0208))


;; $B%m!<%^;z4A;zJQ49;~!"JQ49BP>]$H$9$k%m!<%^;z$rFI$_Ht$P$94X?t(B
(defun sumibi-skip-chars-backward ()
  (let* (
	 ;; $B%^!<%/$5$l$F$$$k0LCV$r5a$a$k!#(B
	 (pos (or (and (markerp (mark-marker)) (marker-position (mark-marker)))
		  1))
	 ;; $B>r7o$K%^%C%A$9$k4V!"A0J}J}8~$K%9%-%C%W$9$k!#(B
	 (result (save-excursion
		   (skip-chars-backward sumibi-skip-chars (and (< pos (point)) pos))))
	 (indent 0))

    ;; $B%$%s%G%s%H0LCV$r5a$a$k!#(B
    (save-excursion
      (goto-char (point-at-bol))
      (setq indent (skip-chars-forward (concat "\t " sumibi-stop-chars) (point-at-eol))))

    (sumibi-debug-print (format "(point) = %d  result = %d  indent = %d\n" (point) result indent))
    (sumibi-debug-print (format "a = %d b = %d \n" (+ (point) result) (+ (point-at-bol) indent)))

    (if (< (+ (point) result)
	   (+ (point-at-bol) indent))
	;; $B%$%s%G%s%H0LCV$G%9%H%C%W$9$k!#(B
	(- 
	 (+ (point-at-bol) indent)
	 (point))

      result)))
  
;;;
;;; with viper
;;;
;; code from skk-viper.el
(defun sumibi-viper-normalize-map ()
  (let ((other-buffer
	 (if (featurep 'xemacs)
	     (local-variable-p 'minor-mode-map-alist nil t)
	   (local-variable-if-set-p 'minor-mode-map-alist))))
    ;; for current buffer and buffers to be created in the future.
    ;; substantially the same job as viper-harness-minor-mode does.
    (viper-normalize-minor-mode-map-alist)
    (setq-default minor-mode-map-alist minor-mode-map-alist)
    (when other-buffer
      ;; for buffers which are already created and have
      ;; the minor-mode-map-alist localized by Viper.
      (dolist (buf (buffer-list))
	(with-current-buffer buf
	  (unless (assq 'sumibi-mode minor-mode-map-alist)
	    (setq minor-mode-map-alist
		  (append (list (cons 'sumibi-mode sumibi-mode-map)
				(cons 'sumibi-select-mode
				      sumibi-select-mode-map))
			  minor-mode-map-alist)))
	  (viper-normalize-minor-mode-map-alist))))))

(defun sumibi-viper-init-function ()
  (sumibi-viper-normalize-map)
  (remove-hook 'sumibi-mode-hook 'sumibi-viper-init-function))


;;;
;;; human interface
;;;
(define-key sumibi-mode-map sumibi-rK-trans-key 'sumibi-rK-trans)
(define-key sumibi-mode-map "\M-j" 'sumibi-rHkA-trans)
(or (assq 'sumibi-mode minor-mode-map-alist)
    (setq minor-mode-map-alist
	  (append (list 
		   (cons 'sumibi-mode         sumibi-mode-map))
		  minor-mode-map-alist)))



;; sumibi-mode $B$N>uBVJQ994X?t(B
;;  $B@5$N0z?t$N>l9g!">o$K(B sumibi-mode $B$r3+;O$9$k(B
;;  {$BIi(B,0}$B$N0z?t$N>l9g!">o$K(B sumibi-mode $B$r=*N;$9$k(B
;;  $B0z?tL5$7$N>l9g!"(Bsumibi-mode $B$r%H%0%k$9$k(B

;; buffer $BKh$K(B sumibi-mode $B$rJQ99$9$k(B
(defun sumibi-mode (&optional arg)
  "Sumibi mode $B$O(B $B%m!<%^;z$+$iD>@\4A;zJQ49$9$k$?$a$N(B minor mode $B$G$9!#(B
$B0z?t$K@5?t$r;XDj$7$?>l9g$O!"(BSumibi mode $B$rM-8z$K$7$^$9!#(B

Sumibi $B%b!<%I$,M-8z$K$J$C$F$$$k>l9g(B \\<sumibi-mode-map>\\[sumibi-rK-trans] $B$G(B
point $B$+$i9TF,J}8~$KF1<o$NJ8;zNs$,B3$/4V$r4A;zJQ49$7$^$9!#(B

$BF1<o$NJ8;zNs$H$O0J2<$N$b$N$r;X$7$^$9!#(B
$B!&H>3Q%+%?%+%J$H(Bsumibi-stop-chars $B$K;XDj$7$?J8;z$r=|$/H>3QJ8;z(B
$B!&4A;z$r=|$/A43QJ8;z(B"
  (interactive "P")
  (sumibi-mode-internal arg nil))

;; $BA4%P%C%U%!$G(B sumibi-mode $B$rJQ99$9$k(B
(defun global-sumibi-mode (&optional arg)
  "Sumibi mode $B$O(B $B%m!<%^;z$+$iD>@\4A;zJQ49$9$k$?$a$N(B minor mode $B$G$9!#(B
$B0z?t$K@5?t$r;XDj$7$?>l9g$O!"(BSumibi mode $B$rM-8z$K$7$^$9!#(B

Sumibi $B%b!<%I$,M-8z$K$J$C$F$$$k>l9g(B \\<sumibi-mode-map>\\[sumibi-rK-trans] $B$G(B
point $B$+$i9TF,J}8~$KF1<o$NJ8;zNs$,B3$/4V$r4A;zJQ49$7$^$9!#(B

$BF1<o$NJ8;zNs$H$O0J2<$N$b$N$r;X$7$^$9!#(B
$B!&H>3Q%+%?%+%J$H(Bsumibi-stop-chars $B$K;XDj$7$?J8;z$r=|$/H>3QJ8;z(B
$B!&4A;z$r=|$/A43QJ8;z(B"
  (interactive "P")
  (sumibi-mode-internal arg t))


;; sumibi-mode $B$rJQ99$9$k6&DL4X?t(B
(defun sumibi-mode-internal (arg global)
  (or (local-variable-p 'sumibi-mode (current-buffer))
      (make-local-variable 'sumibi-mode))
  (if global
      (progn
	(setq-default sumibi-mode (if (null arg) (not sumibi-mode)
				    (> (prefix-numeric-value arg) 0)))
	(sumibi-kill-sumibi-mode))
    (setq sumibi-mode (if (null arg) (not sumibi-mode)
			(> (prefix-numeric-value arg) 0))))
  (when sumibi-use-viper
    (add-hook 'sumibi-mode-hook 'sumibi-viper-init-function))
  (when sumibi-mode (run-hooks 'sumibi-mode-hook)))


;; buffer local $B$J(B sumibi-mode $B$r:o=|$9$k4X?t(B
(defun sumibi-kill-sumibi-mode ()
  (let ((buf (buffer-list)))
    (while buf
      (set-buffer (car buf))
      (kill-local-variable 'sumibi-mode)
      (setq buf (cdr buf)))))


;; $BA4%P%C%U%!$G(B sumibi-input-mode $B$rJQ99$9$k(B
(defun sumibi-input-mode (&optional arg)
  "$BF~NO%b!<%IJQ99(B"
  (interactive "P")
  (if (< 0 arg)
      (setq sumibi-mode t)
    (setq sumibi-mode nil)))


;; input method $BBP1~(B
(defun sumibi-activate (&rest arg)
  (sumibi-input-mode 1))
(defun sumibi-inactivate (&rest arg)
  (sumibi-input-mode -1))
(register-input-method
 "japanese-sumibi" "Japanese" 'sumibi-activate
 "" "Roman -> Kanji&Kana"
 nil)

;; input-method $B$H$7$FEPO?$9$k!#(B
(set-language-info "Japanese" 'input-method "japanese-sumibi")
(setq default-input-method "japanese-sumibi")

(defconst sumibi-version
  " $Date: 2005/10/01 14:36:34 $ on CVS " ;;VERSION;;
  )
(defun sumibi-version (&optional arg)
  "$BF~NO%b!<%IJQ99(B"
  (interactive "P")
  (message sumibi-version))
(provide 'sumibi)
