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

;;;     配布条件: GPL
;;; 最新版配布元: http://sourceforge.jp/projects/sumibi/

;;; 本バージョン 0.1.0 はアルファ版です。
;;; 機能的に不十分なところがあります。御了承ください。
;;; 不明な点や改善したい点があればSumibiのメーリングリストに参加して
;;; フィードバックをおねがいします。
;;;
;;; また、Sumibiに興味を持っていただいた方はプログラマかどうかにかかわらず
;;; 気軽にプロジェクトに参加してください。
;;;
;;; 本バージョンには次のような制限があります。
;;;   1. 本パッケージにはEmacs用のクライアントのみ含まれています。
;;;      1) sumibi.orgで動作しているSumibi Serverに接続して利用します。 
;;;      2) SSL証明書を使用し、最低限のセキュリティーは確保しています。 
;;;         SSL証明書は CAcert( http://www.cacert.org/ )のものを使っています。
;;;      3) Sumibi Server側もアルファ版のため、不安定であることを御了承ください。
;;;      4) Sumibi Server側のソースコードもGPLであり、sourceforge.jpのCVSで公開されています。
;;;
;;;   2. 変換候補を選択する部分をはじめ、多くの機能が実装されていません。
;;;
;;;   3.バグが沢山あります。^_^;
;;;

;;; インストール
;;;   1. Emacsにapel-10.6以上をインストールします。
;;;
;;;   2. sumibi.elをEmacsのロードパスにコピーします。
;;;
;;;   3. CAcert.crtを適当な場所にコピーします。 (例: /home/xxxx/emacs ディレクトリーなど )
;;;
;;;   4. wget 1.9.1以上をSSL機能を有効にしてビルドし、インストールします。
;;;      (cygwinに入っているwgetがそのまま利用できることを確認しています。)
;;;
;;;   5. .emacsに次のコードを追加します。
;;;      (setq sumibi-debug t)		  ; デバッグフラグON ( デバッグメッセージ様に *sumibi-debug*というバッファが作られる )
;;;      (setq sumibi-server-cert-file "/home/xxxx/emacs/CAcert.crt")  ; CAcert.crtの保存パス
;;;      (load "sumibi.el")
;;;      (global-sumibi-mode 1)
;;;
;;;      ※変数 sumibi-server-cert-file を nil にするとSSL証明書を利用しなくても通信できます。
;;;        但し、この設定ではセキュリティーが弱くなりますので、ローカルでSumibi Serverを立てない限りは
;;;        おすすめしません。
;;;
;;;   6. Emacsを再起動し、Emacsのメニューバーに "Sumibi"の文字が表示されれば成功です。
;;;

;;; 使いかた
;;;   1. 基本的な使いかた
;;;   メニューバーに"Sumibi"の文字が出ていれば C-Jキーでいきなり変換できます。
;;;    (入力例)  sumibi de oishii yakiniku wo tabeyou . [C-j]
;;;    (結果  )  炭火でおいしい焼肉を食べよう。
;;;
;;;   2. '/' 文字で変換範囲を限定する。
;;;    (入力例)  sumibi de oishii /yakiniku wo tabeyou . [C-j]
;;;    (結果  )  sumibi de oishii 焼肉を食べよう。
;;;
;;;   3. .h と .k メソッドをひらがな・カタカナに固定する。
;;;    (入力例)  sumibi.h de oishii.k yakiniku wo tabeyou . [C-j]
;;;    (結果  ) すみびでオイシイ焼肉を食べよう。
;;;

;;; 変換のコツ
;;;   1. なるべく長い文章で変換する。
;;;     Sumibiエンジンはなるべく長い文章を一括変換したほうが変換精度が上がります。
;;;     理由は、Sumibiエンジンの仕組みにあります。
;;;     Sumibiエンジンは文脈の中の単語の列びから、統計的にどの単語が相応しいかを選択します。
;;;
;;;   2. SKKの辞書に含まれていそうな単語を指定する。
;;;     SKKに慣れている人でないと感覚がつかめないかもしれませんが、"変換精度"のような多くの複合語
;;;     は最初から辞書に含まれているので、"henkanseido"と言う具合に指定すると、確実に変換できます。
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
  "SumibiサーバーのURLを指定する。"
  :type  'string
  :group 'sumibi)

