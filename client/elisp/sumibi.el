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
  "SumibiサーバーのURLを指定する。"
  :type  'string
  :group 'sumibi)

(defcustom sumibi-stop-chars "(){}<>"
  "*漢字変換文字列を取り込む時に変換範囲に含めない文字を設定する"
  :type  'string
  :group 'sumibi)


(defvar sumibi-mode nil         "漢字変換トグル変数")
(or (assq 'sumibi-mode minor-mode-alist)
    (setq minor-mode-alist (cons '(sumibi-mode " sumibi") minor-mode-alist)))


;; ローマ字漢字変換時、対象とするローマ字を設定するための変数
(defvar sumibi-skip-chars nil)
(defvar sumibi-mode-map (make-sparse-keymap)         "漢字変換トグルマップ")

(defvar sumibi-rK-trans-key "\C-j"
  "*漢字変換キーを設定する")


;; ローマ字漢字変換関数
(defun sumibi-rK-trans ()
  "ローマ字漢字変換をする。
・カーソルから行頭方向にローマ字列が続く範囲でローマ字漢字変換を行う。"
  (interactive)
;  (print last-command)			; DEBUG
  (cond

   (sumibi-henkan-mode
    ;; 変換中に呼ばれたら sumibi-henkan-mode-map に定義されている関数を呼ぶ
    (setq sumibi-repeat (if (eq last-command 'sumibi-rK-trans) (1+ sumibi-repeat) 0))
    (funcall (lookup-key sumibi-henkan-mode-map sumibi-rK-trans-key))
    (if (and (not sumibi-select-mode) (>= sumibi-repeat sumibi-select-count))
	(sumibi-select)
      (sumibi-post-command-function)))

   ((or (eq last-command 'sumibi-kakutei)
	(eq last-command 'sumibi-cancel))	; reconversion after sumibi-cancel
    ;; 確定直後に呼ばれたら再変換
    (delete-region sumibi-fence-start sumibi-fence-end)
    (insert sumibi-fence-yomi)
    (set-marker sumibi-fence-end (point))
    (sumibi-henkan-region sumibi-fence-start sumibi-fence-end))

   (t
    ;; 上記以外で呼ばれたら新規変換
    (setq sumibi-repeat 0)
    (cond

     ((eq ?\) (preceding-char))
      (call-interactively 'eval-print-last-sexp))

     ((eq (sumibi-char-charset (preceding-char)) 'ascii)
      ;; カーソル直前が alphabet だったら
      (let ((end (point))
	    (gap (sumibi-skip-chars-backward)))
	(goto-char end)
	(when (/= gap 0)
	  (setq sumibi-fence-yomi (buffer-substring (+ end gap) end))
	  (if (not (string= sumibi-fence-yomi ""))
	      (setq sumibi-henkan-mode t))
	  (sumibi-henkan-region (+ end gap) end))))

     ((sumibi-nkanji (preceding-char))
      ;; カーソル直前が 全角で漢字以外 だったら
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


;; sumibi-mode の状態変更関数
;;  正の引数の場合、常に sumibi-mode を開始する
;;  {負,0}の引数の場合、常に sumibi-mode を終了する
;;  引数無しの場合、sumibi-mode をトグルする

;; buffer 毎に sumibi-mode を変更する
(defun sumibi-mode (&optional arg)
  "YC mode は ローマ字から直接漢字変換するための minor mode です。
引数に正数を指定した場合は、YC mode を有効にします。

YC モードが有効になっている場合 \\<sumibi-mode-map>\\[sumibi-rK-trans] で
point から行頭方向に同種の文字列が続く間を漢字変換します。

同種の文字列とは以下のものを指します。
・半角カタカナとsumibi-stop-chars に指定した文字を除く半角文字
・漢字を除く全角文字"
  (interactive "P")
  (sumibi-mode-internal arg nil))

;; 全バッファで sumibi-mode を変更する
(defun global-sumibi-mode (&optional arg)
  "YC mode は ローマ字から直接漢字変換するための minor mode です。
引数に正数を指定した場合は、YC mode を有効にします。

YC モードが有効になっている場合 \\<sumibi-mode-map>\\[sumibi-rK-trans] で
point から行頭方向に同種の文字列が続く間を漢字変換します。

同種の文字列とは以下のものを指します。
・半角カタカナとsumibi-stop-chars に指定した文字を除く半角文字
・漢字を除く全角文字"
  (interactive "P")
  (sumibi-mode-internal arg t))


;; sumibi-mode を変更する共通関数
(defun sumibi-mode-internal (arg global)
  )

;; 全バッファで sumibi-input-mode を変更する
(defun sumibi-input-mode (&optional arg)
  "入力モード変更"
  (interactive "P")
  (if (< 0 arg)
      (setq sumibi-mode t)
    (setq sumibi-mode nil)))


;; input method 対応
(defun sumibi-activate (&rest arg)
  (sumibi-input-mode 1))
(defun sumibi-inactivate (&rest arg)
  (sumibi-input-mode -1))
(register-input-method
 "japanese-sumibi" "Japanese" 'sumibi-activate
 "あ" "Romaji -> Kanji&Kana"
 nil)

;; input-method として登録する。
(set-language-info "Japanese" 'input-method "japanese-sumibi")
(setq default-input-method "japanese-sumibi")

(defconst sumibi-version "0.0.1")
(provide 'sumibi)
