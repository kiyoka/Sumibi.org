VERSION=0.7.0
TARGET=./sumibi-${VERSION}

PREFIX = /usr/local
BINDIR = $(PREFIX)/bin
DATADIR = $(PREFIX)/share/sumibi
SITELIBDIR = `gauche-config --sitelibdir`


.PHONY=all dist platform-check

all:
	@echo "nothing to make"


clean:
	/bin/rm -rf ${TARGET} ${TARGET}.tar.gz


install: sumibi sumiyaki platform-check
	mkdir -p $(BINDIR)
	mkdir -p $(DATADIR)
	mkdir -p $(SITELIBDIR)/sumibi
	mkdir -p $(DATADIR)/dot.sumibi
	cp -fp sumibi sumiyaki $(BINDIR)
	cp -fp dot.sumibi/*.sample $(DATADIR)/dot.sumibi
	cp -fp lib/sumibi/*.scm $(SITELIBDIR)/sumibi


deploy: sumibi sumiyaki platform-check
	cp -fp sumibi                  ../
	GOSH="`which gosh` -I${TARGET}/lib ./sumibi"&& cat server/soap/sumibi.cgi | sed -e "s!@GOSH@!$$GOSH!g" > ../sumibi.cgi
	chmod +x ../sumibi.cgi


platform-check:
	@gauche-package list | grep Gauche-dbd-mysql
	@gauche-package list | grep Gauche-kakasi


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
	/bin/cp -rf ./sample/client/python                 ${TARGET}/sample/client
	chmod +x                                           ${TARGET}/sample/client/*/SumibiWebApiSample.*
	/bin/cp -rf ./server                               ${TARGET}
	/bin/cp -rf ./lib                                  ${TARGET}
	awk -v VERSION=${VERSION}  '{ if ( /;;VERSION;;/ ) { printf( "\"%s\"\n", VERSION ); } else { print; } }' < ./lib/sumibi/define.scm  >  ${TARGET}/lib/sumibi/define.scm
	echo        "#!@GOSH@"                    >        ${TARGET}/sumibi.in
	/bin/cat    ./sumibi                      >>       ${TARGET}/sumibi.in
	echo        "#!@GOSH@"                    >        ${TARGET}/sumiyaki.in
	/bin/cat    ./sumiyaki                    >>       ${TARGET}/sumiyaki.in
	/bin/cp -f  ./Makefile                             ${TARGET}
	find        ${TARGET} -name CVS -type d | xargs /bin/rm -rf 
	tar zcf ${TARGET}.tar.gz  ${TARGET}
