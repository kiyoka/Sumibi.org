#!/usr/local/bin/gosh /usr/local/bin/sxmlcnv


(load "./common.scm")


(define (L:body)
  '(body
    (center
     (a (@ (href "mailto:kiyoka@netfort.gr.jp"))
	"email: Kiyoka Nishiyama"))

    (*section
     "���󥹥ȡ���"
     #f
     (*ja
      (ol
       (li "Emacs��apel-10.6�ʾ�򥤥󥹥ȡ��뤷�ޤ���")
       (li "sumibi.el��Emacs�Υ��ɥѥ��˥��ԡ����ޤ���")
       (li "CAcert.crt��Ŭ���ʾ��˥��ԡ����ޤ��� (��: /home/xxxx/emacs �ǥ��쥯�ȥ꡼�ʤ� )")
       (li "wget 1.9.1�ʾ��SSL��ǽ��ͭ���ˤ��ƥӥ�ɤ������󥹥ȡ��뤷�ޤ���")
       (p "(cygwin�����äƤ���wget�����Τޤ����ѤǤ��뤳�Ȥ��ǧ���Ƥ��ޤ���)")
       (li ".emacs�˼��Υ����ɤ��ɲä��ޤ���")
       (program
	";; CAcert.crt����¸�ѥ�\n"
	"(setq sumibi-server-cert-file \"/home/xxxx/emacs/CAcert.crt\")\n"
	"(load \"sumibi.el\")\n"
	"(global-sumibi-mode 1)")
       (p 
	"���ѿ� sumibi-server-cert-file �� nil �ˤ����SSL����������Ѥ��ʤ��Ƥ��̿��Ǥ��ޤ���"
	"â������������Ǥ�Sumibi Server�Ȥ��̿��ΰ�������������ޤ��Τǡ�"
	"sumibi.org���󶡤��Ƥ���Sumibi Server�����Ѥ�����ϡ�������λ��Ѥ򤪤����ᤷ�ޤ���")
       (li "Emacs��Ƶ�ư����Emacs�Υ�˥塼�С��� \"Sumibi\"��ʸ����ɽ�������������Ǥ���"))))

    (*section 
     "�������"
     #f
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
	(li "�������������")
	(p "�Ѵ�ľ���ʸ����ξ�˥���������ư����C-j�����򲡤��ȸ�������⡼�ɤ˰ܹԤ��ޤ���")
	(ul
	 (li "(������)")
	 (program
	  "ú�ФǤ������������򿩤٤褦��[C-j]")
	 (li "(���  )")
	 (program
	  "|ú�ФǤ������������򿩤٤褦��|")))))

     (*subsection
      "�Ѵ��Υ���"
      #f
      (ul
       (li "�ʤ�٤�Ĺ��ʸ�Ϥ��Ѵ����롣")
       (p
	"Sumibi���󥸥�Ϥʤ�٤�Ĺ��ʸ�Ϥ����Ѵ������ۤ����Ѵ����٤��夬��ޤ���\n"
	"��ͳ�ϡ�Sumibi���󥸥�λ��Ȥߤˤ���ޤ���\n"
	"Sumibi���󥸥��ʸ̮�����ñ�����Ӥ��顢����Ū�ˤɤ�ñ�줬��������������򤷤ޤ���\n")
       (li "SKK�μ���˴ޤޤ�Ƥ�������ñ�����ꤹ�롣")
       (p
	"SKK�˴���Ƥ���ͤǤʤ��ȴ��Ф��Ĥ���ʤ����⤷��ޤ��󤬡�\"�Ѵ�����\"�Τ褦��¿����ʣ���\n"
	"�Ϻǽ餫�鼭��˴ޤޤ�Ƥ���Τǡ�\"henkanseido\"�ȸ������˻��ꤹ��ȡ��μ¤��Ѵ��Ǥ��ޤ���\n"))))

    ,W:sf-logo
    ))


;; �ڡ����ν���
(output "sumibi.el ( Emacs client )" (L:body))


