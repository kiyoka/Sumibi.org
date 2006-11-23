#
# このMakefileはSumibiのドキュメントサイトをビルドするためのものです。
#
# ビルドに必要なツールは以下の通りです。
#   1. SmartDoc version 1.2b
#   2. sxmlvnv  sxmlcnv version 0.1.0
#


all :
	/bin/cp ../../../server/soap/Sumibi.testing.wsdl   Sumibi_testing.wsdl
	/bin/cp ../../../server/soap/Sumibi.stable.wsdl    Sumibi_stable.wsdl
	./convert_doc  romaji_table
	./convert_doc  sumiyaki
	./convert_doc  sumi
	./convert_doc  sumibi
	./convert_doc  faq                t
	./convert_doc  privacy_policy
	./convert_doc  sumibi_server_setup
	./convert_doc  sumibi_el_stable
	./convert_doc  sumibi_el_testing
	./convert_doc  sumibi_api_stable
	./convert_doc  sumibi_api_testing
