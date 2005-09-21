#!/usr/local/bin/gosh /usr/local/bin/sxmlcnv


(load "./common.scm")


(define (L:body)
  '(
    (*section
     "Sumibi.orgのブライバシーポリシー"
     "Privacy policy of Sumibi.org"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (p
       (ul
	(li "ユーザー登録が必要なサービスは行なっていないため、個人情報は扱っていません。")
	(li "ローマ字漢字変換等の処理のためにユーザーが送った文章はサーバーに記録されません。")
	(p "但し、ユーザーが使用するWebブラウザの種類やIPアドレスは記録されます。")
	(p "この情報はSumibi.orgの負荷状況を把握し、サービス品質を維持するために使用されます。")))))

    ,W:sf-logo
    ))

;; ページの出力
(output 'privacy-policy (L:body))
