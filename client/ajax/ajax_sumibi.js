/////////////////////////////////////////////////////////////////////////////////////////////
// Sumibi Ajax クライアント
//   by ktat atusi@pure.ne.jp
//
//  http://naoya.dyndns.org/~naoya/mt/archives/001610.html のエントリをかなり参考にしてます。
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
    var method = method_define();
    return (
	    '<methodCall>' +
	    '<methodName>sumibiXMLRPC.convert' + method  + '</methodName>' +
	    '<params>' +
	    '<param><value><string>' + q + '</string></value></param>' +
	    '</params>' +
	    '</methodCall>'
	    );
}

function xmlHttpDo(method) {
    var xmlhttp = createXmlHttp();
    var progress  = document.getElementById('progress');
    var resultbox = document.getElementById('convert');
    var query     = document.getElementById('q');
    resultbox.innerHTML = '';
    try {
	xmlhttp.open("POST", './sumibi.cgi', true);
	xmlhttp.onreadystatechange = function () {
	    progress.innerHTML = '&nbsp;&nbsp;&nbsp;<blink>waiting server response ...</blink>';
	    progress.style.display = 'block';
	    if (xmlhttp.readyState == XMLHTTP_LOAD_COMPLETE) {
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
    var member = xml.childNodes[0].childNodes[0].childNodes[0].childNodes[0].childNodes[0];
    if(member.childNodes[0].childNodes[0].nodeValue == 'candidate'){
	var candidate_array = new Array();
	var candidate_array_node = member.childNodes[1].childNodes[0].childNodes[0];
	for(i=0; i < candidate_array_node.childNodes.length; i += 1){
	    var array = new Array();
	    array_node = candidate_array_node.childNodes[i].childNodes[0].childNodes[0];
	    for(ii = 0; array_node.childNodes.length > ii; ii++){
		var candidate = array_node.childNodes[ii].childNodes[0].childNodes[0].nodeValue;
		array[array.length] = candidate;
	    }
	    candidate_array[candidate_array.length] = array;
	}
	output = format(candidate_array);
    }else{
	// no candidate
    }
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

function method_define(){
    var method = document.getElementById('method');
    if(method.value == 'stable' && method.checked){
	return '';
    }else{
	return '_dev';
    }
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
