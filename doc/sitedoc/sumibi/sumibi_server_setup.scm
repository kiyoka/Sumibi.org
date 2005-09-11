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
       (p "Sumibi Server��CVS��ݥ��ȥ�ˤ���¸�ߤ��ޤ��󡣥��åȥ��åפϼ㴳�ѻ��ʤΤǤ�������λ������������")
       (p "���!! : �ޤ�Sumibi�μ���ǡ�����������Ƥ��ޤ��󡣤��Ф餯���Ԥ���������"))))

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
	(p "������Sumibi.org�����Ⱦ��ư���ǧ����Ƥ���С������Ǥ���(Debian sarge��ǳ�ǧ)")
	(p "�������ΥС������ʳ����ȹ礻�Ǥ�ư��뤫���Τ�ޤ���")
	(table
	 (thead
	  (tr
	   (td "���եȥ�����̾") (td "�С������") (td "Debian sarge�˴ޤޤ��")))
	 (tbody
	  (tr (td "Apache")            (td "1.3.x or 2.0.x")   (td "��"))
	  (tr (td "MySQL")             (td "4.1.x")            (td "��"))
	  (tr (td "Gauche")            (td "0.8.3 or later")   (td "��"))
	  (tr (td "Gauche-kakasi")     (td "0.1.0")            (td "��"))
	  (tr (td "Gauche-dbi" )       (td "0.1.4")            (td "��"))
	  (tr (td "Gauche-dbd-mysql" ) (td "0.1.4")            (td "��"))
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
	(p "��꡼���ѥå������Ϥޤ�����ޤ���CVS����ƿ̾CVS��ľ�ܥ�������ɤ��Ƥ���������")
	(program "
cvs -d:pserver:anonymous@cvs.sourceforge.jp:/cvsroot/sumibi login
cvs -z3 -d:pserver:anonymous@cvs.sourceforge.jp:/cvsroot/sumibi co sumibi
")
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
	(program "
mysqladmin -u ���ɥߥ�桼����  create sumi_bincho_1")
	(li "����DB��ꥹ�ȥ�����")
	(p "��)")
	(program "
mysql -u ���ɥߥ�桼����  sumi_bincho_1 < ����DB���᡼��"))))

     (*subsection
      "sumibi���󥸥�Υ饤�֥�ꥤ�󥹥ȡ���"
      "Install the library files for sumibi engine"
      (*ja
       (ol
	(li "CVS�� sumibi/lib �ʲ��� Gauche�Υ饤�֥��ѥ��˥��ԡ����Ƥ���������")
	(p "��)")
	(program "
mkdir -p /usr/share/gauche/site/lib/sumibi/
/bin/cp sumibi/lib/* /usr/share/gauche/site/lib/sumibi/ "))))

     (*subsection
      "cgi��Ϣ�Υ��󥹥ȡ���"
      "install the cgi"
      (*ja
       (p
	(p "���󥹥ȡ��뤹�٤��ե�����ϰʲ��Τ�ΤǤ���")
	(table
	 (thead
	  (tr
	   (td "CVS��Υե�����") (td "���ԡ����̾��") (td "���")))
	 (tbody
	  (tr (td "sumibi")              (td "sumibi")         (td "sumibi���󥸥�����"))
	  (tr (td "dot.sumibi.sample")   (td ".sumibi")        (td "sumibi���󥸥�������ե�����"))
	  (tr (td "sumibi.cgi")          (td "sumibi.cgi")     (td "sumibi���󥸥�������Ϥ�SOAP 1.1�ץ�ȥ�����Ѵ�����֥�å�")))))))

     (*subsection
      "sumibi �� sumibi.cgi �Υ��󥹥ȡ���"
      "install the sumibi and sumibi.cgi"
      (*ja
       (ol
	(li "CVS�� sumibi/sumibi �� sumibi/server/sumibi.cgi �� Apache��cgi�¹ԥǥ��쥯�ȥ�˥��ԡ����ޤ���"))))

     (*subsection
      "sumibi ���󥸥������ե����� .sumibi ���Ѱդ���"
      "Prepare .sumibi file"
      (*ja
       (ol
	(li "CVS�� dot.sumibi.sample �� cgi-bin�ǥ��쥯�ȥ�� .sumibi �Ȥ���̾������¸���ޤ���")
	(li ".sumibi��DB��³�ΰ٤Υѥ�᡼�����������ͤ��ѹ����ޤ���")
	(p "�� sumiyakidb�����ϡ����������ɬ�פϤ���ޤ���(�����������ϡ�������ä���ġ���sumiyaki�ѤǤ�)")
	(program
"
;; sumiyaki db
(define sumibi-sumiyakidb-name       \"host=localhost;db=sumi_bincho_1\")
(define sumibi-sumiyakidb-user       \"username\")
(define sumibi-sumiyakidb-password   \"password\")

;; sumibi db
(define sumibi-sumibidb-name         \"host=localhost;db=sumi_bincho_1\")
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
