/////////////////////////////////////////////////////////////////////////////////////////////
//
// Sumibi Ajax is a client for Sumibi server.
//
//   Copyright (C) 2005 ktat atusi@pure.ne.jp
//     $Date: 2006/11/29 18:45:34 $
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
var URL_PREFIX = "/";
var PROGRESS_MESSAGE = '&nbsp;&nbsp;&nbsp;<blink>waiting server response ...</blink>';
var PROGRESS_MESSAGE_COLOR = '#000000';
var PROGRESS_MESSAGE_ERROR = 'cannot convert';
var PROGRESS_MESSAGE_ERROR_COLOR = '#FF00000';

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
    this.old_xmlhttp = null;
    this.sumibi_convert_count = 0;
    return this;
}

//********************************************************************
// XMLhttpRequest オブジェクトの作成
//********************************************************************
Sumibi.prototype.createXmlHttp = function() {
    var xmlhttp = false;
    if(this.old_xmlhttp && this.old_xmlhttp.readyState !== 0){
	// 古いリクエストをabort()する
	this.old_xmlhttp.abort();
	this.old_xmlhttp = null;
    }
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
    this.old_xmlhttp = xmlhttp;
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
	if(this.query[this.query.length - 1] != r){
	    // alert('0:' + r + ' ' + this.query[this.query.length - 1] );
	    // alert('1:' + this.query);
	    if(r.length > 0){
		var n = this.query.length;
		var ret = new Array();
		ret[0] = this.query[n] = r;
		ret[1] = n;
		return ret;
	    }else{
		return;
	    }
	}
    }
    return(0);
}

//********************************************************************
// サーバの決定
//********************************************************************
Sumibi.prototype.server = function(server){
    if(server){
	this.type = server;
    }
    if(this.type == 'unstable'){
	type = 'for_toppage';
    }else if(this.type == 'testing'){
	type = 'testing';
    }else{
	type = 'stable';
    }
type = 'stable';
    return URL_PREFIX + type + "/sumibi.cgi";
}

//********************************************************************
// 候補選択用HTMLを返す
//
// 内部で sumibi_define_candidate, sumibi_display_result
// が呼ばれるので、これは別のところで実装する必要があります。
//********************************************************************
Sumibi.prototype.format = function(array){
    var output = Sumibi_get_kouho_desc_label( );
    for(i=0; i < array.length; i++){
	output += ' <select  size=3  name="sumibi_candiate" id="sumibi_candidate' + this.qbox.id
	    + i
//	    + '" onChange="sumibi_display_result()" onKeyPress="Sumibi_key_process_in_select( "' + this.qbox.id + '", event, '
	    + '" onKeyPress="Sumibi_key_process_in_select( "' + this.qbox.id + '", event, '
	    + i
	    + ' )">';
	for(ii=0; ii < array[i].length; ii++){
	    output += '<option value="'
		+ array[i][ii]["space"] + array[i][ii]["word"] + '"';
	    if ( 0 == ii ) {
		output += ' selected ';
	    }
	    output += '>'
		+ array[i][ii]["space_mark"] + array[i][ii]["word"];
	}
	output += '</select>';
    }
    output += '<div style="text-align:center;">' 
    + '<input type="button" id="define" name="define" value="'
    + Sumibi_get_kakutei_button_label( )
    + '" onClick="sumibi_define_candidate(\'' + this.qbox.id + '\')">'
    + '</div>';

    // hook関数用の引数を作る ( 第一候補文字列の配列 )
    var space_for_hook = new Array();
    var words_for_hook = new Array();
    for(i=0; i < array.length; i++){
	space_for_hook[i] = array[i][0]["space"];
	words_for_hook[i] = array[i][0]["word"];
    }
    // hook関数の呼び出し
    output += Sumibi_candidate_html_hook(this, space_for_hook, words_for_hook );

    return output;
}

//********************************************************************
// Undo Redo 用HTMLを返す
//
// 内部で sumibi_forward, sumibi_backward
// が呼ばれるので、これは別のところで実装する必要があります。
//********************************************************************
Sumibi.prototype.historyHTML = function(){
    var block = this.history_html;
    var output;
    var qbox_id = this.qbox.id;
    output = '<span id="sumibi_backward' +  qbox_id + '" style="display:none">&lt;&lt;<a href="#" onClick="sumibi_backward(\'' + qbox_id + '\');return false">' + Sumibi_get_backward_button_label( ) +  '</a></span>&nbsp;';
    output += '<span id="sumibi_spacer' +  qbox_id + '">&nbsp;&nbsp;&nbsp;&nbsp;</span>';
    output += '<span id="sumibi_forward' +  qbox_id + '" style="display:none"><a href="#" onClick="sumibi_forward(\'' + qbox_id + '\');return false">' + Sumibi_get_forward_button_label( ) + '</a>&gt;&gt;</span>';
    block.innerHTML = output;
    this.hb = document.getElementById('sumibi_backward' + qbox_id); // backward
    this.hf = document.getElementById('sumibi_forward' + qbox_id);  // forward
    this.hs = document.getElementById('sumibi_spacer' + qbox_id);   // spacer
}

