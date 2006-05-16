VERSION=0.5.5
TARGET=./sumibi-${VERSION}

.PHONY=dist

all: dist


clean:
	/bin/rm -rf ${TARGET} ${TARGET}.tar.gz

dist:
	mkdir -p ${TARGET}
	/bin/mkdir -p  ${TARGET}/client/elisp
	/bin/mkdir -p  ${TARGET}/sample/client
	/bin/mkdir -p  ${TARGET}/doc
	/bin/cp     ./doc/COPYING                          ${TARGET}
	/bin/cp     ./doc/CHANGELOG                        ${TARGET}
	/bin/cp     ./doc/CREDITS                          ${TARGET}
	/bin/cp     ./doc/README                           ${TARGET}
	awk -v VERSION=${VERSION}  '{ if ( /;;VERSION;;/ ) { printf( "\"%s\"\n", VERSION ); } else { print; } }' < ./client/elisp/sumibi.el  >  ${TARGET}/client/elisp/sumibi.el
	/bin/cp -r  ./client/ajax                          ${TARGET}/client
	/bin/cp -r  ./sample/client/perl                   ${TARGET}/sample/client
	/bin/cp -r  ./sample/client/ruby                   ${TARGET}/sample/client
	find        ${TARGET} -name CVS -type d | xargs /bin/rm -rf 
	tar zcf ${TARGET}.tar.gz  ${TARGET}
