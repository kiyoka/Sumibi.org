/////////////////////////////////////////////////////////////////////////////////////////////
//
// Sumibi Ajax is a client for Sumibi server.
//
//   Copyright (C) 2002,2003,2004,2005 ktat atusi@pure.ne.jp
//     $Date: 2005/07/05 13:00:52 $
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
//
//  http://naoya.dyndns.org/~naoya/mt/archives/001610.html のエントリをかなり参考にしてます。
//
/////////////////////////////////////////////////////////////////////////////////////////////

var XMLHTTP_LOAD_COMPLETE = 4;
var XMLHTTP_HTTP_STATUS = 200;
var MSXMLHTTP = false;

function createXmlHttp() {
    xmlhttp = false;
    try {
	xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
	MSXMLHTTP = true;
    } catch (e) {
	try {
	    xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
	    MSXMLHTTP = true;
	} catch (E) {
	    xmlhttp = false;
	}
    }
    if (!xmlhttp && typeof XMLHttpRequest != 'undefined') {
	xmlhttp = new XMLHttpRequest();
    }
    return xmlhttp;
}

function xmlstring(q) {
    return (
	'<?xml version="1.0" encoding="UTF-8" standalone="no"?>' +
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
	'</SOAP-ENV:Envelope>'
	);
}

function xmlHttpDo(method) {
    var xmlhttp = createXmlHttp();
    var progress  = document.getElementById('progress');
    var resultbox = document.getElementById('convert');
    var query     = document.getElementById('q');
    resultbox.innerHTML = '';
    try {
	//	xmlhttp.open("POST", "./nph-proxy.cgi/010110A/https/sumibi.org/cgi-bin/sumibi/testing/sumibi.cgi",true);
	//	xmlhttp.open("POST", "https://genkan.localhost/cgi-bin/sumibi/testing/sumibi.cgi",true);
	xmlhttp.open("POST", "http://genkan.localnet/test/sumibi.cgi",true);

	xmlhttp.setRequestHeader("MessageType", "CALL");
	xmlhttp.setRequestHeader("Content-Type", "text/xml");
	xmlhttp.onreadystatechange = function () {
	    progress.innerHTML = '&nbsp;&nbsp;&nbsp;<blink>waiting server response ...</blink>';
	    progress.style.display = 'block';
	    if (xmlhttp.readyState == XMLHTTP_LOAD_COMPLETE) {
		// alert(xmlhttp.responseText);
		var output = parseXML(xmlhttp.responseXML);
		if (output) {
		    resultbox.innerHTML = output;
		    resultbox.style.display = 'block';
		    progress.style.display = 'none';
		    displayResult();
		} else {
		    progress.innerHTML = '<strong>cannot convert</strong>';
		    progress.style.color = '#ff0000';
		}
	    } else {
		// resultbox.innerHTML = xmlhttp.statusText;
	    }
	}
        var message = xmlstring(query.value);
	xmlhttp.send(message);
    } catch (e) {
	resultbox.innerHTML = e;
	resultbox.style.display = 'block';
    }
}


function parseXML(xml) {
    var output = '';
    xml = xml.documentElement;
    var candidate_array = new Array();
    var item = xml.getElementsByTagName('item');
    for(i=0; i < item.length; i += 1){
	var no        = item[i].childNodes[0].childNodes[0].nodeValue; // no
	var candidate = item[i].childNodes[1].childNodes[0].nodeValue; // candidate
	var word      = item[i].childNodes[2].childNodes[0].nodeValue; // word
	if(! candidate_array[no]){
	    candidate_array[no] = new Array();
	}
	candidate_array[no][candidate] = word;
    }
    output = format(candidate_array);
    return output;
}

function format(array){
    var output = '[変換候補] ';
    for(i=0; i < array.length; i++){
        if(array[i].length > 1){
	    output += ' <select name="candiate" id="candidate' + i + '" onChange="displayResult()">';
	    for(ii=0; ii < array[i].length; ii++){
		output += '<option value="' + array[i][ii] + '">' + array[i][ii];
	    }
	    output += '</select>';
	}else{
	    output += '<input type="hidden" name="candidate" id="candidate' + i + '" value="' + array[i][0] +'">' + array[i][0];
	}
    }
    output += '<input type="button" id="define" name="define" value="確定" onClick="define_candidate()">';
    return output;
}

function displayResult(){
    var select;
    var output = '';
    for(i = 0;select  = document.getElementById('candidate' + i); i++){
	if(select.type == 'hidden'){
	    output += select.value;
	}else{
	    for(ii = 0; ii < select.length; ii++){
		if(select[ii].selected == true){
		    output += select[ii].value;
		}
	    }
	}
    }
    var converted = document.getElementById('r');
    converted.value = output;
}

function define_candidate(){
    var query = document.getElementById('q');
    var converted = document.getElementById('r');
    var defined   = document.getElementById('defined');
    var resultbox = document.getElementById('convert');
    defined.value += converted.value;
    converted.value = '';
    resultbox.innerHTML = '';
    query.value = '';
}

function method_define(){
    var method = document.getElementById('method');
    if(method.value == 'stable' && method.checked){
	return '';
    }else{
	return '_dev';
    }
}
