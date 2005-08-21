

URL = http://openlab.jp/skk/skk/dic/
JISYO-DL     = SKK-JISYO.L SKK-JISYO.geo SKK-JISYO.jinmei SKK-JISYO.station SKK-JISYO.propernoun 
JISYO-ZIP-DL = SKK-JISYO.zipcode SKK-JISYO.office.zipcode
ZIPFILTER = awk ' /^[0-9]+/ { printf( "%s-%s ", substr( $$1, 1, 3 ), substr( $$1, 4, 4 ) ); print $$2; } '


SKK-JISYO.sumbi_starter :  SKK-JISYO.download SKK-JISYO.exclude_for_sumibi
	skkdic-expr2 SKK-JISYO.download - SKK-JISYO.exclude_for_sumibi > SKK-JISYO.sumbi_starter


SKK-JISYO.download :
	/bin/rm -f SKK-JISYO.download
	for i in ${JISYO-DL}; \
	do \
		echo $$i ; \
		wget -nc ${URL}/$$i ; \
	done
	for i in ${JISYO-ZIP-DL}; \
	do \
		echo $$i ; \
		wget -nc ${URL}/zipcode/$$i ; \
	done
	${ZIPFILTER} SKK-JISYO.zipcode        > SKK-JISYO.zipcode.modify
	${ZIPFILTER} SKK-JISYO.office.zipcode > SKK-JISYO.office.zipcode.modify
	skkdic-expr2 -o SKK-JISYO.download ${JISYO-DL} SKK-JISYO.zipcode.modify

# future extension -> SKK-JISYO.office.zipcode.modify


clean:
	/bin/rm ${JISYO-DL} ${JISYO-ZIP-DL} SKK-JISYO.download SKK-JISYO.sumbi_starter *.modify
