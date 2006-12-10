#!/usr/local/bin/gosh /usr/local/bin/sxmlcnv


(load "./common.scm")


(define (L:body)
  '(
    (*section
     "このドキュメントについて"
     "About this document"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (p "このドキュメントはperl等の様々な言語からsumibi.org上の漢字変換サービスを利用する方法を解説しています。")))

    (*section
     "Sumibi Web APIとは"
     "About Sumibi Web API"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (ul
       (li "Sumibi Web APIは、sumibi.orgで公開しているSOAP 1.1準拠の漢字変換Webサービスです。")
       (li "SOAPライブラリを持つ言語ならどの言語からでも利用できます。")
       (li " WSDLを公開していますので、SOAPの詳細な知識なしにSumibi Web APIを利用することができます。")
       (li (*link "WSDLファイル(テスト版)" "Sumibi_testing.wsdl")))))

    (*section
     "Sumibi Web API仕様"
     "Sumibi Web API Specification"
     (*en
      (p "No documents in English, sorry..." ))
     (*subsection
      "メソッド"
      "methods"
      (*ja
       (ol
	(li "getStatusメソッド")
	(ul
	 (li "パラメータ")
	 (p "なし")
	 (li "戻り値")
	 (p "SumibiStatus型")
	 (table 
	  (thead
	   (tr  (td "名前") (td "値")))
	  (tbody
	   (tr   (td "version")   (td "APIのバージョン番号(例:0.7.3)")))))

	(li "doSumibiConvertメソッド")
	(ul
	 (li "パラメータ")
	 (table 
	  (thead
	   (tr  (td "名前") (td "値")))
	  (tbody
	   (tr   (td "query")   (td "変換したいローマ字文字列"))
	   (tr   (td "sumi")    (td "変換に使用する辞書名(未使用)"))
	   (tr   (td "history") (td "変換履歴文字列(変換候補IDのリストを ; 記号で分離したもの)"))
	   (tr   (td "dummy")   (td "(未使用)"))))
	 (li "戻り値")
	 (p "SumibiResult型")
	 (table 
	  (thead
	   (tr  (td "名前") (td "値")))
	  (tbody
	   (tr   (td "convertTime")     (td "変換処理に要した秒数(未実装)"))
	   (tr   (td "resultElements")  (td "変換候補の配列(下記 ResultElementArray型参照)"))))
	 (p "ResultElementArray型(以下の構造体の配列となります)")
	 (table 
	  (thead
	   (tr  (td "名前") (td "値")))
	  (tbody
	   (tr   (td "id")         (td "単語ID(DB内での識別番号:ヒストリデータの返信に使用)"))
	   (tr   (td "no")         (td "文節番号"))
	   (tr   (td "candidate")  (td "変換候補番号(ゼロが一番適合率が高い)"))
	   (tr   (td "spaces")     (td "文節と文節の間のスペースの数"))
	   (tr   (td "type")       (td "変換候補タイプ( j:漢字、h:平仮名、k:カタカナ、l:アルファベット)"))
	   (tr   (td "word")       (td "変換候補文字列")))))
      
	(li "doSumibiConvertHiraメソッド")
	(ul
	 (li "パラメータ")
	 (table 
	  (thead
	   (tr  (td "名前") (td "値")))
	  (tbody
	   (tr   (td "query")   (td "変換したいローマ字文字列"))
	   (tr   (td "sumi")    (td "変換に使用する辞書名(未使用)"))
	   (tr   (td "history") (td "変換履歴文字列(変換候補IDのリストを ; 記号で分離したもの)"))
	   (tr   (td "dummy")   (td "(未使用)"))))
	 (li "戻り値")
	 (p "ローマ字を平仮名に変換した文字列(UTF-8固定)"))

	(li "doSumibiConvertSexpメソッド(Emacs専用)")
	(ul
	 (li "パラメータ")
	 (table 
	  (thead
	   (tr  (td "名前") (td "値")))
	  (tbody
	   (tr   (td "query")   (td "変換したいローマ字文字列"))
	   (tr   (td "sumi")    (td "変換に使用する辞書名(未使用)"))
	   (tr   (td "history") (td "変換履歴文字列(変換候補IDのリストを ; 記号で分離したもの)"))
	   (tr   (td "dummy")   (td "(未使用)"))))
	 (li "戻り値")
	 (p "base64エンコードされたEmacs用S式")
	 (p "(注意:S式の日本語エンコードは常にEUC-JPです)"))))))


    (*section
     "サンプルプログラムを動かす"
     "Try some sample programs."
     (*en
      (p "No documents in English, sorry..." ))
     (*subsection
      "perlからsumibi.orgのサービスを呼びだす"
      "Using sumibi.org with perl"
      (*en
       (p "No documents in English, sorry..." ))
      (*ja
       (p
	(p "サンプルプログラムの中にはGPLではなくLGPLのものもあります。")
	(p "ライセンスはサンプルプログラムに明記していますので、"
	   "再配布する場合は、ファイルの中身を良く確認してください。")
	(p "以下の手順で perl のサンプルプログラムを動かすことができます。")
	(p "尚、http proxyサーバーを経由した通信には対応していません。")
	(ul
	 (li "SOAP::Liteモジュールをインストールする")
	 (p "CPAN等からSOAP::Liteモジュールを取得してインストールしてください。")
	 (p "* Debianの場合は、libsoap-lite-perlパッケージをインストールしてください。")
	 (p "* ActivePerlの場合は ppm で SOAP::Liteモジュールをインストールしてください。")
	 (li "Crypt-SSLeayモジュールをインストールする")
	 (p "* Debianの場合は、libcrypt-ssleay-perlパッケージをインストールしてください。")
	 (p "* ActivePerlの場合は ppm で install http://theoryx5.uwinnipeg.ca/ppms/Crypt-SSLeay.ppdをインストールしてください。")
	 (li "SumibiWebApiSample.plを起動する")
	 (p "./SumibiWebApiSample.pl sumibi")
	 (p "[結果]")
	 (program "
version : 0.3.3
sexp    : KCgoaiAiw7qy0CIgMCAwKSAoaCAipLmk36TTIiAwIDEpIChrICKluaXfpdMiIDAgMikgKGwgInN1bWliaSIgMCAzKSkp
time    : 1
dump    : $VAR1 = [
          {
            'no' => '0',
            'type' => 'j',
            'word' => '炭火',
            'candidate' => '0'
          },
          {
            'no' => '0',
            'type' => 'h',
            'word' => 'すみび',
            'candidate' => '1'
          },
          {
            'no' => '0',
            'type' => 'k',
            'word' => 'スミビ',
            'candidate' => '2'
          },
          {
            'no' => '0',
            'type' => 'l',
            'word' => 'sumibi',
            'candidate' => '3'
          }
        ];
hiragana: すみび
"
		 )))))

     (*subsection
      "rubyからsumibi.orgのサービスを呼びだす"
      "Using sumibi.org with ruby"
      (*en
       (p "No documents in English, sorry..." ))
      (*ja
       (p
	(p "サンプルプログラムの中にはGPLではなくLGPLのものもあります。")
	(p "ライセンスはサンプルプログラムに明記していますので、"
	   "再配布する場合は、ファイルの中身を良く確認してください。")
	(p "以下の手順で ruby のサンプルプログラムを動かすことができます。")
	(ul
	 (li "Ruby 1.8.3をインストールする")
	 (li "SumibiWebApiSample.rbを起動する")
	 (p "./SumibiWebApiSample.rb sumibi")
	 (p "[結果]")
	 (program "
version : 0.6.0
sexp    : KCgoaiAiw7qy0CIgMCAwIDApIChoICKkuaTfpNMiIDAgMSAwKSAoayAipbml36XTIiAwIDIgMCkgKGwgInN1bWliaSIgMCAzIDApKSk=
time    : 1
dump    : 
 cand:0 no:0 spaces:0 type:j word:炭火
 cand:1 no:0 spaces:0 type:h word:すみび
 cand:2 no:0 spaces:0 type:k word:スミビ
 cand:3 no:0 spaces:0 type:l word:sumibi
hiragana: すみび
"
		 ))))))

    (*section
     "サンプルプログラム提供のおねがい"
     "Please send me your sample program."
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (p
       (p "Sumibiプロジェクトでは、SumibiWebAPIを様々な言語から試せるように、"
	  "様々な言語で書いたサンプルプログラムを集めています。")
       (p "貴方の得意な言語で書いた、分かりやすいサンプルプログラムを送って下さい。"
	  "次のリリースに含めさせて頂きます。")
       (p "送って頂く場合は、ライセンスを明記してください。"
	  "ライセンスは自由ですが、サンプルプログラムを元にクライアントソフトを作りたい人のためになるべくLGPLが良いと考えています。"))))

    ,W:sf-logo
    ))


;; ページの出力
(output 'api-testing (L:body))
