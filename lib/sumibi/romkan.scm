;;
;; ローマ字と仮名、カタカナを扱うライブラリ
;;
(define-module sumibi.romkan
  (use text.tr)
  (use gauche.collection)
  (export 
   romkan-roman->kana
   romkan-kana->roman
   romkan-hiragana->katakana
   romkan-katakana->hiragana
   romkan-is-katakana
   romkan-is-hiragana))
(select-module sumibi.romkan)

;; このテーブルはruby-romkan から変換した
;;   クンレイ式と仮名の変換テーブルはSumibiには不要なので除去した。
;;   そのかわり、クンレイや日本式からボン式に変換するテーブルを作成した。
(define romkan-hepburn-alist
  '(
    ("ぁ" . "xa")
    ("あ" . "a")
    ("ぃ" . "xi")
    ("い" . "i")
    ("ぅ" . "xu")
    ("う" . "u")
    ("う゛" . "vu")
    ("う゛ぁ" . "va")
    ("う゛ぃ" . "vi")
    ("う゛ぇ" . "ve")
    ("う゛ぉ" . "vo")
    ("ぇ" . "xe")
    ("え" . "e")
    ("ぉ" . "xo")
    ("お" . "o")
    ("か" . "ka")
    ("が" . "ga")
    ("き" . "ki")
    ("きゃ" . "kya")
    ("きゅ" . "kyu")
    ("きょ" . "kyo")
    ("ぎ" . "gi")
    ("ぎゃ" . "gya")
    ("ぎゅ" . "gyu")
    ("ぎょ" . "gyo")
    ("く" . "ku")
    ("ぐ" . "gu")
    ("け" . "ke")
    ("げ" . "ge")
    ("こ" . "ko")
    ("ご" . "go")
    ("さ" . "sa")
    ("ざ" . "za")
    ("し" . "shi")
    ("しゃ" . "sha")
    ("しゅ" . "shu")
    ("しぇ" . "she")
    ("しょ" . "sho")
    ("じ" . "ji")
    ("じゃ" . "ja")
    ("じゅ" . "ju")
    ("じぇ" . "je")
    ("じょ" . "jo")
    ("す" . "su")
    ("ず" . "zu")
    ("せ" . "se")
    ("ぜ" . "ze")
    ("そ" . "so")
    ("ぞ" . "zo")
    ("た" . "ta")
    ("だ" . "da")
    ("ち" . "chi")
    ("ちゃ" . "cha")
    ("ちゅ" . "chu")
    ("ちぇ" . "che")
    ("ちょ" . "cho")
    ("ぢ" . "di")
    ("ぢゃ" . "dya")
    ("ぢゅ" . "dyu")
    ("ぢぇ" . "dye")
    ("ぢょ" . "dyo")

;    ("っ" . "xtsu")
    ("っ" . "tt")

    ("っう゛" . "vvu")
    ("っう゛ぁ" . "vva")
    ("っう゛ぃ" . "vvi")
    ("っう゛ぇ" . "vve")
    ("っう゛ぉ" . "vvo")
    ("っか" . "kka")
    ("っが" . "gga")
    ("っき" . "kki")
    ("っきゃ" . "kkya")
    ("っきゅ" . "kkyu")
    ("っきょ" . "kkyo")
    ("っぎ" . "ggi")
    ("っぎゃ" . "ggya")
    ("っぎゅ" . "ggyu")
    ("っぎょ" . "ggyo")
    ("っく" . "kku")
    ("っぐ" . "ggu")
    ("っけ" . "kke")
    ("っげ" . "gge")
    ("っこ" . "kko")
    ("っご" . "ggo")
    ("っさ" . "ssa")
    ("っざ" . "zza")
    ("っし" . "sshi")
    ("っしゃ" . "ssha")
    ("っしゅ" . "sshu")
    ("っしぇ" . "sshe")
    ("っしょ" . "ssho")
    ("っじ" . "jji")
    ("っじゃ" . "jja")
    ("っじゅ" . "jju")
    ("っじぇ" . "jje")
    ("っじょ" . "jjo")
    ("っす" . "ssu")
    ("っず" . "zzu")
    ("っせ" . "sse")
    ("っぜ" . "zze")
    ("っそ" . "sso")
    ("っぞ" . "zzo")
    ("った" . "tta")
    ("っだ" . "dda")
    ("っち" . "cchi")
    ("っちゃ" . "ccha")
    ("っちゅ" . "cchu")
    ("っちぇ" . "cche")
    ("っちょ" . "ccho")
    ("っぢ" . "ddi")
    ("っぢゃ" . "ddya")
    ("っぢゅ" . "ddyu")
    ("っぢぇ" . "ddye")
    ("っぢょ" . "ddyo")
    ("っつ" . "ttsu")
    ("っづ" . "ddu")
    ("って" . "tte")
    ("っで" . "dde")
    ("っと" . "tto")
    ("っど" . "ddo")
    ("っは" . "hha")
    ("っば" . "bba")
    ("っぱ" . "ppa")
    ("っひ" . "hhi")
    ("っひゃ" . "hhya")
    ("っひゅ" . "hhyu")
    ("っひょ" . "hhyo")
    ("っび" . "bbi")
    ("っびゃ" . "bbya")
    ("っびゅ" . "bbyu")
    ("っびょ" . "bbyo")
    ("っぴ" . "ppi")
    ("っぴゃ" . "ppya")
    ("っぴゅ" . "ppyu")
    ("っぴょ" . "ppyo")
    ("っふ" . "ffu")
    ("っふぁ" . "ffa")
    ("っふぃ" . "ffi")
    ("っふぇ" . "ffe")
    ("っふぉ" . "ffo")
    ("っぶ" . "bbu")
    ("っぷ" . "ppu")
    ("っへ" . "hhe")
    ("っべ" . "bbe")
    ("っぺ" . "ppe")
    ("っほ" . "hho")
    ("っぼ" . "bbo")
    ("っぽ" . "ppo")
    ("っや" . "yya")
    ("っゆ" . "yyu")
    ("っよ" . "yyo")
    ("っら" . "rra")
    ("っり" . "rri")
    ("っりゃ" . "rrya")
    ("っりゅ" . "rryu")
    ("っりょ" . "rryo")
    ("っる" . "rru")
    ("っれ" . "rre")
    ("っろ" . "rro")
    ("つ" . "tsu")
    ("づ" . "du")
    ("て" . "te")
    ("で" . "de")
    ("と" . "to")
    ("ど" . "do")
    ("な" . "na")
    ("に" . "ni")
    ("にゃ" . "nya")
    ("にゅ" . "nyu")
    ("にょ" . "nyo")
    ("ぬ" . "nu")
    ("ね" . "ne")
    ("の" . "no")
    ("は" . "ha")
    ("ば" . "ba")
    ("ぱ" . "pa")
    ("ひ" . "hi")
    ("ひゃ" . "hya")
    ("ひゅ" . "hyu")
    ("ひょ" . "hyo")
    ("び" . "bi")
    ("びゃ" . "bya")
    ("びゅ" . "byu")
    ("びょ" . "byo")
    ("ぴ" . "pi")
    ("ぴゃ" . "pya")
    ("ぴゅ" . "pyu")
    ("ぴょ" . "pyo")
    ("ふ" . "fu")
    ("ふぁ" . "fa")
    ("ふぃ" . "fi")
    ("ふぇ" . "fe")
    ("ふぉ" . "fo")
    ("ぶ" . "bu")
    ("ぷ" . "pu")
    ("へ" . "he")
    ("べ" . "be")
    ("ぺ" . "pe")
    ("ほ" . "ho")
    ("ぼ" . "bo")
    ("ぽ" . "po")
    ("ま" . "ma")
    ("み" . "mi")
    ("みゃ" . "mya")
    ("みゅ" . "myu")
    ("みょ" . "myo")
    ("む" . "mu")
    ("め" . "me")
    ("も" . "mo")
    ("ゃ" . "xya")
    ("や" . "ya")
    ("ゅ" . "xyu")
    ("ゆ" . "yu")
    ("ょ" . "xyo")
    ("よ" . "yo")
    ("ら" . "ra")
    ("り" . "ri")
    ("りゃ" . "rya")
    ("りゅ" . "ryu")
    ("りょ" . "ryo")
    ("る" . "ru")
    ("れ" . "re")
    ("ろ" . "ro")
    ("ゎ" . "xwa")
    ("わ" . "wa")
    ("ゐ" . "wi")
    ("ゑ" . "we")
    ("を" . "wo")
    ("ん" . "n")
    ("ん" . "n'")
    ("でぃ" . "dyi")
    ("っでぃ" . "ddyi")
    ("ー" . "-")


;; Ruby romkanからの不足分追加
    ("てぃ" . "thi")
    ("ん"  . "nn")

    ("ー" . "^")
    ))



