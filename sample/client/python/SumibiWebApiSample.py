#!/usr/bin/env python
#
# "SumibiWebApiSample.py" is a sample program.
#
#   Copyright (C) 2006 Yusuke Muraoka(yusuke.muraoka@gmail.com)
#     $Date: 2006/10/28 06:51:58 $
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# required modules
#	-SOAPpy
#	-PyXML
#	-fpconst(may be...)
#
#	and python(recommend version 2.4.3) with ssl support
#

import SOAPpy, sys, string

if len(sys.argv) < 2:
	print "usage : SumibiWebApiSample.py string"
	sys.exit(0)

query   = " ".join(sys.argv[1:])
sumibi  = SOAPpy.WSDL.Proxy('http://www.sumibi.org/sumibi/Sumibi_testing.wsdl')
ie      = "utf-8"
oe      = "utf-8"
history = ""

#
# getStatus();
#
som = sumibi.getStatus()
print "version : ", som.version

#
# doSumibiConvertSexp();
#
som = sumibi.doSumibiConvertSexp(query, None, history, oe)
print "sexp    : ", som

#
# doSumibiConvert();
#
som = sumibi.doSumibiConvert(query, None, ie, oe)
fmt = string.Template("cand:$candidate no:$no spaces:$spaces type:$type word:$word")
for el in som['resultElements']:
	print fmt.safe_substitute(el)

#
# doSumibiConvertHira()
#
som = sumibi.doSumibiConvertHira(query, None, ie, oe)
print "hiragana: ", som
