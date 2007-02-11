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
      (p
       (p "���Υɥ�����Ȥ�" ,W:Sumibi.org "���󶡤��Ƥ���褦���Ѵ������ӥ��򤴼�ʬ�Υ����Ȥ˥��åȥ��åפ�����ˡ����⤷�ޤ���")
       (p "Sumibi Server�� 0.5.5�ʾ�Υ������ǥ����ȥ�ӥ塼�����˴ޤޤ�Ƥ��ޤ���"))))

    (*section
     "Sumibi Server�Ȥϡ�"
     "About Sumibi Server"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (p
       (img (@ (src "shichirin.png")))
       (ul
	(li "Sumibi Server�ϡ�Sumibi�δ����Ѵ������ӥ����󶡤��륵���ФǤ���")
	(li "SOAP 1.1�˽�򤷤�API���Ѵ������ӥ����󶡤��ޤ���")
	(li "SOAP���б�������������줫�����Ѥ��뤳�Ȥ��Ǥ��ޤ���")))))
    (*section
     "���եȥ���������"
     "Structure"
     (*en
      (p "No documents in English, sorry..." ))
     (*subsection
      "�����ƥ๽����"
      "Structure of Sumibi system"
      (*ja
       (p
	(p "Sumibi�����ƥ�������Υ��եȥ���������ݡ��ͥ�Ȥ��鹽������Ƥ��ޤ���")
	(figure (@ (title "sumibi system diagram")
		   (src "sumibi_system_diagram")
		   (style "width:50%"))))))
     (*subsection
      "Sumibi Server�Υ��åȥ��åפ�ɬ�פʥ��եȥ�����"
      "Sumibi Server depends on these software"
      (*ja
       (p
	(p "������ " ,W:Sumibi.org "�����Ⱦ��ư���ǧ����Ƥ���С������Ǥ���(Debian sarge��ǳ�ǧ)")
	(p "�������ΥС������ʳ����ȹ礻�Ǥ�ư��뤫���Τ�ޤ���")
	(table
	 (thead
	  (tr
	   (td "���եȥ�����̾") (td "�С������") (td "Debian sarge�˴ޤޤ��")))
	 (tbody
	  (tr (td "Apache")            (td "1.3.x or 2.0.x")   (td "��"))
	  (tr (td "MySQL")             (td "4.1.x")            (td "��"))
	  (tr (td "Gauche")            (td "0.8.7 or later")   (td "��"))
	  (tr (td "Gauche-kakasi")     (td "0.1.0")            (td "��"))
	  (tr (td "Gauche-dbd-mysql" ) (td "0.2.2 or later")   (td "��"))
	  (tr (td "Perl")              (td "5.8.x or later")   (td "��"))
	  (tr (td "Perl SOAP::Lite")   (td "0.60 or later")    (td "��"))
	  (tr (td "Perl Jcode.pm")     (td "any version")      (td "��")))))))
     )

    (*section
     "������ˡ"
     "How to get it"
     (*en
      (p "No documents in English, sorry..." ))
     (*subsection
      "Sumibi Server�Υ����������ˡ"
      "How to Download"
      (*ja
       (p
	(p "��꡼���ѥå�������ʲ��Υ����Ȥ����������ɤ��Ƥ���������(0.5.5�ʾ�)")
	(*link "download" "http://sourceforge.jp/projects/sumibi/")
	))))
    
    (*section
     "���åȥ��å�"
     "How to Setup"
     (*en
      (p "No documents in English, sorry..." ))

     (*subsection
      "MySQL�˼���DB��ꥹ�ȥ�����"
      "Restore dictionary DB"
      (*ja
       (ol
	(li "sumibi���󥸥󤫤饢���������뤿��Υ�������Ȥ��������")
	(p "�� �ɤߤ������ѥ�������Ȥǹ����ޤ���")
	(li "����DB���������")
	(p "��)")
	(program "echo 'create database sumi_bincho_1  DEFAULT CHARACTER SET utf8;' | mysql -u ���ɥߥ�桼����")
	(li "����DB��ꥹ�ȥ�����")
	(p "��)")
	(program "mysql -u ���ɥߥ�桼����  sumi_bincho_1 < ����DB���᡼��"))))

     (*subsection
      "SumibiServer�Υǥץ�(����)"
      "deploy the sumibi server"
      (*ja
       (p
	"�ʲ��μ���SumibiWebAPI(SOAP�ץ�ȥ���)�ǥ���������ǽ��Sumibi�����С������ֲ�ǽ�Ǥ���"
	(ol
	 (li "Sumibi�Υǥ����ȥ�ӥ塼������Ÿ������make deploy���ޤ�")
	 (p "��)")
	 (program "
tar zxf sumibi-0.5.5.tar.gz
cd sumibi-0.5.5
make deploy
cd ..
ls -al
")
	 (li "���η�̡����Υե����뤬��������ޤ���")
	 (table
	  (thead
	   (tr
	    (td "�ե�����̾") (td "���")))
	  (tbody
	   (tr (td "sumibi")            (td "sumibi���󥸥�����"))
	   (tr (td "sumibi.cgi")        (td "sumibi���󥸥�������Ϥ�SOAP 1.1�ץ�ȥ�����Ѵ�����֥�å�"))
	   (tr (td "sumibi-0.5.5/lib")  (td "sumibi���󥸥󤬻��Ѥ���饤�֥��"))))))))
      
     (*subsection
      "sumibi ���󥸥������ե����� .sumibi ���Ѱդ���"
      "Prepare .sumibi file"
      (*ja
       (ol
	(li "Sumibi�Υǥ����ȥ�ӥ塼�����˴ޤޤ�� dot.sumibi.sample �� deploy���� sumibi���Τ�Ʊ���ǥ��쥯�ȥ�� .sumibi �Ȥ���̾������¸���ޤ���")
	(li ".sumibi��DB��³�ΰ٤Υѥ�᡼�����������ͤ��ѹ����ޤ���")
	(program
"
;; sumiyaki db
(define sumibi-sumiyakidb-host       \"myhostname\")
(define sumibi-sumiyakidb-name       \"sumi_bincho_1\")
(define sumibi-sumiyakidb-user       \"username\")
(define sumibi-sumiyakidb-password   \"password\")

;; sumibi db
(define sumibi-sumibidb-host         \"myhostname\")
(define sumibi-sumibidb-name         \"sumi_bincho_1\")
(define sumibi-sumibidb-user         \"username\")
(define sumibi-sumibidb-password     \"password\")

;; debug flag
(set! sumibi-debug #f)
"
)))))

    ,W:sf-logo
    ))


;; �ڡ����ν���
(output 'server-setup (L:body))