(define romkan-kunrei-to-hepburn-alist
  '(
    ("ca"   . "ka")
    ("ci"   . "ki")
    ("cu"   . "ku")
    ("ce"   . "ke")
    ("co"   . "ko")

    ("si"   . "shi")
    ("ti"   . "chi")
    ("hu"   . "fu")
    ("hhu"  . "ffu")
    ("shu"  . "shu") ;; hu の例外処理: shu は sfu になってはいけない
    ("chu"  . "chu") ;; hu の例外処理: chu は cfu になってはいけない

    ("tu"   . "tsu")
    ("sya"  . "sha")
    ("syu"  . "shu")
    ("sye"  . "she")
    ("syo"  . "sho")

    ("zi"   . "ji")
    ("jya"  . "ja")
    ("jyu"  . "ju")
    ("jye"  . "je")
    ("jyo"  . "jo")
    ("zya"  . "ja")
    ("zyu"  . "ju")
    ("zye"  . "je")
    ("zyo"  . "jo")

    ("tya"  . "cha")
    ("tyi"  . "chi")
    ("tyu"  . "chu")
    ("tye"  . "che")
    ("tyo"  . "cho")

    ("dhi"  . "dyi")
    ("ddhi" . "ddyi")

    ("la"   . "xa")
    ("li"   . "xi")
    ("lu"   . "xu")
    ("le"   . "xe")
    ("lo"   . "xo")
    ("xtu"  . "tt")
    ("xtsu" . "tt")

    ("ttya" . "ccha")
    ("ttyi" . "cchi")
    ("ttyu" . "cchu")
    ("ttye" . "cche")
    ("ttyo" . "ccho")

    ))


