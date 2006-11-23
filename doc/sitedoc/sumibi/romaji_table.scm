#!/usr/local/bin/gosh


(use sumibi.romkan)
(load "./common.scm")


(define (L:body)
  `(
    (*section
     "ローマ字-仮名対応表"
     "romaji - kana table"
     (*ja
      (ul 
       (li "最新のSumibiエンジンのローマ字-仮名対応表です。")
       (li "最新のtestingバージョンに追従しています。")
       (li "ローマ字の文字数の長いものから順に並べています。")))
     (*en
      (ul 
       (li "This is a romaji - kana table. Please see Japanese page.")))

     (*subsection
      "表"
      "table"
      (*ja
       (table
        (thead
         (tr
          (td "ローマ字")(td "仮名")))
        (tbody
         ,(map
           (lambda (x)
             `(tr (td ,(car x))
                  (td ,(cdr x))))
           (generate-roman->kana-table)))))
      (*en
       (p
        ("sorry , Japanese only ...")))))))
     

;; ページの出力
(output 'romaji-table (L:body))
