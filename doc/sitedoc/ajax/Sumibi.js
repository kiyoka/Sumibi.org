/////////////////////////////////////////////////////////////////////////////////////////////
//
// Sumibi Ajax is a client for Sumibi server.
//
//   Copyright (C) 2005 ktat atusi@pure.ne.jp
//     $Date: 2005/07/18 15:44:07 $
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
// Sumibi Class
//
//********************************************************************

//********************************************************************
// 定数定義
//********************************************************************

var XMLHTTP_LOAD_COMPLETE = 4;
var XMLHTTP_HTTP_STATUS = 200;
var MSXMLHTTP = false;
// var URL_PREFIX = "./nph-proxy.cgi/010110A/https/sumibi.org/cgi-bin/sumibi/";
var URL_PREFIX = "../";
var PROGRESS_MESSAGE = '&nbsp;&nbsp;&nbsp;<blink>waiting server response ...</blink>';
var PROGRESS_MESSAGE_COLOR = '#000000';
var PROGRESS_MESSAGE_ERROR = 'cannnot convert';
var PROGRESS_MESSAGE_ERROR_COLOR = '#FF00000';

//********************************************************************
// クラス変数(っていえる?)
//********************************************************************

var SUMIBI_CONVERT_COUNT = 0; // 変換回数を記録する

//********************************************************************
// コンストラクタ
//
// new Sumibi( progress, ime, type);
//
// type ........ stable, testing, unstble
// ime  ........ メッセージ用ブロックオブジェクト
// progress  ... 進行メッセージ用ブロックオブジェクト
//
//********************************************************************
function Sumibi( progress, ime, type){
    this.progress = progress;  // 進捗メッセージ用ブロックオブジェクト
    this.type = type;          // タイプ(stable, testing, unstable)
    this.ime = ime;            // 変換選択用フォームを格納するブロックオブジェクト
    this.query = new Array();  // 変換する文字を格納する配列
    this.hist = new Array();
    return this;
}

