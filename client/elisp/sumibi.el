;;;-*- mode: lisp-interaction; syntax: elisp -*-;;;
;;
;; "sumibi.el" is a client for Sumibi server.
;;
;;   Copyright (C) 2002,2003,2004,2005 Kiyoka Nishyama
;;   This program was derived from yc.el(auther: knak)
;;
;;     $Date: 2005/01/15 14:59:29 $
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

(defcustom sumibi-server-url "https://sumibi.dyndns.org/cgi-bin/sumibi.cgi"
  "Sumibi$B%5!<%P!<$N(BURL$B$r;XDj$9$k!#(B"
  :type  'string
  :group 'sumibi)

(defcustom sumibi-stop-chars "(){}<>"
  "*$B4A;zJQ49J8;zNs$r<h$j9~$`;~$KJQ49HO0O$K4^$a$J$$J8;z$r@_Dj$9$k(B"
  :type  'string
  :group 'sumibi)


(defvar sumibi-mode nil         "$B4A;zJQ49%H%0%kJQ?t(B")
(or (assq 'sumibi-mode minor-mode-alist)
    (setq minor-mode-alist (cons '(sumibi-mode " sumibi") minor-mode-alist)))


;; $B%m!<%^;z4A;zJQ49;~!"BP>]$H$9$k%m!<%^;z$r@_Dj$9$k$?$a$NJQ?t(B
(defvar sumibi-skip-chars nil)
(defvar sumibi-mode-map (make-sparse-keymap)         "$B4A;zJQ49%H%0%k%^%C%W(B")

(defvar sumibi-rK-trans-key "\C-j"
  "*$B4A;zJQ49%-!<$r@_Dj$9$k(B")


;; $B%m!<%^;z4A;zJQ494X?t(B
(defun sumibi-rK-trans ()
  "$B%m!<%^;z4A;zJQ49$r$9$k!#(B
$B!&%+!<%=%k$+$i9TF,J}8~$K%m!<%^;zNs$,B3$/HO0O$G%m!<%^;z4A;zJQ49$r9T$&!#(B"
  (interactive)
;  (print last-command)			; DEBUG
  (cond

   (sumibi-henkan-mode
    ;; $BJQ49Cf$K8F$P$l$?$i(B sumibi-henkan-mode-map $B$KDj5A$5$l$F$$$k4X?t$r8F$V(B
    (setq sumibi-repeat (if (eq last-command 'sumibi-rK-trans) (1+ sumibi-repeat) 0))
    (funcall (lookup-key sumibi-henkan-mode-map sumibi-rK-trans-key))
    (if (and (not sumibi-select-mode) (>= sumibi-repeat sumibi-select-count))
	(sumibi-select)
      (sumibi-post-command-function)))

   ((or (eq last-command 'sumibi-kakutei)
	(eq last-command 'sumibi-cancel))	; reconversion after sumibi-cancel
    ;; $B3NDjD>8e$K8F$P$l$?$i:FJQ49(B
    (delete-region sumibi-fence-start sumibi-fence-end)
    (insert sumibi-fence-yomi)
    (set-marker sumibi-fence-end (point))
    (sumibi-henkan-region sumibi-fence-start sumibi-fence-end))

   (t
    ;; $B>e5-0J30$G8F$P$l$?$i?75,JQ49(B
    (setq sumibi-repeat 0)
    (cond

     ((eq ?\) (preceding-char))
      (call-interactively 'eval-print-last-sexp))

     ((eq (sumibi-char-charset (preceding-char)) 'ascii)
      ;; $B%+!<%=%kD>A0$,(B alphabet $B$@$C$?$i(B
      (let ((end (point))
	    (gap (sumibi-skip-chars-backward)))
	(goto-char end)
	(when (/= gap 0)
	  (setq sumibi-fence-yomi (buffer-substring (+ end gap) end))
	  (if (not (string= sumibi-fence-yomi ""))
	      (setq sumibi-henkan-mode t))
	  (sumibi-henkan-region (+ end gap) end))))

     ((sumibi-nkanji (preceding-char))
      ;; $B%+!<%=%kD>A0$,(B $BA43Q$G4A;z0J30(B $B$@$C$?$i(B
      (let ((end (point))
	    (start (let* ((pos (or (and (mark-marker)
					(marker-position (mark-marker))) 1))
			  (mark-check (>= pos (point))))
		     (while (and (or mark-check (< pos (point)))
				 (sumibi-nkanji (preceding-char)))
		       (backward-char))
		     (point))))
	(sumibi-henkan-region start end) ))))))


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
  "YC mode $B$O(B $B%m!<%^;z$+$iD>@\4A;zJQ49$9$k$?$a$N(B minor mode $B$G$9!#(B
$B0z?t$K@5?t$r;XDj$7$?>l9g$O!"(BYC mode $B$rM-8z$K$7$^$9!#(B

YC $B%b!<%I$,M-8z$K$J$C$F$$$k>l9g(B \\<sumibi-mode-map>\\[sumibi-rK-trans] $B$G(B
point $B$+$i9TF,J}8~$KF1<o$NJ8;zNs$,B3$/4V$r4A;zJQ49$7$^$9!#(B

$BF1<o$NJ8;zNs$H$O0J2<$N$b$N$r;X$7$^$9!#(B
$B!&H>3Q%+%?%+%J$H(Bsumibi-stop-chars $B$K;XDj$7$?J8;z$r=|$/H>3QJ8;z(B
$B!&4A;z$r=|$/A43QJ8;z(B"
  (interactive "P")
  (sumibi-mode-internal arg nil))

;; $BA4%P%C%U%!$G(B sumibi-mode $B$rJQ99$9$k(B
(defun global-sumibi-mode (&optional arg)
  "YC mode $B$O(B $B%m!<%^;z$+$iD>@\4A;zJQ49$9$k$?$a$N(B minor mode $B$G$9!#(B
$B0z?t$K@5?t$r;XDj$7$?>l9g$O!"(BYC mode $B$rM-8z$K$7$^$9!#(B

YC $B%b!<%I$,M-8z$K$J$C$F$$$k>l9g(B \\<sumibi-mode-map>\\[sumibi-rK-trans] $B$G(B
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
 "$B$"(B" "Romaji -> Kanji&Kana"
 nil)

;; input-method $B$H$7$FEPO?$9$k!#(B
(set-language-info "Japanese" 'input-method "japanese-sumibi")
(setq default-input-method "japanese-sumibi")

(defconst sumibi-version "0.0.1")
(provide 'sumibi)
