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
      (p "���Υɥ�����Ȥ�perl�����͡��ʸ��줫��sumibi.org��δ����Ѵ������ӥ������Ѥ�����ˡ����⤷�Ƥ��ޤ���")))

    (*section
     "Sumibi Web API�Ȥ�"
     "About Sumibi Web API"
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (ul
       (li "Sumibi Web API�ϡ�sumibi.org�Ǹ������Ƥ���SOAP 1.1���δ����Ѵ�Web�����ӥ��Ǥ���")
       (li "SOAP�饤�֥�����ĸ���ʤ�ɤθ��줫��Ǥ����ѤǤ��ޤ���")
       (li " WSDL��������Ƥ��ޤ��Τǡ�SOAP�ξܺ٤��μ��ʤ���Sumibi Web API�����Ѥ��뤳�Ȥ��Ǥ��ޤ���")
       (li "WSDL�ե�����(�ƥ�����)��" (*link "������" "Sumibi_testing.wsdl") "�����������ɤǤ��ޤ���"))))

    (*section
     "Sumibi Web API����"
     "Sumibi Web API Specification"
     (*en
      (p "No documents in English, sorry..." ))
     (*subsection
      "�᥽�å�"
      "methods"
      (*ja
       (ol
	(li "getStatus�᥽�å�")
	(ul
	 (li "�ѥ�᡼��")
	 (p "�ʤ�")
	 (li "�����")
	 (p "SumibiStatus��")
	 (table 
	  (thead
	   (tr  (td "̾��") (td "��")))
	  (tbody
	   (tr   (td "version")   (td "API�ΥС�������ֹ�(��:0.3.2)")))))

	(li "doSumibiConvert�᥽�å�")
	(ul
	 (li "�ѥ�᡼��")
	 (table 
	  (thead
	   (tr  (td "̾��") (td "��")))
	  (tbody
	   (tr   (td "query")   (td "�Ѵ����������޻�ʸ����"))
	   (tr   (td "sumi")    (td "�Ѵ��˻��Ѥ��뼭��̾(̤����)"))
	   (tr   (td "ie")      (td "����ʸ�����󥳡���(utf-8����)"))
	   (tr   (td "oe")      (td "����ʸ�����󥳡���(utf-8����)"))))
	 (li "�����")
	 (p "SumibiResult��")
	 (table 
	  (thead
	   (tr  (td "̾��") (td "��")))
	  (tbody
	   (tr   (td "convertTime")     (td "�Ѵ��������פ����ÿ�(̤����)"))
	   (tr   (td "resultElements")  (td "�Ѵ����������(���� ResultElementArray������)"))))
	 (p "ResultElementArray��(�ʲ��ι�¤�Τ�����Ȥʤ�ޤ�)")
	 (table 
	  (thead
	   (tr  (td "̾��") (td "��")))
	  (tbody
	   (tr   (td "no")         (td "ʸ���ֹ�"))
	   (tr   (td "candidate")  (td "�Ѵ������ֹ�(��������Ŭ��Ψ���⤤)"))
	   (tr   (td "type")       (td "�Ѵ����䥿����( j:������h:ʿ��̾��k:�������ʡ�l:����ե��٥å�)"))
	   (tr   (td "word")       (td "�Ѵ�����ʸ����")))))
      
	(li "doSumibiConvertSexp�᥽�å�(Emacs����)")
	(ul
	 (li "�ѥ�᡼��")
	 (table 
	  (thead
	   (tr  (td "̾��") (td "��")))
	  (tbody
	   (tr   (td "query")   (td "�Ѵ����������޻�ʸ����"))
	   (tr   (td "sumi")    (td "�Ѵ��˻��Ѥ��뼭��̾(̤����)"))
	   (tr   (td "ie")      (td "����ʸ�����󥳡���(utf-8����)"))
	   (tr   (td "oe")      (td "����ʸ�����󥳡���(utf-8����)"))))
	 (li "�����")
	 (p "base64���󥳡��ɤ��줿Emacs��S��")
	 (p "(���:S�������ܸ쥨�󥳡��ɤϾ��EUC-JP�Ǥ�)"))))))


    (*section
     "����ץ�ץ�����ư����"
     "Try some sample programs."
     (*en
      (p "No documents in English, sorry..." ))
     (*subsection
      "perl����sumibi.org�Υ����ӥ���ƤӤ���"
      "Using sumibi.org with perl"
      (*en
       (p "No documents in English, sorry..." ))
      (*ja
       (p
	(p "����ץ�ץ�������ˤ�GPL�ǤϤʤ�LGPL�Τ�Τ⤢��ޤ���")
	(p "�饤���󥹤ϥ���ץ�ץ������������Ƥ��ޤ��Τǡ�"
	   "�����ۤ�����ϡ��ե��������Ȥ��ɤ���ǧ���Ƥ���������")
	(p "�ʲ��μ��� perl �Υ���ץ�ץ�����ư�������Ȥ��Ǥ��ޤ���")
	(ul
	 (li "SOAP::Lite�򥤥󥹥ȡ��뤹�롣")
	 (p "CPAN������SOAP::Lite�⥸�塼���������ƥ��󥹥ȡ��뤷�Ƥ���������")
	 (li "SumibiWebApiSample.pl��ư����")
	 (p "./SumibiWebApiSample.pl sumibi")
	 (p "[���]")
	 (program "
version: 0.3.2
sexp   : KCgoaiAiw7qy0CIgMCAwKSAoaCAipLmk36TTIiAwIDEpIChrICKluaXfpdMiIDAgMikgKGwgInN1bWliaSIgMCAzKSkp
time   : 1
dump   : $VAR1 = [
          {
            'no' => '0',
            'type' => 'j',
            'word' => 'ú��',
            'candidate' => '0'
          },
          {
            'no' => '0',
            'type' => 'h',
            'word' => '���ߤ�',
            'candidate' => '1'
          },
          {
            'no' => '0',
            'type' => 'k',
            'word' => '���ߥ�',
            'candidate' => '2'
          },
          {
            'no' => '0',
            'type' => 'l',
            'word' => 'sumibi',
            'candidate' => '3'
          }
        ];
"
		 ))))))

    (*section
     "����ץ�ץ�����󶡤Τ��ͤ���"
     "Please send me your sample program."
     (*en
      (p "No documents in English, sorry..." ))
     (*ja
      (p
       (p "Sumibi�ץ������ȤǤϡ�SumibiWebAPI���͡��ʸ��줫����褦�ˡ�"
	  "�͡��ʸ���ǽ񤤤�����ץ�ץ����򽸤�Ƥ��ޤ���")
       (p "���������դʸ���ǽ񤤤���ʬ����䤹������ץ�ץ��������äƲ�������"
	  "���Υ�꡼���˴ޤᤵ����ĺ���ޤ���")
       (p "���ä�ĺ�����ϡ��饤���󥹤��������Ƥ���������"
	  "�饤���󥹤ϼ�ͳ�Ǥ���������ץ�ץ����򸵤˥��饤����ȥ��եȤ��ꤿ���ͤΤ���ˤʤ�٤�LGPL���ɤ��ȹͤ��Ƥ��ޤ���"))))

    ,W:sf-logo
    ))


;; �ڡ����ν���
(output 'api-testing (L:body))
