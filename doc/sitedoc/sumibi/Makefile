#
# このMakefileはSumibiのドキュメントサイトをビルドするためのものです。
#
# ビルドに必要なツールは以下の通りです。
#   1. SmartDoc version 1.2b
#   2. sxmlvnv  sxmlcnv version 0.1.0
#


all :
	cat ../../../server/soap/Sumibi.wsdl | sed -e 's/%URL%/https:\/\/sumibi.org\/cgi-bin\/sumibi\/testing\/sumibi.cgi/' > Sumibi_testing.wsdl
	cat ../../../server/soap/Sumibi.wsdl | sed -e 's/%URL%/https:\/\/sumibi.org\/cgi-bin\/sumibi\/stable\/sumibi.cgi/' > Sumibi_stable.wsdl
	./convert_doc  sumibi_server_setup
	./convert_doc  faq                t
	./convert_doc  sumibi
	./convert_doc  sumibi_el_stable
	./convert_doc  sumibi_el_testing
	./convert_doc  sumibi_api_stable
	./convert_doc  sumibi_api_testing
