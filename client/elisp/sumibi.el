;;;-*- mode: lisp-interaction; syntax: elisp -*-;;;
;;
;; "sumibi.el" is a client for Sumibi server.
;;
;;   Copyright (C) 2002,2003,2004,2005 Kiyoka Nishyama
;;   This program was derived fr yc.el-4.0.13(auther: knak)
;;
;;     $Date: 2005/04/23 14:24:03 $
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

;;; 本バージョン 0.2.0 はベータ版です。
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
;;;      3) Sumibi Server側もベータ版のため、不安定であることを御了承ください。
;;;      4) 将来Sumibi Serverのプロトコルは変更になります。
;;;      5) Sumibi Server側のソースコードもGPLです。sourceforge.jpのCVSで公開されています。
;;;
;;;   2. バグがまだまだあります。^_^;
;;;
;;;
;;; インストール方法、使いかたは以下のWebサイトにありますのであわせて参照してください。
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
  "SumibiサーバーのURLを指定する。"
  :type  'string
  :group 'sumibi)

(defcustom sumibi-server-encode 'euc-jp
  "Sumibiサーバーと交換するときの文字エンコードを指定する。(euc-jp/sjis/utf-8/iso-2022-jp)"
  :type  'string
  :group 'sumibi)

(defcustom sumibi-server-cert-data
  "-----BEGIN CERTIFICATE-----
MIIHPTCCBSWgAwIBAgIBADANBgkqhkiG9w0BAQQFADB5MRAwDgYDVQQKEwdSb290
IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNB
IENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRA
Y2FjZXJ0Lm9yZzAeFw0wMzAzMzAxMjI5NDlaFw0zMzAzMjkxMjI5NDlaMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEi
MCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIIC
CgKCAgEAziLA4kZ97DYoB1CW8qAzQIxL8TtmPzHlawI229Z89vGIj053NgVBlfkJ
8BLPRoZzYLdufujAWGSuzbCtRRcMY/pnCujW0r8+55jE8Ez64AO7NV1sId6eINm6
zWYyN3L69wj1x81YyY7nDl7qPv4coRQKFWyGhFtkZip6qUtTefWIonvuLwphK42y
fk1WpRPs6tqSnqxEQR5YYGUFZvjARL3LlPdCfgv3ZWiYUQXw8wWRBB0bF4LsyFe7
w2t6iPGwcswlWyCR7BYCEo8y6RcYSNDHBS4CMEK4JZwFaz+qOqfrU0j36NK2B5jc
G8Y0f3/JHIJ6BVgrCFvzOKKrF11myZjXnhCLotLddJr3cQxyYN/Nb5gznZY0dj4k
epKwDpUeb+agRThHqtdB7Uq3EvbXG4OKDy7YCbZZ16oE/9KTfWgu3YtLq1i6L43q
laegw1SJpfvbi1EinbLDvhG+LJGGi5Z4rSDTii8aP8bQUWWHIbEZAWV/RRyH9XzQ
QUxPKZgh/TMfdQwEUfoZd9vUFBzugcMd9Zi3aQaRIt0AUMyBMawSB3s42mhb5ivU
fslfrejrckzzAeVLIL+aplfKkQABi6F1ITe1Yw1nPkZPcCBnzsXWWdsC4PDSy826
YreQQejdIOQpvGQpQsgi3Hia/0PsmBsJUUtaWsJx8cTLc6nloQsCAwEAAaOCAc4w
ggHKMB0GA1UdDgQWBBQWtTIb1Mfz4OaO873SsDrusjkY0TCBowYDVR0jBIGbMIGY
gBQWtTIb1Mfz4OaO873SsDrusjkY0aF9pHsweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0
IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmeCAQAwDwYDVR0TAQH/BAUwAwEB/zAyBgNVHR8EKzApMCegJaAjhiFodHRw
czovL3d3dy5jYWNlcnQub3JnL3Jldm9rZS5jcmwwMAYJYIZIAYb4QgEEBCMWIWh0
dHBzOi8vd3d3LmNhY2VydC5vcmcvcmV2b2tlLmNybDA0BglghkgBhvhCAQgEJxYl
aHR0cDovL3d3dy5jYWNlcnQub3JnL2luZGV4LnBocD9pZD0xMDBWBglghkgBhvhC
AQ0ESRZHVG8gZ2V0IHlvdXIgb3duIGNlcnRpZmljYXRlIGZvciBGUkVFIGhlYWQg
b3ZlciB0byBodHRwOi8vd3d3LmNhY2VydC5vcmcwDQYJKoZIhvcNAQEEBQADggIB
ACjH7pyCArpcgBLKNQodgW+JapnM8mgPf6fhjViVPr3yBsOQWqy1YPaZQwGjiHCc
nWKdpIevZ1gNMDY75q1I08t0AoZxPuIrA2jxNGJARjtT6ij0rPtmlVOKTV39O9lg
18p5aTuxZZKmxoGCXJzN600BiqXfEVWqFcofN8CCmHBh22p8lqOOLlQ+TyGpkO/c
gr/c6EWtTZBzCDyUZbAEmXZ/4rzCahWqlwQ3JNgelE5tDlG+1sSPypZt90Pf6DBl
Jzt7u0NDY8RD97LsaMzhGY4i+5jhe1o+ATc7iwiwovOVThrLm82asduycPAtStvY
sONvRUgzEv/+PDIqVPfE94rwiCPCR/5kenHA0R6mY7AHfqQv0wGP3J8rtsYIqQ+T
SCX8Ev2fQtzzxD72V7DX3WnRBnc0CkvSyqD/HMaMyRa+xMwyN2hzXwj7UfdJUzYF
CpUCTPJ5GhD22Dp1nPMd8aINcGeGG7MW9S/lpOt5hvk9C8JzC6WZrG/8Z7jlLwum
GCSNe9FINSkYQKyTYOGWhlC0elnYjyELn8+CkcY7v2vcB5G5l1YjqrZslMZIBjzk
zk6q5PYvCdxTby78dOs6Y5nCpqyJvKeyRKANihDjbPIky/qbn3BHLt4Ui9SyIAmW
omTxJBzcoTWcFbLUvFUufQb1nA5V9FrWk9p2rSVzTMVD
-----END CERTIFICATE-----
"
  "Sumibiサーバーと通信する時のSSL証明書データ。"
  :type  'string
  :group 'sumibi)

(defcustom sumibi-server-use-cert t
  "Sumibiサーバーと通信する時のSSL証明書を使うかどうか。"
  :type  'symbol
  :group 'sumibi)

(defcustom sumibi-server-timeout 10
  "Sumibiサーバーと通信する時のタイムアウトを指定する。(秒数)"
  :type  'integer
  :group 'sumibi)
 
(defcustom sumibi-stop-chars ";:(){}<>"
  "*漢字変換文字列を取り込む時に変換範囲に含めない文字を設定する"
  :type  'string
  :group 'sumibi)

(defcustom sumibi-curl "curl"
  "curlコマンドの絶対パスを設定する"
  :type  'string
  :group 'sumibi)


(defvar sumibi-mode nil             "漢字変換トグル変数")
(defvar sumibi-mode-line-string     " Sumibi")
(defvar sumibi-select-mode nil      "候補選択モード変数")
(or (assq 'sumibi-mode minor-mode-alist)
    (setq minor-mode-alist (cons
			    '(sumibi-mode        sumibi-mode-line-string)
			    minor-mode-alist)))


;; ローマ字漢字変換時、対象とするローマ字を設定するための変数
(defvar sumibi-skip-chars "a-zA-Z0-9 .,\\-+!\\[\\]?")
(defvar sumibi-mode-map        (make-sparse-keymap)         "漢字変換トグルマップ")
(defvar sumibi-select-mode-map (make-sparse-keymap)         "候補選択モードマップ")
(defvar sumibi-rK-trans-key "\C-j"
  "*漢字変換キーを設定する")
(or (assq 'sumibi-mode minor-mode-map-alist)
    (setq minor-mode-map-alist
	  (append (list (cons 'sumibi-mode         sumibi-mode-map)
			(cons 'sumibi-select-mode  sumibi-select-mode-map))
		  minor-mode-map-alist)))



;;--- デバッグメッセージ出力
(defvar sumibi-debug nil)		; デバッグフラグ
(defun sumibi-debug-print (string)
  (if sumibi-debug
      (let
	  ((buffer (get-buffer-create "*sumibi-debug*")))
	(with-current-buffer buffer
	  (goto-char (point-max))
	  (insert string)))))


;;; sumibi basic output
(defvar sumibi-fence-start nil)		; fence 始端位置
(defvar sumibi-fence-end nil)		; fence 終端位置
(defvar sumibi-henkan-separeter " ")	; fence mode separeter
(defvar sumibi-henkan-buffer nil)	; 表示用バッファ
(defvar sumibi-henkan-length nil)	; 表示用バッファ長
(defvar sumibi-henkan-revpos nil)	; 文節始端位置
(defvar sumibi-henkan-revlen nil)	; 文節長

;;; sumibi basic local
(defvar sumibi-cand     nil)		; カレント文節番号
(defvar sumibi-cand-n   nil)		; 文節候補番号
(defvar sumibi-cand-n-backup   nil)	; 文節候補番号 ( 候補選択キャンセル用 )
(defvar sumibi-cand-max nil)		; 文節候補数
(defvar sumibi-last-fix "")		; 最後に確定した文字列
(defvar sumibi-henkan-list nil)		; 文節リスト
(defvar sumibi-repeat 0)		; 繰り返し回数
(defvar sumibi-marker-list '())		; 文節開始、終了位置リスト: 次のような形式 ( ( 1 . 2 ) ( 5 . 7 ) ... ) 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 表示系関数群
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar sumibi-use-fence t)
(defvar sumibi-use-color nil)

(defvar sumibi-init nil)
(defvar sumibi-server-cert-file nil)

;;
;; 初期化
;;
(defun sumibi-init ()

  ;; テンポラリファイルを作成する。
  (defun sumibi-make-temp-file (base)
    (if	(functionp 'make-temp-file)
	(make-temp-file base)
      (concat "/tmp/" (make-temp-name base))))

  (when (not sumibi-init)
    ;; SSL証明書ファイルをテンポラリファイルとして作成する。
    (setq sumibi-server-cert-file 
	  (sumibi-make-temp-file
	   "sumibi.certfile"))
    (sumibi-debug-print (format "cert-file :[%s]\n" sumibi-server-cert-file))
    (with-temp-buffer
      (insert sumibi-server-cert-data)
      (write-region (point-min) (point-max) sumibi-server-cert-file  nil nil))

    ;; Emacs終了時SSL証明書ファイルを削除する。
    (add-hook 'kill-emacs-hook
	      (lambda ()
		(delete-file sumibi-server-cert-file)))

    ;; 初期化完了
    (setq sumibi-init t)))


;;
;; ローマ字で書かれた文章をSumibiサーバーを使って変換する
;;
(defun sumibi-henkan-request (yomi)
  (sumibi-debug-print (format "henkan-input :[%s]\n"  yomi))

  (message "Requesting to sumibi server...")
  (let (
	(result 
	 (shell-command-to-string
	  (concat
	   sumibi-curl " --silent --show-error "
	   (format "--connect-timeout %d " sumibi-server-timeout)
	   sumibi-server-url " "
	   (format "--data 'string=%s&encode=%S' " yomi sumibi-server-encode)
	   (when sumibi-server-use-cert
	     (if (not sumibi-server-cert-file)
		 (error "Error : cert file create miss!")
	       (format "--cacert '%s' " sumibi-server-cert-file)))
	   ))))
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


;; リージョンをローマ字漢字変換する関数
(defun sumibi-henkan-region (b e)
  "指定された region を漢字変換する"
  (sumibi-init)
  (when (/= b e)
    (let* (
	   (yomi (buffer-substring-no-properties b e))
	   (henkan-list (sumibi-henkan-request yomi)))

      (if henkan-list
	  (condition-case err
	      (progn
		(setq
		 ;; 変換結果の保持
		 sumibi-henkan-list henkan-list
		 ;; 文節選択初期化
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
	     (setq sumibi-select-mode nil)) )
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; undo 情報の制御
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; undo buffer 退避用変数
(defvar sumibi-buffer-undo-list nil)
(make-variable-buffer-local 'sumibi-buffer-undo-list)
(defvar sumibi-buffer-modified-p nil)
(make-variable-buffer-local 'sumibi-buffer-modified-p)

(defvar sumibi-blink-cursor nil)
(defvar sumibi-cursor-type nil)
;; undo buffer を退避し、undo 情報の蓄積を停止する関数
(defun sumibi-disable-undo ()
  (when (not (eq buffer-undo-list t))
    (setq sumibi-buffer-undo-list buffer-undo-list)
    (setq sumibi-buffer-modified-p (buffer-modified-p))
    (setq buffer-undo-list t)))

;; 退避した undo buffer を復帰し、undo 情報の蓄積を再開する関数
(defun sumibi-enable-undo ()
  (when (not sumibi-buffer-modified-p) (set-buffer-modified-p nil))
  (when sumibi-buffer-undo-list
    (setq buffer-undo-list sumibi-buffer-undo-list)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 現在の変換エリアの表示を行う
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun sumibi-get-display-string ()
  (let ((cnt 0))
    (mapconcat
     (lambda (x)
       ;; 変換結果文字列を返す。
       (let ((word (nth (nth cnt sumibi-cand-n) x)))
	 (sumibi-debug-print (format "word:[%d] %s\n" cnt word))
	 (setq cnt (+ 1 cnt))
	 word))
     sumibi-henkan-list
     "")))


(defun sumibi-display-function (b e select-mode)
  (setq sumibi-henkan-separeter (if sumibi-use-fence " " ""))
  (when sumibi-henkan-list
    ;; UNDO抑制開始
    (sumibi-disable-undo)

    (delete-region b e)

    ;; リスト初期化
    (setq sumibi-marker-list '())

    (let (
	   (cnt 0))

      (setq sumibi-last-fix "")

      ;; 変換したpointの保持
      (setq sumibi-fence-start (point-marker))
      (when select-mode (insert "|"))

      (mapcar
       (lambda (x)
	 (if (and
	      (not (eq (preceding-char) ?\ ))
	      (not (eq (point-at-bol) (point)))
	      (eq (sumibi-char-charset (preceding-char)) 'ascii)
	      (and
	       (< 0 (length (car x)))
	       (eq (sumibi-char-charset (string-to-char (car x))) 'ascii)))
	     (insert " "))

	 (let* (
		(start       (point-marker))
		(_n          (nth cnt sumibi-cand-n))
		(_max        (nth cnt sumibi-cand-max))
		(insert-word (nth _n x))
		(_     
		 (if (eq cnt sumibi-cand)
		     (progn
		      (insert insert-word)
		      (message (format "candidate (%d/%d)" (+ _n 1) _max)))
		   (insert insert-word)))
		(end         (point-marker))
		(ov          (make-overlay start end)))

	   ;; 確定文字列の作成
	   (setq sumibi-last-fix (concat sumibi-last-fix insert-word))
	   
	   ;; 選択中の場所を装飾する。
	   (overlay-put ov 'face 'default)
	   (when (and select-mode
		      (eq cnt sumibi-cand))
	     (overlay-put ov 'face 'highlight))

	   (push `(,start . ,end) sumibi-marker-list)
	   (sumibi-debug-print (format "insert:[%s] point:%d-%d\n" insert-word (marker-position start) (marker-position end))))
	 (setq cnt (+ cnt 1)))

       sumibi-henkan-list))

    ;; リストを逆順にする。
    (setq sumibi-marker-list (reverse sumibi-marker-list))

    ;; fenceの範囲を設定する
    (when select-mode (insert "|"))
    (setq sumibi-fence-end   (point-marker))

    (sumibi-debug-print (format "total-point:%d-%d\n"
				(marker-position sumibi-fence-start)
				(marker-position sumibi-fence-end)))
    ;; UNDO再開
    (sumibi-enable-undo)
    ))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 変換候補選択モード
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(let ((i 0))
  (while (<= i ?\177)
    (define-key sumibi-select-mode-map (char-to-string i)
      'sumibi-kakutei-and-self-insert)
    (setq i (1+ i))))
(define-key sumibi-select-mode-map "\C-m"                   'sumibi-select-kakutei)
(define-key sumibi-select-mode-map "\C-g"                   'sumibi-select-cancel)
(define-key sumibi-select-mode-map "\C-b"                   'sumibi-select-prev-word)
(define-key sumibi-select-mode-map "\C-f"                   'sumibi-select-next-word)
(define-key sumibi-select-mode-map "\C-a"                   'sumibi-select-first-word)
(define-key sumibi-select-mode-map "\C-e"                   'sumibi-select-last-word)
(define-key sumibi-select-mode-map sumibi-rK-trans-key      'sumibi-select-next)
(define-key sumibi-select-mode-map " "                      'sumibi-select-next)
(define-key sumibi-select-mode-map "\C-p"                   'sumibi-select-prev)
(define-key sumibi-select-mode-map "\C-n"                   'sumibi-select-next)


;; 変換を確定し入力されたキーを再入力する関数
(defun sumibi-kakutei-and-self-insert (arg)
  "候補選択を確定し、入力された文字を入力する"
  (interactive "P")
  (sumibi-select-kakutei)
  (setq unread-command-events (list last-command-event)))

;; 候補選択状態での表示更新
(defun sumibi-select-update-display ()
  (sumibi-display-function
   (marker-position sumibi-fence-start)
   (marker-position sumibi-fence-end)
   sumibi-select-mode))

;; 候補選択を確定する
(defun sumibi-select-kakutei ()
  "候補選択を確定する"
  (interactive)
  ;; 候補番号リストをバックアップする。
  (setq sumibi-cand-n-backup (copy-list sumibi-cand-n))
  (setq sumibi-select-mode nil)
  (sumibi-select-update-display))

;; 候補選択をキャンセルする
(defun sumibi-select-cancel ()
  "候補選択をキャンセルする"
  (interactive)
  ;; カレント候補番号をバックアップしていた候補番号で復元する。
  (setq sumibi-cand-n (copy-list sumibi-cand-n-backup))
  (setq sumibi-select-mode nil)
  (sumibi-select-update-display))

;; 前の候補に進める
(defun sumibi-select-prev ()
  "前の候補に進める"
  (interactive)
  (let (
	(n sumibi-cand))

    ;; 前の候補に切りかえる
    (setcar (nthcdr n sumibi-cand-n) (- (nth n sumibi-cand-n) 1))
    (when (> 0 (nth n sumibi-cand-n))
      (setcar (nthcdr n sumibi-cand-n) (- (nth n sumibi-cand-max) 1)))
    (sumibi-select-update-display)))

;; 次の候補に進める
(defun sumibi-select-next ()
  "次の候補に進める"
  (interactive)
  (let (
	(n sumibi-cand))

    ;; 次の候補に切りかえる
    (setcar (nthcdr n sumibi-cand-n) (+ 1 (nth n sumibi-cand-n)))
    (when (>= (nth n sumibi-cand-n) (nth n sumibi-cand-max))
      (setcar (nthcdr n sumibi-cand-n) 0))

    (sumibi-select-update-display)))

;; 前の文節に移動する
(defun sumibi-select-prev-word ()
  "前の文節に移動する"
  (interactive)
  (when (< 0 sumibi-cand)
    (setq sumibi-cand (- sumibi-cand 1)))
  (sumibi-select-update-display))

;; 次の文節に移動する
(defun sumibi-select-next-word ()
  "次の文節に移動する"
  (interactive)
  (when (< sumibi-cand (- (length sumibi-cand-n) 1))
    (setq sumibi-cand (+ 1 sumibi-cand)))
  (sumibi-select-update-display))

;; 最初の文節に移動する
(defun sumibi-select-first-word ()
  "最初の文節に移動する"
  (interactive)
  (setq sumibi-cand 0)
  (sumibi-select-update-display))

;; 最後の文節に移動する
(defun sumibi-select-last-word ()
  "最後の文節に移動する"
  (interactive)
  (setq sumibi-cand (- (length sumibi-cand-n) 1))
  (sumibi-select-update-display))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ローマ字漢字変換関数
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun sumibi-rK-trans ()
  "ローマ字漢字変換をする。
・カーソルから行頭方向にローマ字列が続く範囲でローマ字漢字変換を行う。"
  (interactive)
;  (print last-command)			; DEBUG
  (cond
   
   (sumibi-select-mode
    ;; 変換中に呼出されたら、候補選択モードに移行する。
    (funcall (lookup-key sumibi-select-mode-map sumibi-rK-trans-key)))


   (t
    (cond

     ((eq (sumibi-char-charset (preceding-char)) 'ascii)
      ;; カーソル直前が alphabet だったら
      (let ((end (point))
	    (gap (sumibi-skip-chars-backward)))
	(when (/= gap 0)
	  ;; 意味のある入力が見つかったので変換する
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
    
      ;; カーソル直前が 全角で漢字以外 だったら候補選択モードに移行する。
      ;; また、最後に確定した文字列と同じかどうかも確認する。
      (when (and
	     (<= (marker-position sumibi-fence-start) (point))
	     (<= (point) (marker-position sumibi-fence-end))
	     (string-equal sumibi-last-fix (buffer-substring 
					    (marker-position sumibi-fence-start)
					    (marker-position sumibi-fence-end))))
					    
	;; 直前に変換したfenceの範囲に入っていたら、変換モードに移行する。
	(let
	    ((cnt 0))
	  (setq sumibi-select-mode t)
	  (setq sumibi-cand 0)		; 文節番号初期化
	  
	  (sumibi-debug-print "henkan mode ON\n")
	  
	  ;; カーソル位置がどの文節に乗っているかを調べる。
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

	  ;; 表示状態を候補選択モードに切替える。
	  (sumibi-display-function
	   (marker-position sumibi-fence-start)
	   (marker-position sumibi-fence-end)
	   t))))
     ))))



;; 全角で漢字以外の判定関数
(defun sumibi-nkanji (ch)
  (and (eq (sumibi-char-charset ch) 'japanese-jisx0208)
       (not (string-match "[亜-瑤]" (char-to-string ch)))))

(defun sumibi-kanji (ch)
  (eq (sumibi-char-charset ch) 'japanese-jisx0208))


;; ローマ字漢字変換時、変換対象とするローマ字を読み飛ばす関数
(defun sumibi-skip-chars-backward ()
  (let* (
	 ;; マークされている位置を求める。
	 (pos (or (and (markerp (mark-marker)) (marker-position (mark-marker)))
		  1))
	 ;; 条件にマッチする間、前方方向にスキップする。
	 (result (save-excursion
		   (skip-chars-backward sumibi-skip-chars (and (< pos (point)) pos))))
	 (indent 0))

    ;; インデント位置を求める。
    (save-excursion
      (goto-char (point-at-bol))
      (setq indent (skip-chars-forward (concat "\t " sumibi-stop-chars) (point-at-eol))))

    (sumibi-debug-print (format "(point) = %d  result = %d  indent = %d\n" (point) result indent))
    (sumibi-debug-print (format "a = %d b = %d \n" (+ (point) result) (+ (point-at-bol) indent)))

    (if (< (+ (point) result)
	   (+ (point-at-bol) indent))
	;; インデント位置でストップする。
	(- 
	 (+ (point-at-bol) indent)
	 (point))

      result)))
  

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
 "" "Roman -> Kanji&Kana"
 nil)

;; input-method として登録する。
(set-language-info "Japanese" 'input-method "japanese-sumibi")
(setq default-input-method "japanese-sumibi")

(defconst sumibi-version "0.2.0pre")
(defun sumibi-version (&optional arg)
  "入力モード変更"
  (interactive "P")
  (message sumibi-version))
(provide 'sumibi)

;; Sumibi モードをバッファ全体で有効にする
(global-sumibi-mode 1)
