#!/usr/local/bin/gosh /usr/local/bin/sxmlcnv


(load "./common.scm")


(define (L:body)
  '(body
    ,L:tab

    (*section
     "���󥹥ȡ���"
     "How to install"
     (*en
      (p "No documents in English, sorry..." ))

     (*ja
      (ol
       (li "Emacs��apel-10.6�ʾ�򥤥󥹥ȡ��뤷�ޤ���")
       (li "sumibi.el��Emacs�Υ����ɥѥ��˥��ԡ����ޤ���")
       (li "CAcert.crt��Ŭ���ʾ��˥��ԡ����ޤ��� (��: /home/xxxx/emacs �ǥ��쥯�ȥ꡼�ʤ� )")
       (li "curl 7.9.5�ʾ��SSL��ǽ��ͭ���ˤ��ƥӥ�ɤ������󥹥ȡ��뤷�ޤ���")
       (p "�ʲ��Υǥ����ȥ�ӥ塼�����Ǥ� curl��ɸ��ǥ��ݡ��Ȥ���Ƥ��뤳�Ȥ��ǧ���ޤ�����")
       (ul
	(li "Debian GNU/Linux 3.0")
	(li "Red Hat Enterprise 3.0")
	(li "cygwin ( �ǿ��� )"))
       (li ".emacs�˼��Υ����ɤ��ɲä��ޤ���")
       (program
	";; CAcert.crt����¸�ѥ�\n"
	"(setq sumibi-server-cert-file \"/home/xxxx/emacs/CAcert.crt\")\n"
	"(load \"sumibi.el\")\n"
	"(global-sumibi-mode 1)")
       (p 
	"���ѿ� sumibi-server-cert-file �� nil �ˤ����SSL����������Ѥ��ʤ��Ƥ��̿��Ǥ��ޤ���"
	"â������������Ǥ�Sumibi Server�Ȥ��̿��ΰ��������㲼���ޤ��Τǡ�"
	"sumibi.org���󶡤��Ƥ���Sumibi Server�����Ѥ�����ϡ�SSL������λ��Ѥ򤪤����ᤷ�ޤ���")
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
	(li "�����������")
	(p "�Ѵ�ľ���ʸ����ξ�˥�������򤢤碌��C-j�����򲡤��ȸ�������⡼�ɤ˰ܹԤ��ޤ���")
	(ul
	 (li "�������뤬ʸ���ˤ�����֤�[C-j]�򲡤���")
	 (p
	  (img (@ (src "before_select1.png"))))
	 (li "C-j�򲡤��ȡ���������⡼�ɤ˰ܹԤ��ޤ���")
	 (p
	  (img (@ (src "select1.png"))))
	 (li "�������򤷤�����ʬ�˥���������碌��[C-j]�򲡤���")
	 (p
	  (img (@ (src "before_select2.png"))))
	 (li "��������⡼�ɤ˰ܹԤ��ޤ���")
	 (p
	  (img (@ (src "select2.png"))))
	 (li "[C-j]�Ǽ����Ѵ����䤬���֤˽ФƤ��ޤ���")
	 (p
	  (img (@ (src "select3.png")))))

	(li "�������򥭡�������")
	(table (@ (title "�������򥭡�������"))
	       (thead
		(tr  (td "�������") (td "���������")))
	       (tbody
		(tr   (td "C-m")   (td "�����������"))
		(tr   (td "C-g")   (td "�������򥭥�󥻥�"))
		(tr   (td "C-b")   (td "������ʸ��˰�ư"))
		(tr   (tr(td "C-f")   (td "������ʸ��˰�ư")))
		(tr   (tr(td "C-a")   (td "�ǽ��ʸ��˰�ư")))
		(tr   (tr(td "C-j")   (td "���θ�����ڤ꤫����")))
		(tr   (tr(td "space") (td "���θ�����ڤ꤫����")))
		(tr   (tr(td "C-p")   (td "���θ�����ڤ꤫����")))
		(tr   (tr(td "C-n")   (td "���θ�����ڤ꤫����"))))))))
	 

     (*subsection
      "�Ѵ��Υ���"
      #f
      (*ja
       (ul
	(li "�ʤ�٤�Ĺ��ʸ�Ϥ��Ѵ����롣")
	(p
	 "Sumibi���󥸥�Ϥʤ�٤�Ĺ��ʸ�Ϥ����Ѵ������ۤ����Ѵ����٤��夬��ޤ���\n"
	 "��ͳ�ϡ�Sumibi���󥸥�λ��Ȥߤˤ���ޤ���\n"
	 "Sumibi���󥸥��ʸ̮���ñ�����Ӥ��顢����Ū�ˤɤ�ñ�줬�����������Ƚ�Ǥ��ޤ���\n")
	(li "SKK�μ���˴ޤޤ�Ƥ�������ñ�����ꤹ�롣")
	(p
	 "SKK�˴���Ƥ���ͤǤʤ��ȴ��Ф��Ĥ���ʤ����⤷��ޤ��󤬡�\"�Ѵ�����\"�Τ褦��¿����ʣ���\n"
	 "�Ϻǽ餫�鼭�����Ͽ����Ƥ���Τǡ�\"henkanseido\"�ȸ������˻��ꤹ��ȡ��μ¤��Ѵ��Ǥ��ޤ���\n")))))

    ,W:sf-logo
    ))


;; �ڡ����ν���
(output 'el (L:body))

