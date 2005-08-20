

URL = http://openlab.jp/skk/skk/dic/
JISYO-URL = SKK-JISYO.L SKK-JISYO.geo SKK-JISYO.jinmei SKK-JISYO.station SKK-JISYO.propernoun



SKK-JISYO.sumbi_starter :  SKK-JISYO.download SKK-JISYO.exclude_for_sumibi
	skkdic-expr2 SKK-JISYO.download - SKK-JISYO.exclude_for_sumibi > SKK-JISYO.sumbi_starter


SKK-JISYO.download : 
	/bin/rm -f SKK-JISYO.download
	for i in ${JISYO-URL}; \
	do \
		echo $$i ; \
		wget -nc ${URL}/$$i ; \
	done
	skkdic-expr2 -o SKK-JISYO.download ${JISYO-URL}
