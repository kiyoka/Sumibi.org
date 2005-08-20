

URL = http://openlab.jp/skk/skk/dic/
JISYO-DL = SKK-JISYO.L SKK-JISYO.geo SKK-JISYO.jinmei SKK-JISYO.station SKK-JISYO.propernoun



SKK-JISYO.sumbi_starter :  SKK-JISYO.download SKK-JISYO.exclude_for_sumibi
	skkdic-expr2 SKK-JISYO.download - SKK-JISYO.exclude_for_sumibi > SKK-JISYO.sumbi_starter


SKK-JISYO.download : 
	/bin/rm -f SKK-JISYO.download
	for i in ${JISYO-DL}; \
	do \
		echo $$i ; \
		wget -nc ${URL}/$$i ; \
	done
	skkdic-expr2 -o SKK-JISYO.download ${JISYO-DL}

clean:
	/bin/rm ${JISYO-DL} SKK-JISYO.download SKK-JISYO.sumbi_starter
