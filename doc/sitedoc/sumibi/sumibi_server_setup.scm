#!/usr/local/bin/gosh /usr/local/bin/sxmlcnv


(load "./common.scm")


(define (L:body)
  '(body
    ,L:tab

    (*section
     "���Υɥ�����ȤˤĤ���"
     "About this document"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (p
       (p "���Υɥ�����Ȥ�" ,W:Sumibi.org "���󶡤��Ƥ���褦���Ѵ������ӥ��򤴼�ʬ�Υ����Ȥ˥��åȥ��åפ�����ˡ����⤷�ޤ���")
       (p "Sumibi Server��CVS��ݥ��ȥ�ˤ���¸�ߤ��ޤ��󡣥��åȥ��åפϼ㴳�ѻ��ʤΤǤ�������λ������������"))))

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
      "������"
      "Structure"
      (*ja
       (p "�ʲ��οޤ褦�������Υ��եȥ���������ݡ��ͥ�Ȥ��Ȥߤ��碌�ƹ�������ޤ�")
       ;;(img (@ (src "modeline.png")))
       )))

    (*section
     "������ˡ"
     "How to get it"
     (*en
      (p "No documents in English, sorry..." ))
     (*subsection
      "��������ɾ��"
      "Download"
      (*ja
       (p
	(p "��꡼���ѥå������Ϥޤ�����ޤ���CVS����ƿ̾CVS��ľ�ܥ�������ɤ��Ƥ���������")
	(program "
cvs -d:pserver:anonymous@cvs.sourceforge.jp:/cvsroot/sumibi login
cvs -z3 -d:pserver:anonymous@cvs.sourceforge.jp:/cvsroot/sumibi co sumibi
")
	))))
    
    ,W:sf-logo
    ))


;; �ڡ����ν���
(output 'server-setup (L:body))
