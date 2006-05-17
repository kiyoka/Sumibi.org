VERSION=0.5.5
TARGET=./sumibi-${VERSION}

PREFIX = /usr/local
BINDIR = $(PREFIX)/bin
DATADIR = $(PREFIX)/share/sumibi
SITELIBDIR = `gauche-config --sitelibdir`


.PHONY=dist

all: dist

sumibi: sumibi.in Makefile
	rm -f sumibi
	GOSH=`which gosh` && sed -e "s!@GOSH@!$$GOSH!g" \
	    sumibi.in > sumibi.tmp
	mv sumibi.tmp sumibi
	chmod 555 sumibi


sumiyaki: sumiyaki.in Makefile
	rm -f sumiyaki
	GOSH=`which gosh` && sed -e "s!@GOSH@!$$GOSH!g" \
	    sumiyaki.in > sumiyaki.tmp
	mv sumiyaki.tmp sumiyaki
	chmod 555 sumiyaki


clean:
	/bin/rm -rf ${TARGET} ${TARGET}.tar.gz



dist:
	mkdir -p ${TARGET}
	/bin/mkdir -p  ${TARGET}/client/elisp
	/bin/mkdir -p  ${TARGET}/sample/client
	/bin/cp     ./doc/COPYING                          ${TARGET}
	/bin/cp     ./doc/CHANGELOG                        ${TARGET}
	/bin/cp     ./doc/CREDITS                          ${TARGET}
	/bin/cp     ./doc/README                           ${TARGET}
	awk -v VERSION=${VERSION}  '{ if ( /;;VERSION;;/ ) { printf( "\"%s\"\n", VERSION ); } else { print; } }' < ./client/elisp/sumibi.el  >  ${TARGET}/client/elisp/sumibi.el
	/bin/cp -rf ./client/ajax                          ${TARGET}/client
	/bin/cp -rf ./sample/client/perl                   ${TARGET}/sample/client
	/bin/cp -rf ./sample/client/ruby                   ${TARGET}/sample/client
	/bin/cp -rf ./server                               ${TARGET}
	/bin/cp -rf ./lib                                  ${TARGET}
	echo        "# @GOSH@"                    >        ${TARGET}/sumibi
	/bin/cat    ./sumibi                      >>       ${TARGET}/sumibi
	echo        "# @GOSH@"                    >        ${TARGET}/sumiyaki
	/bin/cat    ./sumiyaki                    >>       ${TARGET}/sumiyaki
	/bin/cp -f  ./Makefile                             ${TARGET}
	find        ${TARGET} -name CVS -type d | xargs /bin/rm -rf 
	tar zcf ${TARGET}.tar.gz  ${TARGET}
