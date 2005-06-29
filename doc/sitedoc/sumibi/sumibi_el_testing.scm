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
      (p "���Υɥ�����Ȥϡ�sumibi.el 0.3.2�ˤĤ��Ƥβ���Ǥ���")))

    (*section
     "sumibi.el����ħ"
     "features"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (ul
       (li "��ñ���󥹥ȡ���")
       (p "sumibi.el����ɤ��������¨�Ȥ��ޤ���")
       (p "(�Ѵ������С���sumibi.org���󶡤��Ƥ��ޤ�����ʬ���Ѵ������С����Ѱդ��ʤ��Ƥ�Ȥ��Ϥ�뤳�Ȥ��Ǥ��ޤ���)")
       (li "�⡼�ɥ쥹")
       (p "���ܸ����ϥ⡼�ɤȤ�����ǰ������ޤ���Emacs�Хåե������Ϥ������޻�ʸ�����ľ�ܡ������Ѵ��Ǥ��ޤ���")
       (p "�⤦���ܸ�/��ñ���ڤ��ؤ��ǥ��饤�餹��Ȥ������Ȥ�����ޤ���")
       (li "����ץ�ʥ桼�������󥿡��ե�����")
       (p "�ʤ�٤����ʤ����������Ǥ���褦���߷פ��Ƥ��ޤ���û�����֤ǳФ��뤳�Ȥ��Ǥ��ޤ���"))))

    (*section
     "���󥹥ȡ���"
     "How to install"
     (*en
      (p "No documents in English, sorry..." ))

     (*ja
      (ol
       (li "sumibi.el��Emacs�Υ��ɥѥ��˥��ԡ����ޤ���")
       (p "Emacs�Υ��ɥѥ���Ĵ�٤�ˤϡ�Emacs ��ư�塢 M-x describe-variable ���ѿ��������ޥ�ɤ�¹Ԥ���"
	  "�ѿ� load-path ����ꤷ�����Ƥ�Ĵ�٤Ƥ���������")
       (li "curl �򥤥󥹥ȡ��뤷�ޤ���")
       (p "�ۤȤ�ɤΥǥ����ȥ�ӥ塼������ curl ���ޥ�ɤ����ݡ��Ȥ���Ƥ��ޤ���")
       (p "�ʲ��Υǥ����ȥ�ӥ塼�����Ǥ� curl��ɸ��ǥ��ݡ��Ȥ���Ƥ��뤳�Ȥ��ǧ���ޤ�����")
       (ul
	(li "Debian GNU/Linux 3.0 �ڤ� 3.1")
	(li "Red Hat Enterprise 3.0 �ڤ� 4.0")
	(li "Cygwin ( �ǿ��� )"))
       (p "https�ץ����������С�����Ѥ���ˤϰʲ�����Τ褦�˴Ķ��ѿ������ꤹ��ɬ�פ�����ޤ���")
       (program
	"export http_proxy=http://your.proxy.server:8080/\n"
	"export https_proxy=http://your.proxy.server:8080/")
       (li ".emacs�˼��Υ����ɤ��ɲä��ޤ���")
       (program
	"(load \"sumibi\")\n")
       (p 
	"���ѿ� sumibi-server-use-cert �� nil �ˤ����SSL����������Ѥ��ʤ��Ƥ��̿��Ǥ��ޤ���"
	"â������������Ǥ�Sumibi Server�Ȥ��̿��ΰ��������㲼���ޤ��Τǡ�"
	"sumibi.org���󶡤��Ƥ���Sumibi Server�����Ѥ�����ϡ�SSL����������Ѥ�����򤪴��ᤷ�ޤ���")
       (li "Emacs��Ƶ�ư����Emacs�Υ⡼�ɥ饤��� \"Sumibi\"��ʸ����ɽ�������������Ǥ���")
       (p
	(img (@ (src "modeline.png")))))))


    (*section 
     "�������"
     "Key bindings"

     (*en
      (p "No documents in English, sorry..." ))

     (*subsection
      "�Ѵ�"
      #f
      (*ja
       (ol
	(li "����Ū�ʻȤ�����")
	(p "Emacs�Υ⡼�ɥ饤���\"Sumibi\"��ʸ�����ФƤ���� C-j�����Ǥ����ʤ��Ѵ��Ǥ��ޤ���")
	(ul
	 (li "(������)")
	 (program
	  "sumibi de oishii yakiniku wo tabeyou . [C-j]")
	 (li "(���  )")
	 (program
	  "ú�ФǤ������������򿩤٤褦��"))
	(li "'/' ������Ѵ��ϰϤ���ꤹ�롣")
	(ul
	 (li "(������)")
	 (program
	  "sumibi de oishii /yakiniku wo tabeyou . [C-j]")
	 (li "(���  )")
	 (program
	  "sumibi de oishii �����򿩤٤褦��"))
	(li ".h �� .k �᥽�åɤǤҤ餬�ʡ��������ʤ˸��ꤹ�롣")
	(ul
	 (li "(������)")
	 (program
	  "sumibi.h de oishii.k yakiniku wo tabeyou . [C-j]")
	 (li "(���  )")
	 (program
	  "���ߤӤǥ������������򿩤٤褦��")))))

     (*subsection 
      "��������"
      #f
      (*ja
       (ol
	(li "�Ȥˤ�����������򳫻Ϥ���ˤ�")
	(ul
	 (li "�������뤬ʸ���ˤ�����֤�[C-j]�򲡤���")
	 (p
	  (img (@ (src "before_select1.png"))))
	 (li "C-j�򲡤��ȡ���������⡼�ɤ˰ܹԤ��ޤ���")
	 (p
	  (img (@ (src "select1.png")))))
	(li "ʸ�Ϥ����椫���������򳫻Ϥ���ˤ�")
	(ul
	 (li "�������򤷤���ʸ��˥���������碌��[C-j]�򲡤���")
	 (p
	  (img (@ (src "before_select2.png"))))
	 (li "��������⡼�ɤ˰ܹԤ��ޤ���")
	 (p
	  (img (@ (src "select2.png")))))
	(li "����ν�����")
	(ul
	 (li "[C-j]�Ǽ����Ѵ����䤬���֤˽ФƤ��ޤ���")
	 (p
	  (img (@ (src "select3.png")))))

	(li "�������򥭡�������")
	(table 
	 (thead
	  (tr  (td "���Υ������") (td "����Υ������") (td "���������")))
	 (tbody
	  (tr   (td "C-m")   (td "")      (td "�����������"))
	  (tr   (td "C-g")   (td "q")     (td "�������򥭥�󥻥�"))
	  (tr   (td "C-b")   (td "b")     (td "������ʸ��˰�ư"))
	  (tr   (td "C-f")   (td "f")     (td "������ʸ��˰�ư"))
	  (tr   (td "C-a")   (td "a")     (td "�ǽ��ʸ��˰�ư"))
	  (tr   (td "C-e")   (td "e")     (td "�Ǹ��ʸ��˰�ư"))
	  (tr   (td "C-j")   (td "space") (td "���θ�����ڤ꤫����"))
	  (tr   (td "C-n")   (td "n")     (td "���θ�����ڤ꤫����"))
	  (tr   (td "C-p")   (td "p")     (td "���θ�����ڤ꤫����"))
	  (tr   (td "")      (td "j")     (td "��������������ڤ꤫����"))
	  )))))
	 

     (*subsection
      "�Ѵ��Υ���"
      #f
      (*ja
       (ul
	(li "�ʤ�٤�Ĺ��ʸ�Ϥ��Ѵ����롣")
	(p
	 "Sumibi���󥸥�Ϥʤ�٤�Ĺ��ʸ�Ϥ����Ѵ������ۤ����Ѵ����٤��夬��ޤ���\n"
	 "��ͳ�ϡ�Sumibi���󥸥�λ��Ȥߤˤ���ޤ���\n"
	 "Sumibi���󥸥��ʸ̮��������Ū�ˤɤ�ñ�줬�����������Ƚ�Ǥ��ޤ���\n")
	(li "SKK�μ���˴ޤޤ�Ƥ�������ñ�����ꤹ�롣")
	(p
	 "SKK�˴���Ƥ���ͤǤʤ��ȴ��Ф��Ĥ���ʤ����⤷��ޤ��󤬡�\"�Ѵ�����\"�Τ褦��¿����ʣ���\n"
	 "�Ϻǽ餫�鼭�����Ͽ����Ƥ���Τǡ�\"henkanseido\"�Ȥ������˻��ꤹ��ȡ��μ¤��Ѵ��Ǥ��ޤ���\n")))))

    (*section
     "�б��Ķ�"
     "Environment"
     (*en
      (p "No documents in English, sorry..." ))

     (*ja
      (ul
       (p "¿���δĶ���ư���Ϥ��Ǥ����ʲ��δĶ���ư���ǧ�ѤߤǤ���")
       (li "Emacs�Ķ�")
       (ul
	(li "Emacs 21.x�ʾ�")
	(li "XEmacs 21.x�ʾ�")
	(li "Meadow 2.00 + Cygwin�ǿ���")
	(li "apel 10.3�ʾ�")
	(li "curl 7.9.5�ʾ�"))
       (li "�ǥ����ȥ�ӥ塼�����")
       (ul
	(li "Debian GNU/Linux 3.0/3.1")
	(li "RedHat Enterprise 3.0/4.0")
	(li "Cygwin�ǿ���")))))

    (*section
     "�������ޥ���"
     "How to customize"
     (*en
      (p "No documents in English, sorry..." ))

     (*ja
      (ul
       (li "M-x customize-group ��¹Ԥ��ƥ��롼�פ� 'sumibi' ����ꤹ��Х������ޥ������̤�ɽ������ޤ���")
       (li "sumibi.el�ˤϰʲ��Υ������ޥ������ܤ�����ޤ���")
       (ol
	(li "sumibi-server-url")
	(p "�Ѵ������С���URL����ꤷ�ޤ����ǥե���ȤǤ� sumibi.org ���Ѵ������С���Ȥ��褦�ˤʤäƤ��ޤ��Τ�"
	   "�ѹ����ʤ��Ƥ�Ȥ��ޤ���")
	(p "�������Ѵ������С������Ѥ�����Ϥ���������������С���URL���ѹ����Ƥ���������")
	(li "sumibi-server-cert-data")
	(p "sumibi.org �Ѥ�SSL������ǡ����Ǥ���")
	(li "sumibi-server-use-cert")
	(p "SSL�������[���Ѥ���/���ʤ�]����ꤷ�ޤ���( t �� nil �ǻ��ꤷ�ޤ���)")
	(li "sumibi-server-timeout")
	(p "�Ѵ������С��Ȥ��̿������ॢ�����ÿ�����ꤷ�ޤ���")
	(li "sumibi-stop-chars")
	(p "C-j �����ǥ��޻����Ѵ���������Ѵ�ʸ�Ϥ����ʸ������ꤷ�ޤ���\n"
	   "sumibi.el�� C-j �����򲡤����ȥ���������֤������������� sumibi-stop-chars ��������줿���ʸ���˥ޥå�����ޤǤ��ܺ������Ѵ��оݤȤ��ޤ���")
	(li "sumibi-curl")
	(p "curl���ޥ�ɤ����Хѥ�����ꤷ�ޤ����̾���ѹ�����ɬ�פϤ���ޤ���")))))

    ,W:sf-logo
    ))


;; �ڡ����ν���
(output 'el-testing (L:body))


