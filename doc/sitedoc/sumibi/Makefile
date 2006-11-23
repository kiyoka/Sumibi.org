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
	pod2html --backlink='back to top' --css='../sumibi.css' --title='Sumibi.pm (Perl module for SumibiWebAPI)' ../../../client/perl/Sumibi.pm | iconv -f=euc-jp -t=utf-8 > sumibi_pm.html
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
