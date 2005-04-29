#
# このMakefileはSumibiのドキュメントサイトをビルドするためのものです。
#
# ビルドに必要なツールは以下の通りです。
#   1. SmartDoc version 1.2b
#   2. sxmlvnv  sxmlcnv version 0.1.0
#


all :
	/bin/mkdir -p ../../../web
	./convert_doc ../../../web sumibi
	./convert_doc ../../../web sumibi_el_stable
	./convert_doc ../../../web sumibi_el_testing
	./convert_doc ../../../web faq                t
