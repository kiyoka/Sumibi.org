;;;-*- mode: lisp-interaction; syntax: elisp -*-;;;
;;
;; "sumibi.el" is a client for Sumibi server.
;;
;;   Copyright (C) 2002,2003,2004,2005 Kiyoka Nishyama
;;   This program was derived from yc.el(auther: knak)
;;
;;     $Date: 2005/02/09 11:01:32 $
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

;;; $BK\%P!<%8%g%s(B 0.1.0 $B$O%"%k%U%!HG$G$9!#(B
;;; $B5!G=E*$KIT==J,$J$H$3$m$,$"$j$^$9!#8fN;>5$/$@$5$$!#(B
;;; $BITL@$JE@$d2~A1$7$?$$E@$,$"$l$P(BSumibi$B$N%a!<%j%s%0%j%9%H$K;22C$7$F(B
;;; $B%U%#!<%I%P%C%/$r$*$M$,$$$7$^$9!#(B
;;;
;;; $B$^$?!"(BSumibi$B$K6=L#$r;}$C$F$$$?$@$$$?J}$O%W%m%0%i%^$+$I$&$+$K$+$+$o$i$:(B
;;; $B5$7Z$K%W%m%8%'%/%H$K;22C$7$F$/$@$5$$!#(B
;;;
;;; $BK\%P!<%8%g%s$K$O<!$N$h$&$J@)8B$,$"$j$^$9!#(B
;;;   1. $BK\%Q%C%1!<%8$K$O(BEmacs$BMQ$N%/%i%$%"%s%H$N$_4^$^$l$F$$$^$9!#(B
;;;      1) sumibi.org$B$GF0:n$7$F$$$k(BSumibi Server$B$K@\B3$7$FMxMQ$7$^$9!#(B 
;;;      2) SSL$B>ZL@=q$r;HMQ$7!":GDc8B$N%;%-%e%j%F%#!<$O3NJ]$7$F$$$^$9!#(B 
;;;         SSL$B>ZL@=q$O(B CAcert( http://www.cacert.org/ )$B$N$b$N$r;H$C$F$$$^$9!#(B
;;;      3) Sumibi Server$BB&$b%"%k%U%!HG$N$?$a!"IT0BDj$G$"$k$3$H$r8fN;>5$/$@$5$$!#(B
;;;      4) Sumibi Server$BB&$N%=!<%9%3!<%I$b(BGPL$B$G$"$j!"(Bsourceforge.jp$B$N(BCVS$B$G8x3+$5$l$F$$$^$9!#(B
;;;
;;;   2. $BJQ498uJd$rA*Br$9$kItJ,$r$O$8$a!"B?$/$N5!G=$,<BAu$5$l$F$$$^$;$s!#(B
;;;
;;;   3.$B%P%0$,Bt;3$"$j$^$9!#(B^_^;
;;;

;;; $B%$%s%9%H!<%k(B
;;;   1. Emacs$B$K(Bapel-10.6$B0J>e$r%$%s%9%H!<%k$7$^$9!#(B
;;;
;;;   2. sumibi.el$B$r(BEmacs$B$N%m!<%I%Q%9$K%3%T!<$7$^$9!#(B
;;;
;;;   3. CAcert.crt$B$rE,Ev$J>l=j$K%3%T!<$7$^$9!#(B ($BNc(B: /home/xxxx/emacs $B%G%#%l%/%H%j!<$J$I(B )
;;;
;;;   4. wget 1.9.1$B0J>e$r(BSSL$B5!G=$rM-8z$K$7$F%S%k%I$7!"%$%s%9%H!<%k$7$^$9!#(B
;;;      (cygwin$B$KF~$C$F$$$k(Bwget$B$,$=$N$^$^MxMQ$G$-$k$3$H$r3NG'$7$F$$$^$9!#(B)
;;;
;;;   5. .emacs$B$K<!$N%3!<%I$rDI2C$7$^$9!#(B
;;;      (setq sumibi-debug t)		  ; $B%G%P%C%0%U%i%0(BON ( $B%G%P%C%0%a%C%;!<%8MM$K(B *sumibi-debug*$B$H$$$&%P%C%U%!$,:n$i$l$k(B )
;;;      (setq sumibi-server-cert-file "/home/xxxx/emacs/CAcert.crt")  ; CAcert.crt$B$NJ]B8%Q%9(B
;;;      (load "sumibi.el")
;;;      (global-sumibi-mode 1)
;;;
;;;      $B"(JQ?t(B sumibi-server-cert-file $B$r(B nil $B$K$9$k$H(BSSL$B>ZL@=q$rMxMQ$7$J$/$F$bDL?.$G$-$^$9!#(B
;;;        $BC"$7!"$3$N@_Dj$G$O%;%-%e%j%F%#!<$,<e$/$J$j$^$9$N$G!"%m!<%+%k$G(BSumibi Server$B$rN)$F$J$$8B$j$O(B
;;;        $B$*$9$9$a$7$^$;$s!#(B
;;;
;;;   6. Emacs$B$r:F5/F0$7!"(BEmacs$B$N%a%K%e!<%P!<$K(B "Sumibi"$B$NJ8;z$,I=<($5$l$l$P@.8y$G$9!#(B
;;;

;;; $B;H$$$+$?(B
;;;   1. $B4pK\E*$J;H$$$+$?(B
;;;   $B%a%K%e!<%P!<$K(B"Sumibi"$B$NJ8;z$,=P$F$$$l$P(B C-J$B%-!<$G$$$-$J$jJQ49$G$-$^$9!#(B
;;;    ($BF~NONc(B)  sumibi de oishii yakiniku wo tabeyou . [C-j]
;;;    ($B7k2L(B  )  $BC:2P$G$*$$$7$$>FFy$r?)$Y$h$&!#(B
;;;
;;;   2. '/' $BJ8;z$GJQ49HO0O$r8BDj$9$k!#(B
;;;    ($BF~NONc(B)  sumibi de oishii /yakiniku wo tabeyou . [C-j]
;;;    ($B7k2L(B  )  sumibi de oishii $B>FFy$r?)$Y$h$&!#(B
;;;
;;;   3. .h $B$H(B .k $B%a%=%C%I$r$R$i$,$J!&%+%?%+%J$K8GDj$9$k!#(B
;;;    ($BF~NONc(B)  sumibi.h de oishii.k yakiniku wo tabeyou . [C-j]
;;;    ($B7k2L(B  ) $B$9$_$S$G%*%$%7%$>FFy$r?)$Y$h$&!#(B
;;;

;;; $BJQ49$N%3%D(B
;;;   1. $B$J$k$Y$/D9$$J8>O$GJQ49$9$k!#(B
;;;     Sumibi$B%(%s%8%s$O$J$k$Y$/D9$$J8>O$r0l3gJQ49$7$?$[$&$,JQ49@:EY$,>e$,$j$^$9!#(B
;;;     $BM}M3$O!"(BSumibi$B%(%s%8%s$N;EAH$_$K$"$j$^$9!#(B
;;;     Sumibi$B%(%s%8%s$OJ8L.$NCf$NC18l$NNs$S$+$i!"E}7WE*$K$I$NC18l$,Aj1~$7$$$+$rA*Br$7$^$9!#(B
;;;
;;;   2. SKK$B$N<-=q$K4^$^$l$F$$$=$&$JC18l$r;XDj$9$k!#(B
;;;     SKK$B$K47$l$F$$$k?M$G$J$$$H463P$,$D$+$a$J$$$+$b$7$l$^$;$s$,!"(B"$BJQ49@:EY(B"$B$N$h$&$JB?$/$NJ#9g8l(B
;;;     $B$O:G=i$+$i<-=q$K4^$^$l$F$$$k$N$G!"(B"henkanseido"$B$H8@$&6q9g$K;XDj$9$k$H!"3N<B$KJQ49$G$-$^$9!#(B
;;;

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

(defcustom sumibi-server-encode 'euc-jp
  "Sumibi$B%5!<%P!<$H8r49$9$k$H$-$NJ8;z%(%s%3!<%I$r;XDj$9$k!#(B(euc-jp/sjis/utf-8)"
  :type  'string
  :group 'sumibi)

(defcustom sumibi-server-cert-file "/home/xxxx/emacs/CAcert.crt"
  "Sumibi$B%5!<%P!<$HDL?.$9$k;~$N(BSSL$B>ZL@=q%U%!%$%k$r;XDj$9$k!#(B"
  :type  'string
  :group 'sumibi)

(defcustom sumibi-stop-chars "(){}<>"
  "*$B4A;zJQ49J8;zNs$r<h$j9~$`;~$KJQ49HO0O$K4^$a$J$$J8;z$r@_Dj$9$k(B"
  :type  'string
  :group 'sumibi)


(defvar sumibi-mode nil             "$B4A;zJQ49%H%0%kJQ?t(B")
(defvar sumibi-mode-line-string     " Sumibi")
(defvar sumibi-henkan-mode nil      "$B4A;zJQ49%b!<%IJQ?t(B")
(or (assq 'sumibi-mode minor-mode-alist)
    (setq minor-mode-alist (cons '(sumibi-mode sumibi-mode-line-string) minor-mode-alist)))


;; $B%m!<%^;z4A;zJQ49;~!"BP>]$H$9$k%m!<%^;z$r@_Dj$9$k$?$a$NJQ?t(B
(defvar sumibi-skip-chars "a-zA-Z0-9 .,\\-+!\\[\\]?")
(defvar sumibi-mode-map (make-sparse-keymap)         "$B4A;zJQ49%H%0%k%^%C%W(B")
(defvar sumibi-rK-trans-key "\C-j"
  "*$B4A;zJQ49%-!<$r@_Dj$9$k(B")



;;--- $B%G%P%C%0%a%C%;!<%8=PNO(B
(defvar sumibi-debug nil)		; $B%G%P%C%0%U%i%0(B
(defmacro sumibi-debug-print (string)
  `(if sumibi-debug
       (let ((buffer (get-buffer-create "*sumibi-debug*")))
	 (with-current-buffer buffer
	   (goto-char (point-max))
	   (insert ,string)))))


;;; sumibi basic output
(defvar sumibi-fence-yomi nil)		; $BJQ49FI$_(B
(defvar sumibi-fence-start nil)		; fence $B;OC<0LCV(B
(defvar sumibi-fence-end nil)		; fence $B=*C<0LCV(B
(defvar sumibi-henkan-separeter " ")	; fence mode separeter
(defvar sumibi-henkan-buffer nil)	; $BI=<(MQ%P%C%U%!(B
(defvar sumibi-henkan-length nil)	; $BI=<(MQ%P%C%U%!D9(B
(defvar sumibi-henkan-revpos nil)	; $BJ8@a;OC<0LCV(B
(defvar sumibi-henkan-revlen nil)	; $BJ8@aD9(B

;;; sumibi basic local
(defvar sumibi-mark nil)			; $BJ8@aHV9f(B
(defvar sumibi-mark-list nil)		; $BJ8@a8uJdHV9f(B 
(defvar sumibi-mark-max nil)		; $BJ8@a8uJd?t(B
(defvar sumibi-henkan-list nil)		; $BJ8@a%j%9%H(B
(defvar sumibi-kouho-list nil)		; $BJ8@a8uJd%j%9%H(B
(defvar sumibi-repeat 0)			; $B7+$jJV$72s?t(B

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; $BI=<(7O4X?t72(B
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar sumibi-use-fence t)
(defvar sumibi-use-color nil)

;;
;; $B=i4|2=(B
;;
(defun sumibi-init ()
  ;; $B8=>u$O=i4|2=ITMW(B
  t)


;;
;; $B%m!<%^;z$G=q$+$l$?J8>O$r(BSumibi$B%5!<%P!<$r;H$C$FJQ49$9$k(B
;;
(defun sumibi-henkan-request (yomi)
  (sumibi-debug-print (format "henkan-input :%s\n"  yomi))

  (message "Requesting to sumibi server...")
  (let (
	(result 
	 (shell-command-to-string
	  (concat
	   "wget "
	   "--non-verbose "
	   sumibi-server-url " "
	   (format "--post-data='string=%s&encode=%S' " yomi sumibi-server-encode)
	   (when sumibi-server-cert-file
	     (format "--sslcafile='%s' --sslcheckcert=1 " sumibi-server-cert-file))
	   "--output-document=- "
	   ))))
    (sumibi-debug-print (format "henkan-result:%S\n" result))
    (if (eq (string-to-char result) ?\( )
	(progn
	 (message nil)
	 (read result))
      (progn
	(message result)
	nil))))


;; $B%j!<%8%g%s$r%m!<%^;z4A;zJQ49$9$k4X?t(B
;; $B$R$i$,$J4A;zJQ49$b2DG=(B
(defun sumibi-henkan-region (b e)
  "$B;XDj$5$l$?(B region $B$r4A;zJQ49$9$k(B"
  (interactive "*r")
  (sumibi-init)
  (when (/= b e)
    (let* (
	   (yomi (buffer-substring b e))
	   (henkan-list (sumibi-henkan-request yomi)))

      (if henkan-list
	  (condition-case err
	      (progn
		(setq sumibi-henkan-mode t
		      sumibi-fence-start (copy-marker b)
		      sumibi-fence-end (copy-marker e)
		      sumibi-fence-yomi yomi
		      sumibi-henkan-list henkan-list
		      sumibi-mark-list (make-list (length sumibi-henkan-list) 0)
		      sumibi-mark-max (make-list (length sumibi-henkan-list) 0)
		      sumibi-mark 0
		      sumibi-bunsetsu-yomi-list nil))
	    (sumibi-trap-server-down
	     (beep)
	     (message (error-message-string err))
	     (setq sumibi-henkan-mode nil)) )
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



;; $B8=:_$NJQ49%(%j%"$NI=<($r9T$&4X?t(B
(defun sumibi-display-function (b e)
  (setq sumibi-henkan-separeter (if sumibi-use-fence " " ""))
  (when sumibi-henkan-list
    (delete-region b e)
    (when (eq (preceding-char) ?/)
      (delete-region b (- b 1)))
    (let (
	  (henkan-list
	   (mapcar
	    (lambda (x)
	      (if (and
		   (not (eq (preceding-char) ?\ ))
		   (not (eq (point-at-bol) (point)))
		   (eq (sumibi-char-charset (preceding-char)) 'ascii)
		   (eq (sumibi-char-charset (string-to-char (car x))) 'ascii))
		  (insert " "))
	      (insert (car x)))
	    sumibi-henkan-list))))))



;; $B%m!<%^;z4A;zJQ494X?t(B
(defun sumibi-rK-trans ()
  "$B%m!<%^;z4A;zJQ49$r$9$k!#(B
$B!&%+!<%=%k$+$i9TF,J}8~$K%m!<%^;zNs$,B3$/HO0O$G%m!<%^;z4A;zJQ49$r9T$&!#(B"
  (interactive)
;  (print last-command)			; DEBUG
  (cond

   (sumibi-henkan-mode
    ;; $BJQ49Cf$K8F$P$l$?$i(B $B<!$N8uJd$rA*Br$9$k(B
    )
   (t
    ;; $B>e5-0J30$G8F$P$l$?$i?75,JQ49(B
    (cond

     ((eq (sumibi-char-charset (preceding-char)) 'ascii)
      ;; $B%+!<%=%kD>A0$,(B alphabet $B$@$C$?$i(B
      (let ((end (point))
	    (gap (sumibi-skip-chars-backward)))
	(goto-char end)
	(when (/= gap 0)
	  (setq sumibi-fence-yomi (buffer-substring (+ end gap) end))
	  (if (not (string= sumibi-fence-yomi ""))
	      (setq sumibi-henkan-mode t))
	  (sumibi-henkan-region (+ end gap) end))
	(sumibi-display-function (+ end gap) end)
	(setq sumibi-henkan-mode nil)))
	
     ((sumibi-nkanji (preceding-char))
      ;; $B%+!<%=%kD>A0$,(B $BA43Q$G4A;z0J30(B $B$@$C$?$i(B
      )))))

;      (let ((end (point))
;	    (start (let* ((pos (or (and (mark-marker)
;					(marker-position (mark-marker))) 1))
;			  (mark-check (>= pos (point))))
;		     (while (and (or mark-check (< pos (point)))
;				 (sumibi-nkanji (preceding-char)))
;		       (backward-char))
;		     (point))))
;	(sumibi-henkan-region start end) ))))))


;; $BA43Q$G4A;z0J30$NH=Dj4X?t(B
(defun sumibi-nkanji (ch)
  (and (eq (sumibi-char-charset ch) 'japanese-jisx0208)
       (not (string-match "[$B0!(B-$Bt$(B]" (char-to-string ch)))))

;; $B%m!<%^;z4A;zJQ49;~!"JQ49BP>]$H$9$k%m!<%^;z$rFI$_Ht$P$94X?t(B
(defun sumibi-skip-chars-backward ()
  (let ((pos (or (and (markerp (mark-marker)) (marker-position (mark-marker)))
		 1)))
    (skip-chars-backward sumibi-skip-chars (and (< pos (point)) pos))))



;;;
;;; human interface
;;;
(define-key sumibi-mode-map sumibi-rK-trans-key 'sumibi-rK-trans)
(define-key sumibi-mode-map "\M-j" 'sumibi-rHkA-trans)
;(define-key sumibi-mode-map (cond ((vectorp sumibi-rK-trans-key)
;				   (vconcat [?\C-c] sumibi-rK-trans-key))
;				  ((stringp sumibi-rK-trans-key)
;				   (concat "\C-c" sumibi-rK-trans-key)))
;  'sumibi-wclist-mode)
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
	(setq-default sumibi-mode t)
	(sumibi-kill-sumibi-mode))
    (setq sumibi-mode t)))


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
 "" "Romaji -> Kanji&Kana"
 nil)

;; input-method $B$H$7$FEPO?$9$k!#(B
(set-language-info "Japanese" 'input-method "japanese-sumibi")
(setq default-input-method "japanese-sumibi")

(defconst sumibi-version "0.1.0")
(defun sumibi-version (&optional arg)
  "$BF~NO%b!<%IJQ99(B"
  (interactive "P")
  (message sumibi-version))
(provide 'sumibi)