//********************************************************************
// XMLhttpRequest オブジェクトの作成
//********************************************************************
Sumibi.prototype.createXmlHttp = function() {
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

//********************************************************************
// 渡された文字列中からqueryとなるべき文字列を取得してメンバに格納
//
//  返すのは 配列
//     array[0] ... query
//     array[1] ... sumibi.query の配列の長さ
//
//********************************************************************
Sumibi.prototype.setQueryFrom = function(q){
    var m = q.replace(/\s+$/, ' ');
    m = m.match(/[\x20-\x7e]+[\x20\.,\!\?]\x20*$/i);
    var r = '';
    if(m){
	var i;
	for(i = 0; i < m.length; i++){
	    r += m[i];
	}
	if(sumibi.query[sumibi.query.length - 1] != r){
	    // alert('0:' + r);
	    // alert('1:' + sumibi.query);
	    if(r.length > 0){
		var n = sumibi.query.length;
		var ret = new Array();
		ret[0] = sumibi.query[n] = r;
		ret[1] = n;
		return ret;
	    }else{
		return;
	    }
	}
    }
    return 0;
}

//********************************************************************
// サーバの決定
//********************************************************************
Sumibi.prototype.server = function(server){
    if(server){
	this.type = server;
    }
    if(this.type == 'unstable'){
	type = 'unstable';
    }else if(this.type == 'testing'){
	type = 'for_toppage';
    }else{
	type = 'stable';
    }
    return URL_PREFIX + type + "/sumibi.cgi";
}

//********************************************************************
// 候補選択用HTMLを返す
//
// 内部で sumibi_define_candidate, sumibi_display_result
// が呼ばれるので、これは別のところで実装する必要があります。
//********************************************************************
Sumibi.prototype.format = function(array){
    var output = '[変換候補] ';
    for(i=0; i < array.length; i++){
        if(array[i].length > 1){
	    output += ' <select name="sumibi_candiate" id="sumibi_candidate' + i + '" onChange="sumibi_display_result()">';
	    for(ii=0; ii < array[i].length; ii++){
		output += '<option value="' + array[i][ii] + '">' + array[i][ii];
	    }
	    output += '</select>';
	}else{
	    output += '<input type="hidden" name="sumibi_candidate" id="sumibi_candidate' + i + '" value="' + array[i][0] +'">' + array[i][0];
	}
    }
    output += '<input type="button" id="define" name="define" value="確定" onClick="sumibi_define_candidate()">';
    return output;
}

//********************************************************************
// Undo Redo 用HTMLを返す
//
// 内部で sumibi_forward, sumibi_backward
// が呼ばれるので、これは別のところで実装する必要があります。
//********************************************************************
Sumibi.prototype.historyHTML = function(block){
    var output;
    output  = '<span id="sumibi_backward" style="display:none">&lt;&lt;<a href="" onClick="sumibi_backward();return false">戻る</a></span>&nbsp;';
    output += '<span id="sumibi_forward" style="display:none"><a href="" onClick="sumibi_forward();return false">進む</a>&gt;&gt;</span>';
    block.innerHTML = output;
    sumibi.hb = document.getElementById('sumibi_backward'); // backward
    sumibi.hf = document.getElementById('sumibi_forward');  // forward
}

Sumibi.prototype.forward = function(h){
    if(sumibi.hist[h + 1]){
	h += 1;
	query.value = sumibi.hist[h];
	sumibi.setQueryFrom(query.value);
	sumibi.hb.style.display = 'inline';
	if(sumibi.hist[h + 1]){
	    sumibi.hf.style.display = 'inline';
	}else{
	    sumibi.hf.style.display = 'none';
	}
    }
    return h;
}

Sumibi.prototype.backward = function(h){
    if(sumibi.hist[h - 1]){
	h -= 1;
	query.value = sumibi.hist[h];
	sumibi.setQueryFrom(query.value);
	sumibi.hf.style.display = 'inline';
	if(sumibi.hist[h - 1]){
	    sumibi.hb.style.display = 'inline';
	}else{
	    sumibi.hb.style.display = 'none';
	}
    }
    return h;
}

//********************************************************************
// 選択されている候補を結合して返す
//********************************************************************
Sumibi.prototype.displayResult = function(){
    var select;
    var output = '';
    for(i = 0;select  = document.getElementById('sumibi_candidate' + i); i++){
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
    return output;
}

//********************************************************************
// 選択されている候補に決定
//********************************************************************
Sumibi.prototype.defineCandidate = function(){
    var result = this.displayResult();
    this.query = new Array();
    this.ime.innerHTML = '';
    this.progress.innerHTML = '';
    this.convert_count = 0;
    ++SUMIBI_CONVERT_COUNT;
    return result;
}

//********************************************************************
// 候補を決定し、渡された文字列中から query と 候補選択結果を置換する
//********************************************************************
Sumibi.prototype.replaceQueryByResult = function(q){
    sumibi.hist[SUMIBI_CONVERT_COUNT] = q;
    var query = this.query[this.query.length - 1];
    var defined = sumibi.defineCandidate(q);
    var regexp  = query.replace(/(\W)/g, "\\$1");
    regexp  = regexp.replace(/\\\s+$/, "");
    var reg = new RegExp(regexp);
    q = q.replace(reg, defined);
    // definedCndidate で SUMIBI_CONVERT_COUNT は 1 増加してる
    sumibi.hist[SUMIBI_CONVERT_COUNT] = q;
    return q;
}

//********************************************************************
// xmlhttp Post Request;
//
//  http://naoya.dyndns.org/~naoya/mt/archives/001610.html
//  のエントリを参考にしてます。
//********************************************************************
Sumibi.prototype.doSoapRequest = function(xml_message, num){
    var count   = SUMIBI_CONVERT_COUNT;
    var sumibi  = this;
    var xmlhttp = this.createXmlHttp();
    // alert(sumibi.query.length);  alert(num);
    try {
	xmlhttp.open("POST", sumibi.server(), true);
	xmlhttp.setRequestHeader("MessageType", "CALL");
	xmlhttp.setRequestHeader("Content-Type", "text/xml");
	xmlhttp.onreadystatechange = function () {
	    sumibi.progress.innerHTML = PROGRESS_MESSAGE;
	    sumibi.progress.style.display = 'block';
	    if (xmlhttp.readyState == XMLHTTP_LOAD_COMPLETE) {
		// alert(xmlhttp.responseText);
		if(sumibi.query.length - 1 != num || count != SUMIBI_CONVERT_COUNT){
		    // 返された処理が最新のものかどうかチェック
		    // alert('old response 3 :' + num + ':' + sumibi.query.length + ':' + SUMIBI_CONVERT_COUNT);
		    return;
		}
		var candidate_array = sumibi.parseXML(xmlhttp.responseXML);
		if (candidate_array) {
		    sumibi.ime.innerHTML = sumibi.format(candidate_array);
		    sumibi.ime.style.display = 'block';
		    if((sumibi.query.length - 1) == num && sumibi.progress){
			sumibi.progress.style.color = PROGRESS_MESSAGE_COLOR;
			sumibi.progress.style.display = 'none';
		    }
		}else if(progress){
		    sumibi.progress.innerHTML = PROGRESS_MESSAGE_ERROR;
		    sumibi.progress.style.color = PROGRESS_MESSAGE_ERROR_COLOR;
		}
	    } else {
		if(xmlhttp.statusText != 'OK'){
		    sumibi.progress.innerHTML = xmlhttp.statusText;
		}
	    }
	}
	// alert(xml_message);
	xmlhttp.send(xml_message);
	xmlhttp.close;
    } catch (e) {
	sumibi.progress.innerHTML = e;
	sumibi.progress.style.display = 'block';
    }
}

//************************************************************
//
// サブクラスで実装すべきもの
//
//************************************************************

//************************************************************
// Sumibiサーバに渡すXMLリクエストを作る
//************************************************************
Sumibi.prototype.doConvertXML = function(){
    alert('this method needs to be defined in subclass.');
}

//************************************************************
// 変換メソッド
//************************************************************
Sumibi.prototype.doConvert = function(){
    alert('this method needs to be defined in subclass.');
}

//************************************************************
// レスポンスXMLの解析
//************************************************************
Sumibi.prototype.parseXML = function(){
    alert('this method needs to be defined in subclass.');
}