;; ハッシュテーブルを作る
(define (romkan-make-hash-table-from-alist a-list)
  (let (
	(to-roma-hash (make-hash-table 'string=?))
	(from-roma-hash (make-hash-table 'string=?)))
    (for-each
     (lambda (x)
       (hash-table-put! to-roma-hash (car x) (cdr x))
       (hash-table-put! from-roma-hash (cdr x) (car x)))
     a-list)
    (cons to-roma-hash from-roma-hash)))
    

;; 引数 a-list から 正引き、逆引き a-list を返す
;; 引数 which には 'normal,'reverseのどちらかを渡す
;;   返却する a-list は key となる文字列の長いものからソートされる
(define (romkan-alist->alist a-list which)
  (let (
	(result '()))
    ;; 正引きの作成
    (cond ((eq? which 'reverse)
	   (set! result a-list))
	  ((eq? which 'normal)
	   (for-each
	    (lambda (x)
	      (set! result (acons (cdr x) (car x) result)))
	    a-list)))
    ;; ソート
    (sort result 
	  (lambda (x y)
	    (> (string-length (car x))
	       (string-length (car y)))))))
	  


;; a-list を使って str の先頭に該当する文字列があるか調べる
(define (romkan-scan-token a-list str)
  (let 
      ((result     (substring str 0 1))
       (rest       (substring str 1 (string-length str)))
       (done       #f))

    (for-each
     (lambda (x)
       (if (and 
	    (eq? 0 (string-scan str (car x) 'index))
	    (not done))
	   (begin
	     (set! done #t)
	     (set! result (cdr x))
	     (set! rest   (string-scan str (car x) 'after)))))
     a-list)
    (cons result rest)))


;; かな<->ローマ字変換する
(define (romkan-convert a-list str)
  (cond ((eqv? 0 (string-length str))
	 "")
	(#t
	 (let ((ret (romkan-scan-token a-list str)))
	   (string-append
	    (car ret)
	    (romkan-convert a-list (cdr ret)))))))



;;--------------------------------------------------
;; API
;;--------------------------------------------------
;; ヘボン->かな 変換
(define (romkan-roman->kana str)
  (romkan-convert
   (romkan-alist->alist romkan-hepburn-alist 'normal)
   (romkan-convert
    romkan-kunrei-to-hepburn-alist
    str)))


;; かな->ヘボン 変換
;;   (カタカナ文字列もローマ字変換の対象となる)
(define (romkan-kana->roman str)
  (romkan-convert
   (romkan-alist->alist romkan-hepburn-alist 'reverse)
   (romkan-katakana->hiragana
    str)))



;; 平仮名->カタカナ 変換
(define (romkan-hiragana->katakana str)
  (string-tr str "あ-んぁぃぅぇぉゃゅょっー" "ア-ンァィゥェォャュョッー"))

;; カタカナ->平仮名 変換
(define (romkan-katakana->hiragana str)
  (string-tr str "ア-ンァィゥェォャュョッー" "あ-んぁぃぅぇぉゃゅょっー"))

;; カタカナの文字列かどうかを評価する
(define (romkan-is-katakana str)
  (rxmatch #/^[ア-ンァィゥェォャュョッー]+$/ str))

;; 平仮名の文字列かどうかを評価する
(define (romkan-is-hiragana str)
  (rxmatch #/^[あ-んぁぃぅぇぉゃゅょっー]+$/ str))


;;--------------------------------------------------
;; テーブル内容出力(デバッグ用)
;;--------------------------------------------------
;; ヘボン->かなの完全なテーブル生成
(define (generate-roman->kana-table)
  (let ((result
	 (map
	  (lambda (x)
	    (cons
	     (cdr x)
	     (romkan-roman->kana (cdr x))))
	  
	  (append
	   romkan-hepburn-alist
	   (map
	    (lambda (x)
	      (cons
	       (cdr x)
	       (car x)))
	    romkan-kunrei-to-hepburn-alist)))))
    
    (sort result 
	  (lambda (x y)
	    (> (string-length (car x))
	       (string-length (car y)))))))

(provide "sumibi/romkan")
