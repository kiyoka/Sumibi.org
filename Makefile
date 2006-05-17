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
	/bin/cp -f  ./sumibi                               ${TARGET}
	/bin/cp -f  ./sumiyaki                             ${TARGET}
	/bin/cp -f  ./Makefile                             ${TARGET}
	find        ${TARGET} -name CVS -type d | xargs /bin/rm -rf 
	tar zcf ${TARGET}.tar.gz  ${TARGET}
