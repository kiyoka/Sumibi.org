#!/usr/local/bin/ruby

require 'soap/wsdlDriver'
wsdl = 'http://www.sumibi.org/sumibi/Sumibi_stable.wsdl'
sumibi = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver

query = "sumibi yakiniku"
sumi  = "sumi_current"
ie    = "utf-8"
oe    = "utf-8"

p sumibi.getStatus( )

print sumibi.doSumibiConvertSexp( query, sumi, ie, oe )

result = sumibi.doSumibiConvert( query, sumi, ie, oe )

result.resultElements.each {|cand|
  printf( " cand:%d no:%d spaces:%d type:%s word:%s\n",
          cand.candidate,
          cand.no,
          cand.spaces,
          cand.type,
          cand.word )
}

print sumibi.doSumibiConvertHira( query, sumi, ie, oe )
