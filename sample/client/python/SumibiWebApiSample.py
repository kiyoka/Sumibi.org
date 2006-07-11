#!/usr/bin/env python

"""
SUMIBI Sample Program

required modules
	-SOAPpy
	-PyXML
	-fpconst(may be...)

	and python(recommend version 2.4.3) with ssl support

License
	LGPL

Programmer
	Yusuke Muraoka(yusuke.muraoka@gmail.com)
"""

import SOAPpy, sys, string

query = sys.argv[1]

service = SOAPpy.WSDL.Proxy('http://www.sumibi.org/sumibi/Sumibi_stable.wsdl')
result = service.doSumibiConvert(query, None, 'utf-8', 'utf-8')

fmt = string.Template("candidate: $candidate   word: $word")
for el in result['resultElements']:
	print fmt.safe_substitute(el)
