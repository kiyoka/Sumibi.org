#!/usr/bin/env python
#
# "SumibiWebApiSample.py" is a sample program.
#
#   Copyright (C) 2006 Yusuke Muraoka(yusuke.muraoka@gmail.com)
#     $Date: 2006/07/11 12:25:27 $
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

query = sys.argv[1]

service = SOAPpy.WSDL.Proxy('http://www.sumibi.org/sumibi/Sumibi_stable.wsdl')
result = service.doSumibiConvert(query, None, 'utf-8', 'utf-8')

fmt = string.Template("candidate: $candidate   word: $word")
for el in result['resultElements']:
	print fmt.safe_substitute(el)
