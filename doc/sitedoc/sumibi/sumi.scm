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
       (li "Sumibi�ν�����ּ��� (6.1M) [md5=de099411b35c77567d0dcecd559ad0cc]"
	   (*link "[sumi_bincho_1_starter.sql.gz]" "sumibi_dist/sumi_bincho_1_starter.sql.gz"))
       (p "SKKJISYO��Ϣ�Τ��ɤߤ������ΤǤ���")
       (li "small����")
       (ul
	(li "������(�������Ѳ�ǽ) (48M) [md5=ab558521f736a1e6911d79149ad5cc95]"
	    (*link "[sumi_bincho_1_small.sql.gz]" "sumibi_dist/sumi_bincho_1_small.sql.gz"))
	(p "Wikipedia���ܸ��Ǥ�������10000�ե������ɤߤ��������Ǥ����������Ѥ���ǽ�Ǥ���")
	(p "Ĺ���ֻȤäƤߤ����ФǤϡ�����Ū��������հʳ������Ӥ˻Ȥ��ˤϽ�ʬ���Ѵ����٤���äƤ���Ȼפ��ޤ���")
	(p "������դ��Ѵ����٤�夲�뤿��ˤϤ���small��������ˤ��ơؤϤƤʡ٤ʤɤ�������դ�¿���ޤޤ��"
	   "����ƥ�Ĥ�¿���ɤ߹���ɬ�פ�����ޤ���"))
       (li "medium����")
       (ul
	(li "������(�������Ѳ�ǽ) (115M) [md5=3f45b3881f4ee4c2b1b318c7521d2eb7]"
	    (*link "[sumi_bincho_1_medium.sql.gz]" "sumibi_dist/sumi_bincho_1_medium.sql.gz"))
	(p "Wikipedia���ܸ��Ǥ�������50000�ե������ɤߤ��������Ǥ����������Ѥ���ǽ�Ǥ���")
	(p "Ĺ���ֻȤäƤߤ����ФǤϡ�small���⤵��ˡ��Ѵ����٤��夬�äƤ��ޤ���")
	(p "â��small��Ʊ���褦��������դ��Ѵ����٤Ϲ⤯����ޤ���"))
       (li "large����, huge����")
       (p "�缡���������Ƥ���ͽ��Ǥ�������ԥ塼��������ǽ����Ǵ�����������ޤ�ޤ���"))))

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
	(p "���μ��񷲤�ù�����SKK-JISYO.sumibi_starter�Ȥ��������������������sumiyaki�ġ�����ɤߤ�������֤�Sumibi����ν�����֤Ȥ��Ƥ��ޤ���"
	   "SKK-JISYO.sumibi_starter�����������ˤĤ��Ƥ� CVS���dict/Makefile �Ǽ�ư������Ƥ��ޤ���")
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
