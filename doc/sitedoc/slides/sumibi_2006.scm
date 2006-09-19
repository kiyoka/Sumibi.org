#!/usr/local/bin/gosh /usr/local/bin/sxmlcnv

(load "./common.scm")

(define (L:cover _title)
  `(
    (div
     (@ (class "background"))
     (object
      (@
       ;;                (type "image/svg+xml")
       (title ,_title)
       (id "head-logo")
       (data "sumibi_org_WASHIlogo_large.png"))
      (a
       (@ (href "http://www.sumibi.org/"))
       (img
        (@
         (src "sea1.png")
         (id "head-logo-fallback")
         (alt "picture of sea"))))))
    (div
     (@ (class "background slanty"))
     (img
      (@
       (src "sea1.png")
       (alt "picture of sea"))))
    (div
     (@ (class "slide cover"))
     (img
      (@ (src "sumibi_org_WASHIlogo_large.png ")
         (class "cover")
         (alt "Cover page images (Sumibi LOGO by WASHI)")))
     (br
      (@ (clear "all")))
     (h1 ,_title)
     (p
      (a
       (@ (href "http://www.netfort.gr.jp/~kiyoka/"))
       "Kiyoka Nishiyama")
      ",
<"
      (a
       (@ (href "mailto:kiyoka@netfort.gr.jp"))
       "kiyoka@netfort.gr.jp")
      ">"
      (br)
      (br)
      (br)
      (br)
      (br)
      (em
       "Hit the space bar for next slide")))))


(define (L:slide)
  '(
    (*slide "Sumibiの紹介"
            (*ul 
             (li "Sumibiはオープンソースの日本語入力メソッドです。")
             (li "Internet上のドキュメントを読み込んでひとりでに賢くなる新感覚の漢字変換エンジンを持っています。")
             (li (*link "sourceforge.jp" "http://sourceforge.jp/projects/sumibi/") "で開発しています。")
             (li ,W:GPL "のもとで配布されています。")
             (li "変換エンジンは" ,W:Gauche "で書かれています。")
             (li "Webブラウザからも使えます。")
             (p
              (*link
               (img
                (@ (src "sumibi_ajax.png")
                   (width "30%")))
               "http://www.sumibi.org/"))))
    (*slide "開発の動機"
            (h2 "開発の動機")
            (*ul
             (li "純粋な技術的興味と自分自身の必要性からSumibiを開発した"))
    
            (h2 "ものづくりに対する考えかた")
            (*ul-inc
             (li "できあがったものが、ありきたりでないこと(新規性・驚き)")
             (li "日常的に自分が使うもの")
             (li "作る過程が楽しいこと ( Just for fun )")
             (li "作るのに壮大な時間がかからないこと")))
    (*slide "開発の歴史(1)"
            (p "私のブログ『"
               (*link "kiyoka日記" "http://www.netfort.gr.jp/~kiyoka/diary/")
               "』を見ながら過去を追跡した結果です。")
            (*ul-inc
             (li "2004.8月")
             (*ul
              (li "Webで世のなかのカナ漢字変換エンジンを調べる")
              (li "Anthyすごい。開発者の使命感に気後れする。本当にこんな物に手を出して良いのか？という感じ")
              (li "PRIME面白い。")
              (li "自分はやっぱりSKKが好き。")
              (li "yc.elもちょっと試してみて好きになる。")
              (li "確率論の本をたくさん読みはじめる")
              (*ul
               (p "実はあんまり高度な話題はいまでも理解仕切れていません。")
               (p "読んでいる内にSumibiはそんなに高度な数学を使わなくてもできる筈というのが分かってきた")))))
    (*slide "開発の歴史(2)"
            (*ul-inc
             (li "2004.10月")
             (*ul
              (li "本当に実現可能か半信半疑のままスタートする")
              (li "辞書構築ツールから作り始める")
              (li "エンジンの開発をスタートする")
              (li "この頃は yc.elの代わりになるものを作ろうとしていた")
              (li "Emacsのみで動けば良いと考えていた"))
             (li "2004.12月")
             (*ul
              (li "エンジンがなんとなく動き始める")
              (li "sourceforge.jpにsumibiという名前でプロジェクトを登録する")
              (li "この間一人で悶絶しながら黙々と開発を続ける"))))
    (*slide "開発の歴史(3)"
            (*ul-inc
             (li "2005.1月")
             (*ul
              (li "EmacsからだましだましSumibiを使える様になる。")
              (li "sumibi.orgというドメイン取得")
              (li "Sumibi.pmをKato Atsushiさんが開発される"))
             (li "2005.3月")
             (*ul
              (li "Ajaxクライアントによる更なる発展")
              (li "Kato Atsushiさんの参加・開発でWebブラウザから使える様になった")
              (li "サイト" ,W:Sumibi.org "としてオープンした"))
             (li "2005.5月")
             (*ul
              (li "初の海外からの試運転"))))
    (*slide "開発の歴史(4)"
            (*ul-inc
             (li "2005.6月")
             (*ul 
              (li "SOAPに対応する(WSDLも公開)"))
             (li "2005.8月")
             (*ul
              (li "世界中からアクセスされはじめる"))
             (li "2005.9月")
             (*ul
              (li "日経IT Proで紹介される。")
              (li "気長に改善改善.... 多くの利用者がいることで、モチベーション維持がしやすい。")
              (li "オープンソースのマーケティングの重要性を痛感する。"))
             (li "2006.5月")
             (*ul
              (li ,W:infoteria "様よりサーバマシン提供を受ける"))))
    (*slide "開発の歴史(5)"
            (*ul-inc
             (li "2006.7月")
             (*ul
              (li "小飼弾さんのブログ、" , W:infoteria "の江島さんのブログで紹介される"))
             (li "2006.8月")
             (*ul
              (li "LL Ringでデモする"))
             (li "2006.9月")
             (*ul
              (li "現在( 本資料の作成、発表 )"))))
    (*slide "システム構成"
            (*ul-inc
             (li "SOAPでクライアント・サーバーが疎結合になっている")
             (p "SumibiWebAPI として定義されている"
                (img
                 (@ (src "sumibi_soap.png")
                    (width "30%"))))
             (li "サーバーはCGIで実装")
             (li "クライアントはSOAPが喋れれば何でも良い")))
    (*slide "システム構成:なぜSOAPか？"
            (*ul-inc
             (li "SOAPにするとクライアントが実装しやすい")
             (*ul
              (li "いろんなクライアントの実装が出てくることを期待" )
              (li "今後のscimクライアント等の登場を期待")
              (li "WSDLのおかげでクライアントの作者が楽できる"))
             (li "サーバのインストールは面倒なので誰かが用意してくれれば良い")
             (*ul
              (li "実際に" ,W:Sumibi.org "でサーバーを公開している"))))
    (*slide "システム構成:使用ソフトウェア"
            (*ul-inc
             (li "サーバー側の構成")
             (*ul
              (li ,W:Gauche "で書いた変換エンジン")
              (li "perl CGIで書いたSOAPサーバ")
              (li "辞書管理にはMySQLを使用している"))
             (li "クライアント側の構成")
             (*ul
              (li "Ajax(JavaScript言語)")
              (li "Emacs + curl (SOAPを喋らせる)")
              (li "Perl/Ruby/Pythonのサンプルもある"))
             (li "辞書構築ツール")
             (*ul
              (li ,W:Gauche "で書いた辞書構築ツール")
              (p "Wikipedia等普通のプレーンテキストの日本語文書からどんどん学習するツール"))))
    (*slide "システム構成:なぜGaucheか"
            (*ul-inc
             (li "漢字変換エンジンの様にアルゴリズム主体のプログラムは関数型言語でやるのが生産性が高い")
             (li ,W:Gauche "の特徴")
             (*ul
              (li ,W:Gauche "はschemeの処理系なので、関数型言語的な記述ができる")
              (p "処理を手順敵に書くのではなく、アルゴリズムを宣言的に定義する")
              (li "リスト処理等のライブラリが沢山そろっているので日本語処理を記述する場合、生産性が高い")
              (p "順列組合せライブラリが有ることや、mapやfilter関数等、公開関数を多用したプログラミングができる")
              (li "マルチバイト(utf-8)をネイティブでサポートしている")
              (p "正規表現で [あ-ん] 等の様に記述できる"))))
    (*slide "システム構成:なぜMySQLか"
            (*ul-inc
             (li " MySQLは検索性能が速い")
             (p "日本語変換エンジンは反応速度においてシビアな要求がある。MySQLはまずまずの性能")
             (li "開発時間の短縮のため")
             (*ul
              (li "Sumibiの場合、データの持ち方に新規性はない")
              (li "SQLを使って、統計データの集計を簡潔に書ける")
              (p "場合によってはschemeでやるより宣言的な簡潔な記述が可能"))
             (li " Sumibiサーバの運用形態とマッチしている")
             (p "Sumibiエンジンを運用しながら、辞書構築を行なえる")))
    (*slide "システム構成:なぜEmacsクライアントか"
            (*ul-inc
             (li "作者がEmacs星に住んでいるため")
             (p "逆に言うと、作者はscim等のデスクトップのインターフェースは必要としていない")
             (p "誰か作ってください ^_^;")
             (li "※ ユーザーがおそらく自分しかいない(笑)")))
    (*slide "システム構成:なぜAjaxか"
            (*ul-inc
             (li "マーケティング重要")
             (*ul-inc
              (li "簡単なデモサイトがあったほうが開発者を集めやすい")
              (li "日本語変換なんてやってることが地味すぎるので、それを見える形にしたかった"))
             (li ,W:kato "さんの存在")
             (*ul-inc
              (li ,W:kato "さんは" ,W:Sumibi.org "のトップページのAjax版の作者です")
              (li "Ajaxを使って何か作ってみたい" ,W:kato "さんと作者(kiyoka)のタイミングの良い出会い")
              (p "最初はKansai.pmでの、世間話から発展"))
             (li "結果的に海外在住の方の必須ツールとなる")
             (p 
              "過去一年の" ,W:Sumibi.org "に来る日本語変換回数のグラフ"
              (img
               (@ (src "all_sumibi_year.png")
                  (width "30%")
                  )))))
    (*slide "アルゴリズム"
            "
  あたかも高い変換精度の実現
    ある程度のあきらめを行うことによって、あたかも変換精度が高そうに見える。
    1. 統計的アプローチ(全てヒューリスティック)
2. 品詞情報はない ( SKKと同様の送りがな情報だけが存在する )
3. 人間が分かち書きする
    次の二つのデザインポリシーの結果の産物
      デザインポリシー: ソフトウェアはKISSで ( Keep it simple, stupid! )
      デザインポリシー: 人間が得意なことは人間に、コンピューターが得意なことはコンピューターに。現実的解決。
")
    (*slide "アルゴリズム:なぜ統計的アプローチか"
            "
環境が整った
  書籍
  Wikipediaのような良質な日本語テキストが出来てきた。しかも大量に
")
    (*slide "アルゴリズム:なぜ分かち書きか"
            "    
  人間観察の結果出てきた割り切り
  WindowのIMEを使っている人の行動を日々観察していた。
    → 文節区切り間違いをちまちま直す人は殆どいない。
       もういちど最初から文章を打ちこみ直しして、文節区切り間違いの前まででいったん変換している。
       → 面倒なインターフェースは使われない
    → 連文節でどんどん文章を入力する人は殆どいない。

       
")
    (*slide "アルゴリズム:参考文献"
            (p "自然言語処理プログラムを作ってみようと思われた方向け")
            "
")
    (*slide "個人的な不満"
            "
  なぜ、sumibi.el(Emacsクライアント)のユーザが増えない？
  きっとSKKユーザに気にいってもらえるはず。
"
            )
    (*slide "デザインポリシー:No config is good config")
    (*slide "デザインポリシー:Less is more")
    ))


;; ページの出力
(let1 title "世界の果てから漢字変換 Sumibiの開発 2006"
      (output
       title
       (L:cover title)
       (L:slide)))


;; MLやセミナーの紹介文
(define _intro
  "統計的学習機能をもつ漢字変換エンジン Sumibi の開発の経緯や構成について紹介します。
  技術的興味から始まったプロジェクトがSumibi.orgとして広く使われるようになった、異例のプロジェクトに興味を持って頂けると幸いです。
  そして、ぜひユーザーになってください。"
  )

(define _comment
 "
  1. 分かち書で人間が文節区切りを指定することで、文節区切り間違いを無くす。
  2. 

辞書の学習方法


")
