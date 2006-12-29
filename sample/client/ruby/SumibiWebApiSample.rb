#!/usr/local/bin/ruby -K utf-8
#
# "SumibiWebApiSample.rb" is a sample program.
#
#   Copyright (C) 2005 Kiyoka Nishiyama
#     $Date: 2006/12/29 03:03:59 $
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
wsdl   ='http://sumibi.org/sumibi/Sumibi_testing.wsdl'
sumibi = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver

if 1 > ARGV.length
    print "usage : SumibiWebApiSample.rb string"
    exit( 0 )
end

query   = ARGV.join( ' ' )
sumi    = "sumi_current"
history = ""
dummy   = ""

#
# getStatus()
#
print "version : ", sumibi.getStatus( ).version, "\n"

#
# doSumibiConvertSexp()
#
print "sexp    : ", sumibi.doSumibiConvertSexp( query, sumi, history, dummy ), "\n"

#
# doSumibiConvert()
#
result = sumibi.doSumibiConvert( query, sumi, history, dummy )

print "time    : ", result.convertTime, "\n"
print "dump    : \n"
result.resultElements.each {|cand|
  printf( " cand:%d id:%d no:%d spaces:%d type:%s word:%s\n",
          cand.candidate,
          cand.id,
          cand.no,
          cand.spaces,
          cand.type,
          cand.word )
}

#
# doSumibiConvertHira()
#
print "hiragana: ", sumibi.doSumibiConvertHira( query, sumi, history, dummy ), "\n"


exit 0
