;;;-*- mode: lisp-interaction; syntax: elisp -*-;;;
;;
;; "sumibi.el" is a client for Sumibi server.
;;
;;   Copyright (C) 2002,2003,2004,2005 Kiyoka Nishiyama
;;   This program was derived from yc.el-4.0.13(auther: knak)
;;
;;     $Date: 2005/11/10 13:57:26 $
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

(defcustom sumibi-server-url "https://sumibi.org/cgi-bin/sumibi/testing/sumibi.cgi"
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

(defcustom sumibi-realtime-guide-running-seconds 60
  "$B%j%"%k%?%$%`%,%$%II=<($N7QB3;~4V(B($BIC?t(B)$B!&%<%m$G%,%$%II=<(5!G=$,L58z$K$J$j$^$9!#(B"
  :type  'integer
  :group 'sumibi)

(defcustom sumibi-realtime-guide-interval  0.5
  "$B%j%"%k%?%$%`%,%$%II=<($r99?7$9$k;~4V4V3V(B"
  :type  'integer
  :group 'sumibi)


(defface sumibi-guide-face
  '((((class color) (background light)) (:background "#E0E0E0" :foreground "#F03030")))
  "$B%j%"%k%?%$%`%,%$%I$N%U%'%$%9(B($BAu>~!"?'$J$I$N;XDj(B)"
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


(defvar sumibi-roman->kana-table
  '(("kkya" . "$B$C$-$c(B")
    ("kkyu" . "$B$C$-$e(B")
    ("kkyo" . "$B$C$-$g(B")
    ("ggya" . "$B$C$.$c(B")
    ("ggyu" . "$B$C$.$e(B")
    ("ggyo" . "$B$C$.$g(B")
    ("sshi" . "$B$C$7(B")
    ("ssha" . "$B$C$7$c(B")
    ("sshu" . "$B$C$7$e(B")
    ("sshe" . "$B$C$7$'(B")
    ("ssho" . "$B$C$7$g(B")
    ("cchi" . "$B$C$A(B")
    ("ccha" . "$B$C$A$c(B")
    ("cchu" . "$B$C$A$e(B")
    ("cche" . "$B$C$A$'(B")
    ("ccho" . "$B$C$A$g(B")
    ("ddya" . "$B$C$B$c(B")
    ("ddyu" . "$B$C$B$e(B")
    ("ddye" . "$B$C$B$'(B")
    ("ddyo" . "$B$C$B$g(B")
    ("ttsu" . "$B$C$D(B")
    ("hhya" . "$B$C$R$c(B")
    ("hhyu" . "$B$C$R$e(B")
    ("hhyo" . "$B$C$R$g(B")
    ("bbya" . "$B$C$S$c(B")
    ("bbyu" . "$B$C$S$e(B")
    ("bbyo" . "$B$C$S$g(B")
    ("ppya" . "$B$C$T$c(B")
    ("ppyu" . "$B$C$T$e(B")
    ("ppyo" . "$B$C$T$g(B")
    ("rrya" . "$B$C$j$c(B")
    ("rryu" . "$B$C$j$e(B")
    ("rryo" . "$B$C$j$g(B")
    ("ddyi" . "$B$C$G$#(B")
    ("ddhi" . "$B$C$G$#(B")
    ("xtsu" . "$B$C(B")
    ("ttya" . "$B$C$A$c(B")
    ("ttyi" . "$B$C$A(B")
    ("ttyu" . "$B$C$A$e(B")
    ("ttye" . "$B$C$A$'(B")
    ("ttyo" . "$B$C$A$g(B")
    ("kya" . "$B$-$c(B")
    ("kyu" . "$B$-$e(B")
    ("kyo" . "$B$-$g(B")
    ("gya" . "$B$.$c(B")
    ("gyu" . "$B$.$e(B")
    ("gyo" . "$B$.$g(B")
    ("shi" . "$B$7(B")
    ("sha" . "$B$7$c(B")
    ("shu" . "$B$7$e(B")
    ("she" . "$B$7$'(B")
    ("sho" . "$B$7$g(B")
    ("chi" . "$B$A(B")
    ("cha" . "$B$A$c(B")
    ("chu" . "$B$A$e(B")
    ("che" . "$B$A$'(B")
    ("cho" . "$B$A$g(B")
    ("dya" . "$B$B$c(B")
    ("dyu" . "$B$B$e(B")
    ("dye" . "$B$B$'(B")
    ("dyo" . "$B$B$g(B")
    ("vvu" . "$B$C$&!+(B")
    ("vva" . "$B$C$&!+$!(B")
    ("vvi" . "$B$C$&!+$#(B")
    ("vve" . "$B$C$&!+$'(B")
    ("vvo" . "$B$C$&!+$)(B")
    ("kka" . "$B$C$+(B")
    ("gga" . "$B$C$,(B")
    ("kki" . "$B$C$-(B")
    ("ggi" . "$B$C$.(B")
    ("kku" . "$B$C$/(B")
    ("ggu" . "$B$C$0(B")
    ("kke" . "$B$C$1(B")
    ("gge" . "$B$C$2(B")
    ("kko" . "$B$C$3(B")
    ("ggo" . "$B$C$4(B")
    ("ssa" . "$B$C$5(B")
    ("zza" . "$B$C$6(B")
    ("jji" . "$B$C$8(B")
    ("jja" . "$B$C$8$c(B")
    ("jju" . "$B$C$8$e(B")
    ("jje" . "$B$C$8$'(B")
    ("jjo" . "$B$C$8$g(B")
    ("ssu" . "$B$C$9(B")
    ("zzu" . "$B$C$:(B")
    ("sse" . "$B$C$;(B")
    ("zze" . "$B$C$<(B")
    ("sso" . "$B$C$=(B")
    ("zzo" . "$B$C$>(B")
    ("tta" . "$B$C$?(B")
    ("dda" . "$B$C$@(B")
    ("ddi" . "$B$C$B(B")
    ("ddu" . "$B$C$E(B")
    ("tte" . "$B$C$F(B")
    ("dde" . "$B$C$G(B")
    ("tto" . "$B$C$H(B")
    ("ddo" . "$B$C$I(B")
    ("hha" . "$B$C$O(B")
    ("bba" . "$B$C$P(B")
    ("ppa" . "$B$C$Q(B")
    ("hhi" . "$B$C$R(B")
    ("bbi" . "$B$C$S(B")
    ("ppi" . "$B$C$T(B")
    ("ffu" . "$B$C$U(B")
    ("ffa" . "$B$C$U$!(B")
    ("ffi" . "$B$C$U$#(B")
    ("ffe" . "$B$C$U$'(B")
    ("ffo" . "$B$C$U$)(B")
    ("bbu" . "$B$C$V(B")
    ("ppu" . "$B$C$W(B")
    ("hhe" . "$B$C$X(B")
    ("bbe" . "$B$C$Y(B")
    ("ppe" . "$B$C$Z(B")
    ("hho" . "$B$C$[(B")
    ("bbo" . "$B$C$\(B")
    ("ppo" . "$B$C$](B")
    ("yya" . "$B$C$d(B")
    ("yyu" . "$B$C$f(B")
    ("yyo" . "$B$C$h(B")
    ("rra" . "$B$C$i(B")
    ("rri" . "$B$C$j(B")
    ("rru" . "$B$C$k(B")
    ("rre" . "$B$C$l(B")
    ("rro" . "$B$C$m(B")
    ("tsu" . "$B$D(B")
    ("nya" . "$B$K$c(B")
    ("nyu" . "$B$K$e(B")
    ("nyo" . "$B$K$g(B")
    ("hya" . "$B$R$c(B")
    ("hyu" . "$B$R$e(B")
    ("hyo" . "$B$R$g(B")
    ("bya" . "$B$S$c(B")
    ("byu" . "$B$S$e(B")
    ("byo" . "$B$S$g(B")
    ("pya" . "$B$T$c(B")
    ("pyu" . "$B$T$e(B")
    ("pyo" . "$B$T$g(B")
    ("mya" . "$B$_$c(B")
    ("myu" . "$B$_$e(B")
    ("myo" . "$B$_$g(B")
    ("xya" . "$B$c(B")
    ("xyu" . "$B$e(B")
    ("xyo" . "$B$g(B")
    ("rya" . "$B$j$c(B")
    ("ryu" . "$B$j$e(B")
    ("ryo" . "$B$j$g(B")
    ("xwa" . "$B$n(B")
    ("dyi" . "$B$G$#(B")
    ("thi" . "$B$F$#(B")
    ("hhu" . "$B$C$U(B")
    ("shu" . "$B$7$e(B")
    ("chu" . "$B$A$e(B")
    ("sya" . "$B$7$c(B")
    ("syu" . "$B$7$e(B")
    ("sye" . "$B$7$'(B")
    ("syo" . "$B$7$g(B")
    ("jya" . "$B$8$c(B")
    ("jyu" . "$B$8$e(B")
    ("jye" . "$B$8$'(B")
    ("jyo" . "$B$8$g(B")
    ("zya" . "$B$8$c(B")
    ("zyu" . "$B$8$e(B")
    ("zye" . "$B$8$'(B")
    ("zyo" . "$B$8$g(B")
    ("tya" . "$B$A$c(B")
    ("tyi" . "$B$A(B")
    ("tyu" . "$B$A$e(B")
    ("tye" . "$B$A$'(B")
    ("tyo" . "$B$A$g(B")
    ("dhi" . "$B$G$#(B")
    ("xtu" . "$B$C(B")
    ("xa" . "$B$!(B")
    ("xi" . "$B$#(B")
    ("xu" . "$B$%(B")
    ("vu" . "$B$&!+(B")
    ("va" . "$B$&!+$!(B")
    ("vi" . "$B$&!+$#(B")
    ("ve" . "$B$&!+$'(B")
    ("vo" . "$B$&!+$)(B")
    ("xe" . "$B$'(B")
    ("xo" . "$B$)(B")
    ("ka" . "$B$+(B")
    ("ga" . "$B$,(B")
    ("ki" . "$B$-(B")
    ("gi" . "$B$.(B")
    ("ku" . "$B$/(B")
    ("gu" . "$B$0(B")
    ("ke" . "$B$1(B")
    ("ge" . "$B$2(B")
    ("ko" . "$B$3(B")
    ("go" . "$B$4(B")
    ("sa" . "$B$5(B")
    ("za" . "$B$6(B")
    ("ji" . "$B$8(B")
    ("ja" . "$B$8$c(B")
    ("ju" . "$B$8$e(B")
    ("je" . "$B$8$'(B")
    ("jo" . "$B$8$g(B")
    ("su" . "$B$9(B")
    ("zu" . "$B$:(B")
    ("se" . "$B$;(B")
    ("ze" . "$B$<(B")
    ("so" . "$B$=(B")
    ("zo" . "$B$>(B")
    ("ta" . "$B$?(B")
    ("da" . "$B$@(B")
    ("di" . "$B$B(B")
    ("tt" . "$B$C(B")
    ("du" . "$B$E(B")
    ("te" . "$B$F(B")
    ("de" . "$B$G(B")
    ("to" . "$B$H(B")
    ("do" . "$B$I(B")
    ("na" . "$B$J(B")
    ("ni" . "$B$K(B")
    ("nu" . "$B$L(B")
    ("ne" . "$B$M(B")
    ("no" . "$B$N(B")
    ("ha" . "$B$O(B")
    ("ba" . "$B$P(B")
    ("pa" . "$B$Q(B")
    ("hi" . "$B$R(B")
    ("bi" . "$B$S(B")
    ("pi" . "$B$T(B")
    ("fu" . "$B$U(B")
    ("fa" . "$B$U$!(B")
    ("fi" . "$B$U$#(B")
    ("fe" . "$B$U$'(B")
    ("fo" . "$B$U$)(B")
    ("bu" . "$B$V(B")
    ("pu" . "$B$W(B")
    ("he" . "$B$X(B")
    ("be" . "$B$Y(B")
    ("pe" . "$B$Z(B")
    ("ho" . "$B$[(B")
    ("bo" . "$B$\(B")
    ("po" . "$B$](B")
    ("ma" . "$B$^(B")
    ("mi" . "$B$_(B")
    ("mu" . "$B$`(B")
    ("me" . "$B$a(B")
    ("mo" . "$B$b(B")
    ("ya" . "$B$d(B")
    ("yu" . "$B$f(B")
    ("yo" . "$B$h(B")
    ("ra" . "$B$i(B")
    ("ri" . "$B$j(B")
    ("ru" . "$B$k(B")
    ("re" . "$B$l(B")
    ("ro" . "$B$m(B")
    ("wa" . "$B$o(B")
    ("wi" . "$B$p(B")
    ("we" . "$B$q(B")
    ("wo" . "$B$r(B")
    ("n'" . "$B$s(B")
    ("nn" . "$B$s(B")
    ("ca" . "$B$+(B")
    ("ci" . "$B$-(B")
    ("cu" . "$B$/(B")
    ("ce" . "$B$1(B")
    ("co" . "$B$3(B")
    ("si" . "$B$7(B")
    ("ti" . "$B$A(B")
    ("hu" . "$B$U(B")
    ("tu" . "$B$D(B")
    ("zi" . "$B$8(B")
    ("la" . "$B$!(B")
    ("li" . "$B$#(B")
    ("lu" . "$B$%(B")
    ("le" . "$B$'(B")
    ("lo" . "$B$)(B")
    ("a" . "$B$"(B")
    ("i" . "$B$$(B")
    ("u" . "$B$&(B")
    ("e" . "$B$((B")
    ("o" . "$B$*(B")
    ("n" . "$B$s(B")
    ("-" . "$B!<(B")
    ("^" . "$B!<(B")))


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
(defvar sumibi-timer-rest  0)           ; $B$"$H2?2s8F=P$5$l$?$i!"%$%s%?!<%P%k%?%$%^$N8F=P$r;_$a$k$+(B
(defvar sumibi-guide-overlay   nil)     ; $B%j%"%k%?%$%`%,%$%I$K;HMQ$9$k%*!<%P!<%l%$(B


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


;; $B%]!<%?%V%kJ8;zNsCV49(B( Emacs$B$H(BXEmacs$B$NN>J}$GF0$/(B )
(defun sumibi-replace-regexp-in-string (regexp replace str)
  (cond ((featurep 'xemacs)
	 (replace-in-string str regexp replace))
	(t
	 (replace-regexp-in-string regexp replace str))))
	

;; $BCV49%-!<%o!<%I$r2r7h$9$k(B
(defun sumibi-replace-keyword (str)
  (let (
	;; $B2~9T$r0l$D$N%9%Z!<%9$KCV49$7$F!"(B
	;; $B%-!<%o!<%ICV49=hM}$NA0=hM}$H$7$F9TF,$H9TKv$K%9%Z!<%9$rDI2C$9$k!#(B
	(replaced 
	 (concat " " 
		 (sumibi-replace-regexp-in-string 
		  "[\n]"
		  " "
		  str)
		 " ")))

    (mapcar
     (lambda (x)
       (setq replaced 
	     (sumibi-replace-regexp-in-string 
	      (concat " " (car x) " ")
	      (concat " " (cdr x) " ")
	      replaced)))
     sumibi-replace-keyword-list)
    replaced))

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
			  `((j ,(cdr _) 0 0 0))
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
		(spaces      (nth 4 (nth _n x)))
		(insert-word (cadr (nth _n x)))
		(_insert-word
		 ;; $B%9%Z!<%9$,(B2$B8D0J>eF~$l$i$l$?$i!"(B1$B8D$N%9%Z!<%9$rF~$l$k!#(B($BC"$7!"(Bauto-fill-mode$B$,L58z$N>l9g$N$_(B)
		 (if (and (< 1 spaces) (not auto-fill-function))
		     (concat " " insert-word)
		   insert-word))
		(ank-word    (cadr (assoc 'l x)))
		(_     
		 (if (eq cnt sumibi-cand)
		     (progn
		       (insert _insert-word)
		       (message (format "[%s] candidate (%d/%d)" insert-word (+ _n 1) _max))
		       ;; $B%f!<%6!<<-=q$KEPO?$9$k(B
		       (setq sumibi-kakutei-history 
			     (append
			      `((,ank-word . ,insert-word))
			      sumibi-kakutei-history)))
		   (insert _insert-word)))
		(end         (point-marker))
		(ov          (make-overlay start end)))

	   ;; $B3NDjJ8;zNs$N:n@.(B
	   (setq sumibi-last-fix (concat sumibi-last-fix _insert-word))
	   
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
   ;; $B%?%$%^!<%$%Y%s%H$r@_Dj$7$J$$>r7o(B
   ((or
     sumibi-timer
     (> 1 sumibi-realtime-guide-running-seconds)
     ))
   (t
    ;; $B%?%$%^!<%$%Y%s%H4X?t$NEPO?(B
    (progn
      (let 
	  ((ov-point
	    (save-excursion
	      (forward-line 1)
	      (point))))
	  (setq sumibi-guide-overlay
			(make-overlay ov-point ov-point (current-buffer))))
      (setq sumibi-timer
			(run-at-time 0.1 sumibi-realtime-guide-interval
						 'sumibi-realtime-guide)))))

  ;; $B%,%$%II=<(7QB32s?t$N99?7(B
  (when (< 0 sumibi-realtime-guide-running-seconds)
    (setq sumibi-timer-rest  
	  (/ sumibi-realtime-guide-running-seconds
	     sumibi-realtime-guide-interval)))

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
	 (skip-chars
	  (if auto-fill-function
	      ;; auto-fill-mode $B$,M-8z$K$J$C$F$$$k>l9g2~9T$,$"$C$F$b(Bskip$B$rB3$1$k(B
	      (concat sumibi-skip-chars "\n")
	    ;; auto-fill-mode$B$,L58z$N>l9g$O$=$N$^$^(B
	    sumibi-skip-chars))
	    
	 ;; $B%^!<%/$5$l$F$$$k0LCV$r5a$a$k!#(B
	 (pos (or (and (markerp (mark-marker)) (marker-position (mark-marker)))
		  1))

	 ;; $B>r7o$K%^%C%A$9$k4V!"A0J}J}8~$K%9%-%C%W$9$k!#(B
	 (result (save-excursion
		   (skip-chars-backward skip-chars (and (< pos (point)) pos))))
	 (limit-point 0))

    (if auto-fill-function
	;; auto-fill-mode$B$,M-8z$N;~(B
	(progn
	  (save-excursion
	    (backward-paragraph)
	    (when (< 1 (point))
	      (forward-line 1))
	    (goto-char (point-at-bol))
	    (let (
		  (start-point (point)))
	      (setq limit-point
		    (+
		     start-point
		     (skip-chars-forward (concat "\t " sumibi-stop-chars) (point-at-eol))))))

	  (sumibi-debug-print (format "(point) = %d  result = %d  limit-point = %d\n" (point) result limit-point))
	  (sumibi-debug-print (format "a = %d b = %d \n" (+ (point) result) limit-point))

	  ;; $B%Q%i%0%i%U0LCV$G%9%H%C%W$9$k(B
	  (if (< (+ (point) result) limit-point)
	      (- 
	       limit-point
	       (point))
	    result))

      ;; auto-fill-mode$B$,L58z$N;~(B
      (progn
	(save-excursion
	  (goto-char (point-at-bol))
	  (let (
		(start-point (point)))
	    (setq limit-point
		  (+ 
		   start-point
		   (skip-chars-forward (concat "\t " sumibi-stop-chars) (point-at-eol))))))

	(sumibi-debug-print (format "(point) = %d  result = %d  limit-point = %d\n" (point) result limit-point))
	(sumibi-debug-print (format "a = %d b = %d \n" (+ (point) result) limit-point))

	(if (< (+ (point) result) limit-point)
	    ;; $B%$%s%G%s%H0LCV$G%9%H%C%W$9$k!#(B
	    (- 
	     limit-point
	     (point))
	  result)))))

;;;
;;; $B%m!<%+%k$N(BEmacsLisp$B$@$1$GJQ49$9$k=hM}(B
;;;
;; a-list $B$r;H$C$F(B str $B$N@hF,$K3:Ev$9$kJ8;zNs$,$"$k$+D4$Y$k(B
(defun romkan-scan-token (a-list str)
  (let 
      ((result     (substring str 0 1))
       (rest       (substring str 1 (length str)))
       (done       nil))

    (mapcar
     (lambda (x)
       (if (and 
	    (string-match (concat "^" (car x)) str)
	    (not done))
	   (progn
	     (setq done t)
	     (setq result (cdr x))
	     (setq rest   (substring str (length (car x)))))))
     a-list)
    (cons result rest)))


;; $B$+$J(B<->$B%m!<%^;zJQ49$9$k(B
(defun romkan-convert (a-list str)
  (cond ((= 0 (length str))
	 "")
	(t
	 (let ((ret (romkan-scan-token a-list str)))
	   (concat
	    (car ret)
	    (romkan-convert a-list (cdr ret)))))))


  
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



(defun sumibi-realtime-guide ()
  "$B%j%"%k%?%$%`$GJQ49Cf$N%,%$%I$r=P$9(B
sumibi-mode$B$,(BON$B$N4VCf8F$S=P$5$l$k2DG=@-$,$"$k!&(B"
  (cond
   ((> 1 sumibi-timer-rest)
    (cancel-timer sumibi-timer)
    (setq sumibi-timer nil)
    (delete-overlay sumibi-guide-overlay))
   (sumibi-guide-overlay
    ;; $B;D$j2s?t$N%G%/%j%a%s%H(B
    (setq sumibi-timer-rest (- sumibi-timer-rest 1))

    (let* (
	   (end (point))
	   (gap (sumibi-skip-chars-backward))
	   (prev-line-existp
	    (not (= (point-at-bol) (point-min))))
	   (next-line-existp
	    (not (= (point-at-eol) (point-max))))
	   (prev-line-point
	    (when prev-line-existp
	      (save-excursion
		(forward-line -1)
		(point))))
	   (next-line-point
	    (when next-line-existp
	      (save-excursion
		(forward-line 1)
		(point))))
	   (disp-point
	    (or next-line-point prev-line-point)))

      (if 
	  (or 
	   (when (fboundp 'minibufferp)
	     (minibufferp))
	   (and
	    (not next-line-point)
	    (not prev-line-point))
	   (= gap 0))
	  ;; $B>e2<%9%Z!<%9$,L5$$(B $B$^$?$O(B $BJQ49BP>]$,L5$7$J$i%,%$%I$OI=<($7$J$$!#(B
	  (overlay-put sumibi-guide-overlay 'before-string "")
	;; $B0UL#$N$"$kF~NO$,8+$D$+$C$?$N$G%,%$%I$rI=<($9$k!#(B
	(let* (
	       (b (+ end gap))
	       (e end)
	       (str (buffer-substring b e))
	       (l (split-string str))
	       (mess
		(mapconcat
		 (lambda (x)
		   (let* ((l (split-string x "\\."))
			  (method
			   (when (< 1 (length l))
			     (cadr l)))
			  (hira
			   (romkan-convert sumibi-roman->kana-table
					   (car l))))
		     (cond
		      ((string-match "[a-z]+" hira)
		       x)
		      ((not method)
		       hira)
		      ((or (string-equal "j" method) (string-equal "h" method))
		       hira)
		      ((or (string-equal "e" method) (string-equal "l" method))
		       (car l))
		      ((string-equal "k" method)
		       hira)
		      (t
		       x))))
		 l
		 " ")))
	  (move-overlay sumibi-guide-overlay 
			disp-point (min (point-max) (+ disp-point 1)) (current-buffer))
	  (overlay-put sumibi-guide-overlay 'before-string mess))))
    (overlay-put sumibi-guide-overlay 'face 'sumibi-guide-face))))


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
      (progn
	(setq inactivate-current-input-method-function 'sumibi-inactivate)
	(setq sumibi-mode t))
    (setq inactivate-current-input-method-function nil)
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
  " $Date: 2005/11/10 13:57:26 $ on CVS " ;;VERSION;;
  )
(defun sumibi-version (&optional arg)
  "$BF~NO%b!<%IJQ99(B"
  (interactive "P")
  (message sumibi-version))
(provide 'sumibi)