Sumibi.prototype.forward = function(){
    var h = this.history_number
    var query = this.qbox;
    if(this.hist[h + 1]){
	h += 1;
	query.value = this.hist[h];
	this.setQueryFrom(query.value);
	this.hb.style.display = 'inline';
	if(this.hist[h + 1]){
	    this.hf.style.display = 'inline';
	}else{
	    this.hf.style.display = 'none';
	}
    }
    this.history_number = h;
}

Sumibi.prototype.backward = function(){
    var h = this.history_number
    var query = this.qbox;
    if(this.hist[h - 1]){
	h -= 1;
	query.value = this.hist[h];
	this.setQueryFrom(query.value);
	this.hf.style.display = 'inline';
	if(this.hist[h - 1]){
	    this.hb.style.display = 'inline';
	}else{
	    this.hb.style.display = 'none';
	}
    }
    this.history_number = h;
}

//********************************************************************
// 選択されている候補を結合して返す
//********************************************************************
Sumibi.prototype.displayResult = function(){
    var select;
    var output = '';
    for(i = 0;select  = document.getElementById('sumibi_candidate' + this.qbox.id + i); i++){
	if(select.type == 'hidden'){
	    output += select.value;
	}else{
	    for(ii = 0; ii < select.length; ii++){
		if(select[ii].selected === true){
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
    ++this.sumibi_convert_count;
    if(this.hf){
	this.hf.style.display = 'none';
    }
    return result;
}

//********************************************************************
// 候補を決定し、渡された文字列中から query と 候補選択結果を置換する
//********************************************************************
Sumibi.prototype.replaceQueryByResult = function(q){
    this.hist[this.sumibi_convert_count] = q;
    var query = this.query[this.query.length - 1];
//alert('0. ' + query);
    var defined = this.defineCandidate(q);
    var regexp  = query.replace(/(\W)/g, "\\$1");
    regexp  = regexp.replace(/\\\s+$/, "");
    var reg = new RegExp(regexp);
// alert('1. ' + q + ': ' + defined +  ': ' + reg + ': ' + regexp);
    q = q.replace(reg, defined);
// alert('2. ' + q + ': ' + defined + ': ' + reg);
    // definedCndidate で this.sumibi_convert_count は 1 増加してる
    this.hist[this.sumibi_convert_count] = q;
    return q;
}

//********************************************************************
// xmlhttp Post Request;
//
//  http://naoya.dyndns.org/~naoya/mt/archives/001610.html
//  のエントリを参考にしてます。
//********************************************************************
Sumibi.prototype.doSoapRequest = function(xml_message, num){
    var sumibi  = this;
    var xmlhttp = this.createXmlHttp();
    // alert(this.query.length);  alert(num);
    try {
	xmlhttp.open("POST", this.server(), true);
	xmlhttp.setRequestHeader("MessageType", "CALL");
	xmlhttp.setRequestHeader("Content-Type", "text/xml");
	xmlhttp.onreadystatechange = function () {
	    sumibi.progress.innerHTML = PROGRESS_MESSAGE;
	    sumibi.progress.style.display = 'block';
	    //alert( xmlhttp.readyState );
	    if (xmlhttp.readyState == XMLHTTP_LOAD_COMPLETE ) {
		if(xmlhttp.responseText) {
		    // alert(xmlhttp.responseText);
		    var candidate_array = sumibi.parseXML(xmlhttp.responseXML);
		    if (candidate_array) {
			sumibi.ime.innerHTML = sumibi.format(candidate_array);
			sumibi.ime.style.display = 'block';
			if((sumibi.query.length - 1) == num && sumibi.progress){
			    sumibi.progress.style.color = PROGRESS_MESSAGE_COLOR;
			    sumibi.progress.style.display = 'none';
			}
		    }else if(sumibi.progress){
			sumibi.progress.innerHTML = PROGRESS_MESSAGE_ERROR;
			sumibi.progress.style.color = PROGRESS_MESSAGE_ERROR_COLOR;
		    }
		}
	    }
	}
	xmlhttp.send(xml_message);
	xmlhttp.close;
    } catch (e) {
	this.progress.innerHTML = e;
	this.progress.style.display = 'block';
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

//************************************************************
// 関数群
//************************************************************

// Sumibi オブジェクト作成関数
function sumibi_create_object(qbox, array){
    if(! array){
	var server_type = 'unstable';
	var sumibi_set = document.createElement('div'); // progress, ime, hist を格納するdiv
	var progress     = document.createElement('div');
	var ime          = document.createElement('div');
	var history_html = document.createElement('div');
	sumibi_set.appendChild(history_html);
	sumibi_set.appendChild(ime);
	sumibi_set.appendChild(progress);
	qbox.nextSibling.appendChild(sumibi_set);
	array = [progress, ime, server_type, history_html];
    }

    var sumibi = new SumibiSOAP(array[0], array[1], array[2], array[3]);

    qbox.sumibi = sumibi;
    sumibi.qbox = qbox;
    sumibi.history_html = array[3];
    sumibi.historyHTML();
    checkKeyInput(sumibi, qbox.id);
    return sumibi;
}

function checkKeyInput(sumibi, query_id){
    var query = document.getElementById(query_id);
    if(! sumibi){
	sumibi = query.sumibi;
    }
    if(query.use_sumibi === true && query && query.value){
	var ret;
	if(ret = sumibi.setQueryFrom(query.value)){
	    sumibi.doConvert(ret);
	}
    }
    var func = "checkKeyInput('', '" + query_id + "')";
    setTimeout(func, 1000);
}

function select_server(server){
    sumibi.server(server);
}

function sumibi_define_candidate(qbox_id){
    // 決定テキストボックスがある場合
    // defined.value += sumibi.defineCandidate(query.value);
    var query = document.getElementById(qbox_id);
    var sumibi = query.sumibi;
    query.value = sumibi.replaceQueryByResult(query.value);
    sumibi.ime.innerHTML = '';
    sumibi.history_number = sumibi.hist.length - 1;
    sumibi.historyHTML();
    if(sumibi.hb){
	sumibi.hb.style.display = 'inline';
    }
    // テキストボックスにフォーカスを返しておく
    query.focus();
}

function sumibi_forward(qbox_id){
    var sumibi = document.getElementById(qbox_id).sumibi;
    sumibi.forward();
    sumibi_spacer(sumibi);
}

function sumibi_backward(qbox_id){
    var sumibi = document.getElementById(qbox_id).sumibi;
    sumibi.backward();
    sumibi_spacer(sumibi);
}

function sumibi_spacer(sumibi){
    //    alert(sumibi.hf.style.display == 'none');
    if(sumibi.hb.style.display == 'none' || sumibi.hf.style.display == 'none'){
	sumibi.hs.style.display = 'inline';
    }else{
	sumibi.hs.style.display = 'none';
    }
}

function sumibinize(target, i){
    if(target.sumibi){
	return;
    }
    var class_name = target.nextSibling.getAttribute('class') || target.nextSibling.getAttribute('className');
    if (      (target.type == "text" || target.type == "textarea")
	   && class_name == 'use_sumibi' 
	   ){
	// input_ids[i] = target.id;
	var type;
	if(target.type == 'text'){
	    type = 'input';
	}else if(target.type == 'textarea'){
	    type = 'textarea';
	}
	
	var sumi =  target.nextSibling;
	var sumi_mark = document.createElement('span');
	sumi.style.display = 'inline';


	var isIE = (document.documentElement.getAttribute("style") ==
        	    document.documentElement.style);
	if(isIE){
	sumi_mark.setAttribute
            ('onclick', new Function(
             'if(this.style.color == "red"){' +
             'this.style.color = "";' +
             'document.getElementsByTagName("' + type + '")[' + i + '].use_sumibi = false' +
             '}else{' +
             'this.style.color = "red";' +
             'document.getElementsByTagName("' + type + '")[' + i + '].use_sumibi = true' +
             '}')
             );
	}else{
	sumi_mark.setAttribute
	    ('onClick',
	     'if(this.style.color == "red"){' + 
	     'this.style.color = "";' + 
	     'document.getElementsByTagName("' + type + '")[' + i + '].use_sumibi = false' +
	     '}else{' + 
	     'this.style.color = "red";' +
	     'document.getElementsByTagName("' + type + '")[' + i + '].use_sumibi = true' +
	     '}'
	     );
	}
	sumi_mark.innerHTML = ' SUMI ';
	sumi.appendChild(sumi_mark);
	return(target.id);
    }
    return(null);
}

function sumibi_enable(e){
 	   if(e.style.color == "red"){
            	e.style.color = "";
            	document.getElementsByTagName("' + type + '")[' + i + '].use_sumibi = false
            }else{
            	e.style.color = "red";
            	document.getElementsByTagName("' + type + '")[' + i + '].use_sumibi = true;
            }

}

onload = function ()
 {
   var inputs = document.getElementsByTagName("input");
   var input_ids = new Array;
   for (var i = 0; i < inputs.length; ++i) {
     if(inputs[i].type == "text"){
       var id = sumibinize(inputs[i], i);
       if(id) input_ids.push(id);
     }
   }
   var textareas = document.getElementsByTagName("textarea");
   for (var i = 0; i < textareas.length; ++i) {
     var id = sumibinize(textareas[i], i);
     if(id) input_ids.push(id);
   }
   for (var i = 0; i < input_ids.length; ++i) {
       sumibi_create_object(document.getElementById(input_ids[i]));
   }
 }

//**************************************************************
// 結果テキストボックスがある場合
//**************************************************************

// checkResultBox();

// function checkResultBox(){
//    sumibi_display_result();
//    setTimeout("checkResultBox()", 100);
// }

// function sumibi_display_result(){
//     resultbox.value = sumibi.displayResult();
// }