(defcustom sumibi-server-encode 'euc-jp
  "Sumibiサーバーと交換するときの文字エンコードを指定する。(euc-jp/sjis/utf-8)"
  :type  'string
  :group 'sumibi)

(defcustom sumibi-server-cert-file "/home/xxxx/emacs/CAcert.crt"
  "Sumibiサーバーと通信する時のSSL証明書ファイルを指定する。"
  :type  'string
  :group 'sumibi)

(defcustom sumibi-stop-chars "(){}<>"
  "*漢字変換文字列を取り込む時に変換範囲に含めない文字を設定する"
  :type  'string
  :group 'sumibi)


(defvar sumibi-mode nil             "漢字変換トグル変数")
(defvar sumibi-mode-line-string     " Sumibi")
(defvar sumibi-henkan-mode nil      "漢字変換モード変数")
(or (assq 'sumibi-mode minor-mode-alist)
    (setq minor-mode-alist (cons '(sumibi-mode sumibi-mode-line-string) minor-mode-alist)))


;; ローマ字漢字変換時、対象とするローマ字を設定するための変数
(defvar sumibi-skip-chars "a-zA-Z0-9 .,\\-+!\\[\\]?")
(defvar sumibi-mode-map (make-sparse-keymap)         "漢字変換トグルマップ")
(defvar sumibi-rK-trans-key "\C-j"
  "*漢字変換キーを設定する")



;;--- デバッグメッセージ出力
(defvar sumibi-debug nil)		; デバッグフラグ
(defmacro sumibi-debug-print (string)
  `(if sumibi-debug
       (let ((buffer (get-buffer-create "*sumibi-debug*")))
	 (with-current-buffer buffer
	   (goto-char (point-max))
	   (insert ,string)))))


;;; sumibi basic output
(defvar sumibi-fence-yomi nil)		; 変換読み
(defvar sumibi-fence-start nil)		; fence 始端位置
(defvar sumibi-fence-end nil)		; fence 終端位置
(defvar sumibi-henkan-separeter " ")	; fence mode separeter
(defvar sumibi-henkan-buffer nil)	; 表示用バッファ
(defvar sumibi-henkan-length nil)	; 表示用バッファ長
(defvar sumibi-henkan-revpos nil)	; 文節始端位置
(defvar sumibi-henkan-revlen nil)	; 文節長

;;; sumibi basic local
(defvar sumibi-mark nil)			; 文節番号
(defvar sumibi-mark-list nil)		; 文節候補番号 
(defvar sumibi-mark-max nil)		; 文節候補数
(defvar sumibi-henkan-list nil)		; 文節リスト
(defvar sumibi-kouho-list nil)		; 文節候補リスト
(defvar sumibi-repeat 0)			; 繰り返し回数

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 表示系関数群
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar sumibi-use-fence t)
(defvar sumibi-use-color nil)

;;
;; 初期化
;;
(defun sumibi-init ()
  ;; 現状は初期化不要
  t)


;;
;; ローマ字で書かれた文章をSumibiサーバーを使って変換する
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


;; リージョンをローマ字漢字変換する関数
;; ひらがな漢字変換も可能
(defun sumibi-henkan-region (b e)
  "指定された region を漢字変換する"
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


;; カーソル前の文字種を返却する関数
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



;; 現在の変換エリアの表示を行う関数
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



;; ローマ字漢字変換関数
(defun sumibi-rK-trans ()
  "ローマ字漢字変換をする。
・カーソルから行頭方向にローマ字列が続く範囲でローマ字漢字変換を行う。"
  (interactive)
;  (print last-command)			; DEBUG
  (cond

   (sumibi-henkan-mode
    ;; 変換中に呼ばれたら 次の候補を選択する
    )
   (t
    ;; 上記以外で呼ばれたら新規変換
    (cond

     ((eq (sumibi-char-charset (preceding-char)) 'ascii)
      ;; カーソル直前が alphabet だったら
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
      ;; カーソル直前が 全角で漢字以外 だったら
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


;; 全角で漢字以外の判定関数
(defun sumibi-nkanji (ch)
  (and (eq (sumibi-char-charset ch) 'japanese-jisx0208)
       (not (string-match "[亜-瑤]" (char-to-string ch)))))

;; ローマ字漢字変換時、変換対象とするローマ字を読み飛ばす関数
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


;; sumibi-mode の状態変更関数
;;  正の引数の場合、常に sumibi-mode を開始する
;;  {負,0}の引数の場合、常に sumibi-mode を終了する
;;  引数無しの場合、sumibi-mode をトグルする

;; buffer 毎に sumibi-mode を変更する
(defun sumibi-mode (&optional arg)
  "Sumibi mode は ローマ字から直接漢字変換するための minor mode です。
引数に正数を指定した場合は、Sumibi mode を有効にします。

Sumibi モードが有効になっている場合 \\<sumibi-mode-map>\\[sumibi-rK-trans] で
point から行頭方向に同種の文字列が続く間を漢字変換します。

同種の文字列とは以下のものを指します。
・半角カタカナとsumibi-stop-chars に指定した文字を除く半角文字
・漢字を除く全角文字"
  (interactive "P")
  (sumibi-mode-internal arg nil))

;; 全バッファで sumibi-mode を変更する
(defun global-sumibi-mode (&optional arg)
  "Sumibi mode は ローマ字から直接漢字変換するための minor mode です。
引数に正数を指定した場合は、Sumibi mode を有効にします。

Sumibi モードが有効になっている場合 \\<sumibi-mode-map>\\[sumibi-rK-trans] で
point から行頭方向に同種の文字列が続く間を漢字変換します。

同種の文字列とは以下のものを指します。
・半角カタカナとsumibi-stop-chars に指定した文字を除く半角文字
・漢字を除く全角文字"
  (interactive "P")
  (sumibi-mode-internal arg t))


;; sumibi-mode を変更する共通関数
(defun sumibi-mode-internal (arg global)
  (or (local-variable-p 'sumibi-mode (current-buffer))
      (make-local-variable 'sumibi-mode))
  (if global
      (progn
	(setq-default sumibi-mode t)
	(sumibi-kill-sumibi-mode))
    (setq sumibi-mode t)))


;; buffer local な sumibi-mode を削除する関数
(defun sumibi-kill-sumibi-mode ()
  (let ((buf (buffer-list)))
    (while buf
      (set-buffer (car buf))
      (kill-local-variable 'sumibi-mode)
      (setq buf (cdr buf)))))


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
 "" "Romaji -> Kanji&Kana"
 nil)

;; input-method として登録する。
(set-language-info "Japanese" 'input-method "japanese-sumibi")
(setq default-input-method "japanese-sumibi")

(defconst sumibi-version "0.1.0")
(defun sumibi-version (&optional arg)
  "入力モード変更"
  (interactive "P")
  (message sumibi-version))
(provide 'sumibi)
