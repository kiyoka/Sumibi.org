;;;-*- mode: lisp-interaction; syntax: elisp -*-;;;
;;
;; "sumibi.el" is a client for Sumibi server.
;;
;;   Copyright (C) 2002,2003,2004,2005 Kiyoka Nishyama
;;   This program was derived from yc.el(auther: knak)
;;
;;     $Date: 2005/02/03 13:19:08 $
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
  "Sumibi$B%5!<%P!<$H8r49$9$k$H$-$NJ8;z%(%s%3!<%I$r;XDj$9$k!#(B"
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
  (let (
	(result '()))

    (message "Requesting to sumibi server...")
    (setq result
	  (read
	   (shell-command-to-string
	    (concat
	     "wget"
	     " "
	     "--non-verbose"
	     " "
	     sumibi-server-url
	     " "
	     (format "--post-data='string=%s&encode=%S'" yomi sumibi-server-encode)
	     " "
	     "--output-document=-"
	     " "
	     ))))
    result))


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

      (sumibi-debug-print (format "henkan-input :%s\n"  yomi))
      (sumibi-debug-print (format "henkan-result:%S\n" henkan-list))

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
	 (setq sumibi-henkan-mode nil)) ))))


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
  )

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
(provide 'sumibi)
