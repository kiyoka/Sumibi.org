#!/usr/local/bin/gosh /usr/local/bin/sxmlcnv


(load "./common.scm")


(define (L:body)
  '(
    (*section
     "���Υɥ�����ȤˤĤ���"
     "About this document"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (p "���Υɥ�����Ȥϡ�ú��(Sumibi����)�Υ�������ɤȥ��󥹥ȡ���ˤĤ��Ʋ��⤷����ΤǤ���")))

    (*section
     "ú�Ȥ�"
     "About Sumi"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (ul
       (li "ú�Ȥϡ�Sumibi����Τ��ȤǤ���")
       (li "Internet��˥ɥ�����ȷ��򥳡��ѥ��Ȥ������Ѥ���sumiyaki(ú�Ƥ�)�Ȥ����ġ���ǹ��ۤ��Ƥ��ޤ���")
       (li "ú�κ����ˤ�����ʻ��֤������뤿�ᡢ���Υڡ��������ۤ��Ƥ��ޤ���")
       (li "�����ϡ�MySQL��mysqldump���᡼���Ǥ���"))))

    (*section
     "���������"
     "Download"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (ul
       (li "Sumibi�ν�����ּ��� (6.1M) " (*link "[sumi_bincho_1_starter.sql.gz]" "sumi_bincho_1_starter.sql.gz"))
       (p "SKKJISYO��Ϣ�Τ��ɤߤ������ΤǤ���")
       (li "small����")
       (ul
	(li "�Ȥꤢ������(���������Բ�) (33M) " (*link "[sumi_bincho_1_small_hisyouyou.sql.gz]" "sumi_bincho_1_small_hisyouyou.sql.gz")
	(p "Linux JFʸ�����Ƥȡ�Wikipedia���ܸ��Ǥΰ������ɤߤ��������Ǥ���"
	   "Linux JFʸ���Ȥä���̡��������Ѥ��Ǥ��ޤ���")
	(p "�������ѤΤǤ��뼭����ۤ��뤿�ᡢLinux JF��Ȥ�ʤ������Ǽ������ʤ������Ȥ�ͤ��Ƥ��ޤ���")
	
	(li "������(�������Ѳ�ǽ)" "[sumi_bincho_1_small.sql.gz]")
	(p "Wikipedia���ܸ��Ǥ������ɤߤ��������Ǥ����������Ѥ���ǽ�Ǥ���")
	(p "2006ǯ 1���δ���ͽ��Ǥ���")))
       (li "medium����")
       (p "�ͤν�ͭ�ޥ���ν�����ǽ���餹��� 2006ǯ3��� 6��餤�δ���ͽ��Ǥ���"
	  "��������ǽ�Υޥ���򤪻��������˼����äƤ���������ȡ���������ä���ޤ��ǽ��������ޤ���"
	  "(�⤷��Athron64 +3000 �ᥤ�����2GByte�Υޥ����Ȥ��к����� 1/10�λ��֤Ǵ�λ���뤳�Ȥ��狼�äƤ��ޤ�����
���ߤ��ζ��Ϥʥޥ����Sumibi.org���Ѵ������С����ѵ��Ȥ��Ʊ��Ѥ��Ƥ��ޤ��Τǡ������ۤ˻Ȥ����ȤϤǤ��ޤ���)")

       (p
	"(Athron64 +3000 2GByte RAM) : (Celeron 1G 512MByte RAM) = 10 : 1")
       (li "large����, huge����")
       (p "medium���񤬴������衢�������Ƥ���ͽ��Ǥ�������ԥ塼��������ǽ����Ǵ�����������ޤ�ޤ���"))))

    (*section
     "���󥹥ȡ���"
     "Install"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (p "���󥹥ȡ�����ˡ�� gzip�ǰ��̤�򤤤ơ�" (*link "SumibiServerSetup" "sumibi_server_setup.html")
	 "�Ǽ�����ˡ��MySQL��ή������ǲ�������")))

    (*section
     "�����������饤���󥹤ˤĤ���"
     "About License"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (p
       (p "Sumibi�Ѽ���ǡ��� sumi_bincho_1_* �ϰʲ��Υ���ƥ��(�Ǻ�)�����Ѥ��ƺ�������Ƥ��ޤ���")
       (ol
	(li "SKKJISYO��Ϣ")
	(p "���μ��񷲤�ù�����SKK-JISYO.sumbi_starter�Ȥ��������������������sumiyaki�ġ�����ɤߤ�������֤�Sumibi����ν�����֤Ȥ��Ƥ��ޤ���"
	   "SKK-JISYO.sumbi_starter�����������ˤĤ��Ƥ� CVS���dict/Makefile �Ǽ�ư������Ƥ��ޤ���")
	(table 
	 (thead
	  (tr  (td "����̾") (td "�饤����")))
	 (tbody
	  (tr   (td "SKK-JISYO.L")                (td "GPL"))
	  (tr   (td "SKK-JISYO.geo")              (td "GPL"))
	  (tr   (td "SKK-JISYO.jinmei")           (td "GPL"))
	  (tr   (td "SKK-JISYO.propernoun")       (td "GPL"))
	  (tr   (td "SKK-JISYO.station")          (td "GPL"))
	  (tr   (td "SKK-JISYO.zipcode")          (td "public domain"))
	  (tr   (td "SKK-JISYO.office.zipcode")   (td "public domain"))
	  ))

	(li "Linux JFʸ��")
	(p (*link "JF ʸ�������������ۡ���󥯤ˤĤ���" "http://www.linux.or.jp/JF/copyright.html") 
	   "���ɤ�¤ꡢ�饤���󥹤ˤĤ��Ƥϳ�ʸ��˽���ɬ�פ���ޤ��������������Ѥκ����ۤ����¤�ݤ��Ƥ���ʸ�񤬴ޤޤ�Ƥ��ޤ���"
	   "�����ޤ�Sumibi������������ɤ��ƻ��Ѥ�����ϡ��������Ѥ��Ǥ��ʤ����Ȥˤʤ�ޤ���")

	(p "���Ȥꤢ������(���������Բ�) (33M) " (*link "[sumi_bincho_1_small_hisyouyou.sql.gz]" "sumi_bincho_1_small_hisyouyou.sql.gz") "�Ǥ�"
	   (*link "Linux JFʸ���html��" "http://www.linux.or.jp/JF/JFdocs/JFhtml.tar.gz") "���Ƥ��ɤߤ���Ǥ��ޤ���")

	(li "Wikipedia���ܸ���")
	(p "�饤���󥹤ϡ�" ,W:GFDL "�Ǥ���")
	(p (*link "Wikipedia:�������" "http://ja.wikipedia.org/wiki/Wikipedia:%E8%91%97%E4%BD%9C%E6%A8%A9") "�˲��⤬�Ǻܤ���Ƥ��ޤ��Τǡ����Ȥ��Ƥ���������")
	(p "�嵭�Υڡ����ˤϡإ������ڥǥ����Υ���ƥ�Ĥϡ�¾�ο͡����Ф���Ʊ�ͤμ�ͳ��ǧ�ᡢ�������ڥǥ��������Υ������Ǥ��뤳�Ȥ�
�Τ餻��¤�ˤ����ơ�ʣ�������ѡ������ۤ��뤳�Ȥ��Ǥ��ޤ����٤Ȳ��⤵��Ƥ��ޤ���")
	(p "�ĤޤꡢSumibi����Wikipedia���ܸ��Ǥ�ޤ�Ǥ��Ƥ⡢���λݤ���������к����۲�ǽ�Ǥ���")))))

    ,W:sf-logo
    ))


;; �ڡ����ν���
(output 'sumi (L:body))
