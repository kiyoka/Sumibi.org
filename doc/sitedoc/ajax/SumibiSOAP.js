/////////////////////////////////////////////////////////////////////////////////////////////
//
// Sumibi Ajax is a client for Sumibi server.
//
//   Copyright (C) 2005 ktat atusi@pure.ne.jp
//     $Date: 2005/07/18 07:56:11 $
//
// This file is part of Sumibi
//
// Sumibi is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2, or (at your option)
// any later version.
// 
// Sumibi is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with Sumibi; see the file COPYING.
//
/////////////////////////////////////////////////////////////////////////////////////////////

//********************************************************************
//
// SumibiSOAP Class
//
//********************************************************************

function SumibiSOAP(progress, ime, type, hist){
    this.progress = progress;
    this.ime      = ime;
    this.type     = type;
    this.history  = hist;
}

SumibiSOAP.prototype = new Sumibi(this.progress, this.ime, this.type, this.history);

SumibiSOAP.prototype.doConvert = function(array){
    this.doSoapRequest(this.doConvertXML(array[0]), array[1]);
}

SumibiSOAP.prototype.doConvertXML = function(q) {
    return '<?xml version="1.0" encoding="UTF-8" standalone="no"?>' +
    '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"' +
    ' xmlns:typens="urn:SumibiConvert" xmlns:xsd="http://www.w3.org/2001/XMLSchema"' +
    ' xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/"' +
    ' xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/"' +
    ' xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"'+
    ' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >' +
    '<SOAP-ENV:Body>'+
    '<mns:doSumibiConvert xmlns:mns="urn:SumibiConvert"'+
    ' SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">' +
    '<query xsi:type="xsd:string">' + q + '</query>' +
    '<sumi xsi:type="xsd:string">sumi_current</sumi>'+
    '<ie xsi:type="xsd:string">utf-8</ie>'+
    '<oe xsi:type="xsd:string">utf-8</oe>'+
    '</mns:doSumibiConvert>'+
    '</SOAP-ENV:Body>'+
    '</SOAP-ENV:Envelope>';
}

SumibiSOAP.prototype.parseXML = function(xml) {
    var output = '';
    try{
	xml = xml.documentElement;
    }catch(e){
	sumibi.progress.innerHTML = e;
	return;
    }
    var candidate_array = new Array();
    var item = xml.getElementsByTagName('item');
    // ********************************************************
    // 最後に閉じタグなしのもの(空白?)を返している時があるよう
    // ********************************************************
    for(i=0; i < item.length; i += 1){
	try{
	    var no        = item[i].childNodes[0].childNodes[0].nodeValue;
	    var candidate = item[i].childNodes[1].childNodes[0].nodeValue;
	    var word      = item[i].childNodes[2].childNodes[0].nodeValue;
	} catch (e){
	    sumibi.progress.innerHTML = e + '; i = ' + i;
	}
	if(! candidate_array[no]){
	    candidate_array[no] = new Array();
	}
	candidate_array[no][candidate] = word;
    }
    return candidate_array;
}
