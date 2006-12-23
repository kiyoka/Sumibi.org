/////////////////////////////////////////////////////////////////////////////////////////////
//
// Sumibi Ajax is a client for Sumibi server.
//
//   Copyright (C) 2005 ktat atusi@pure.ne.jp
//     $Date: 2006/12/23 05:00:19 $
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

function SumibiSOAP(progress, ime, type, guide){
    this.progress = progress;
    this.ime      = ime;
    this.type     = type;
    this.hist     = new Array;
    this.query    = new Array;
    this.guide    = guide;
}

SumibiSOAP.prototype = new Sumibi(this.progress, this.ime, this.type, this.guide);

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
    '<history xsi:type="xsd:string"></history>'+
    '<dummy xsi:type="xsd:string"></dummy>'+
    '</mns:doSumibiConvert>'+
    '</SOAP-ENV:Body>'+
    '</SOAP-ENV:Envelope>';
}

SumibiSOAP.prototype.parseXML = function(xml) {
    var output = '';

    //alert( 'parseXML()' );

    try{
	xml = xml.documentElement;
    }catch(e){
	this.progress.innerHTML = e;
	return;
    }
    var candidate_array = new Array();
    var item = xml.getElementsByTagName('item');
    // ********************************************************
    // 変換結果をDOM APIを使ってパースする。
    // ********************************************************
    for(i=0; i < item.length; i += 1){
	var nodeValue = new Array;
	try{
	    for(i2 =0; i2 < item[i].childNodes.length; i2+= 1){
		nodeValue[item[i].childNodes[i2].nodeName] = item[i].childNodes[i2].childNodes[0].nodeValue;
	    }
	} catch (e){
	    this.progress.innerHTML = e + '; i = ' + i;
	}
	if(! candidate_array[nodeValue["no"]]){
	    candidate_array[nodeValue["no"]] = new Array();
	}

	candidate_array[nodeValue["no"]][nodeValue["candidate"]] = new Array();
	if ( 1 < nodeValue["spaces"] ) {
	    candidate_array[nodeValue["no"]][nodeValue["candidate"]]["space"]       = " ";
	    candidate_array[nodeValue["no"]][nodeValue["candidate"]]["space_mark"]  = "_";
	}
	else {
	    candidate_array[nodeValue["no"]][nodeValue["candidate"]]["space"]       = "";
	    candidate_array[nodeValue["no"]][nodeValue["candidate"]]["space_mark"]  = "";
	}
	candidate_array[nodeValue["no"]][nodeValue["candidate"]]["word"]   = nodeValue["word"];

    }
    return candidate_array;
}
