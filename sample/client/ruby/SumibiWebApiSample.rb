#!/usr/local/bin/ruby
#
# "SumibiWebApiSample.rb" is a sample program.
#
#   Copyright (C) 2005 Kiyoka Nishiyama
#     $Date: 2005/10/30 10:31:29 $
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
#
# [ Tested on Ruby 1.8.3 ]
#
require 'soap/wsdlDriver'
wsdl = 'http://www.sumibi.org/sumibi/Sumibi_testing.wsdl'
sumibi = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver

if 1 > ARGV.length
    print "usage : SumibiWebApiSample.rb string"
    exit( 0 )
end

query = ARGV.join( ' ' )
sumi  = "sumi_current"
ie    = "utf-8"
oe    = "utf-8"

#
# getStatus()
#
print "version : ", sumibi.getStatus( ).version, "\n"

#
# doSumibiConvertSexp()
#
print "sexp    : ", sumibi.doSumibiConvertSexp( query, sumi, ie, oe ), "\n"

#
# doSumibiConvert()
#
result = sumibi.doSumibiConvert( query, sumi, ie, oe )

print "time    : ", result.convertTime, "\n"
print "dump    : \n"
result.resultElements.each {|cand|
  printf( " cand:%d no:%d spaces:%d type:%s word:%s\n",
          cand.candidate,
          cand.no,
          cand.spaces,
          cand.type,
          cand.word )
}

#
# doSumibiConvertHira()
#
print "hiragana: ", sumibi.doSumibiConvertHira( query, sumi, ie, oe ), "\n"


exit 0
