/////////////////////////////////////////////////////////////////////////////////////////////
//
// Sumibi Ajax is a client for Sumibi server.
//
//   Copyright (C) 2005 ktat atusi@pure.ne.jp
//     $Date: 2006/12/23 01:43:29 $
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
var SUMIBI_DEBUG = 'sumibi_debug'; // div id for debug
// var URL_PREFIX = "./nph-proxy.cgi/010110A/http/sumibi.org/cgi-bin/sumibi/";
var URL_PREFIX = "/cgi-bin/sumibi/";
var PROGRESS_MESSAGE = '<blink>waiting server response ... </blink><br>';
var PROGRESS_MESSAGE_COLOR = '#000000';
var PROGRESS_MESSAGE_ERROR = 'cannot convert';
var PROGRESS_MESSAGE_ERROR_COLOR = '#FF00000';
var SUMIBI_IME_COLOR = '#EEDDDD';
var SUMIBI_IME_LAYER_N = '100';
var SUMIBI_DEFAULT_SERVER = 'stable';

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
function Sumibi( progress, ime, type, guide){
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
	this.type = server
    }else if(! this.type){
    	this.type = SUMIBI_DEFAULT_SERVER;
    }
    if(this.type == 'unstable'){
	type = 'unstable';
    }else if(this.type == 'testing'){
	type = 'testing';
    }else{
	type = 'stable';
    }
    sdebug(URL_PREFIX + type + "/sumibi.cgi")
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
	output += ' <select  size=3  name="sumibi_candiate" id="sumibi_candidate' + this.qbox.id + i
//	    + '" onChange="sumibi_display_result()" onKeyPress="Sumibi_key_process_in_select( "' + this.qbox.id + '", event, '
	    + '" onKeyPress="Sumibi_key_process_in_select( \'' + this.qbox.id + '\', event, ' + i
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
    output += '<div style="display:inline;">' 
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
    if(this.qbox.sumibi_set){
	this.qbox.sumibi_set.style.zIndex = (SUMIBI_IME_LAYER_N = SUMIBI_IME_LAYER_N + 1);
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
    output = '<span id="sumibi_backward' +  qbox_id + '" style="display:none">&lt;&lt;<a href="#" onClick="sumibi_backward(\'' + qbox_id + '\');return false">';
    output += Sumibi_get_backward_button_label( ) +  '</a>&nbsp;</span>';
    output += '<span id="sumibi_spacer' +  qbox_id + '" style="display:none"></span>'
    output += '<span id="sumibi_forward' +  qbox_id + '" style="display:none">&nbsp;<a href="#" onClick="sumibi_forward(\'' + qbox_id + '\');return false">';
    output += Sumibi_get_forward_button_label( ) + '</a>&gt;&gt;</span>';
    if(this.qbox.sumibi_set){
	output += '<a href="#" id="sumibi_close"' + qbox_id + ' onClick="document.getElementById(\'' + qbox_id + '\').sumibi_set.style.display = \'none\'; return false">';
	output += Sumibi_close_history_button_label() + '</a>';
    }
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
    if(this.guide){
	this.guide.innerHTML = "";
    }
    sumibi_spacer(this);
    return result;
}

//********************************************************************
// 候補を決定し、渡された文字列中から query と 候補選択結果を置換する
//********************************************************************
Sumibi.prototype.replaceQueryByResult = function(q){
    this.hist[this.sumibi_convert_count] = q;
    var query = this.query[this.query.length - 1];
    var defined = this.defineCandidate(q);
    var regexp  = query.replace(/(\W)/g, "\\$1");
    regexp  = regexp.replace(/\\\s+$/, "");
    var reg = new RegExp(regexp);
    q = q.replace(reg, defined);
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
    if(sumibi.qbox.sumibi_set){
	sumibi.qbox.sumibi_set.style.display = 'inline';
    }
    var xmlhttp = this.createXmlHttp();
    // alert(this.query.length);  alert(num);
    try {
	xmlhttp.open("POST", this.server(), true);
	xmlhttp.setRequestHeader("MessageType", "CALL");
	xmlhttp.setRequestHeader("Content-Type", "text/xml");
	xmlhttp.onreadystatechange = function () {
	    sumibi.progress.innerHTML = PROGRESS_MESSAGE;
	    sumibi.progress.style.display = 'inline';
	    sdebug( xmlhttp.readyState );
	    if (xmlhttp.readyState == XMLHTTP_LOAD_COMPLETE ) {
		if(xmlhttp.responseText) {
		    sdebug(xmlhttp.responseText);
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

Sumibi.prototype.guideRoman2Kana = function(q){
    q = q[0];
    if(this.guide){
	q = q.replace(/([cdkstnfhmyrwgzdbpjv])\1/g, "っ$1");
	for (var i = 0; i < ROMAN2KANA.length; i += 2) {
	    var reg = new RegExp(ROMAN2KANA[i], 'g');
	    q = q.replace(reg, ROMAN2KANA[i + 1]);
	}
	this.guide.innerHTML = q + '<br>';
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
	var sumibi_set   = document.createElement('span'); // guide, progress, ime, hist を格納するdiv
	var guide        = document.createElement('span');
	var progress     = document.createElement('span');
	var ime          = document.createElement('span');
	var history_html = document.createElement('span');
	sumibi_set.appendChild(guide);
	sumibi_set.appendChild(progress);
	sumibi_set.appendChild(history_html);
	sumibi_set.appendChild(ime);
	var pos = getElementPosition(qbox);
	var sumibi_customize_func = 'Sumibi_key_process_in_text(\'' + qbox.id + '\', event)';
        var isIE = (document.documentElement.getAttribute("style") ==
                    document.documentElement.style);
        if(isIE){
		qbox.setAttribute("onkeypress", new Function(sumibi_customize_func));
	}else{
		qbox.setAttribute("onKeyPress", sumibi_customize_func);
	}
	qbox.setAttribute("onclick", new Function(sumibi_customize_func));
	document.body.appendChild(sumibi_set);
	sumibi_set.style.position = 'absolute';
	sumibi_set.style.backgroundColor = SUMIBI_IME_COLOR;
	sumibi_set.style.left = pos['left'] + 'px';
	sumibi_set.style.top = pos['top'] + qbox.offsetHeight + 'px';;
	sumibi_set.style.border = 'solid';
	sumibi_set.style.borderWidth = '1px';
	sumibi_set.style.display = 'none';
	progress.style.display = 'inline';
	ime.style.display = 'inline';
	history_html.style.display = 'inline';
	array = [progress, ime, SUMIBI_DEFAULT_SERVER, guide, history_html];
	qbox.sumibi_set = sumibi_set;
    }

    var sumibi = new SumibiSOAP(array[0], array[1], array[2], array[3]);

    qbox.sumibi = sumibi;
    sumibi.qbox = qbox;
    sumibi.history_html = array[4];
    sumibi.historyHTML();
    checkKeyInput(sumibi, qbox.id);
    return sumibi;
}

function checkKeyInput(sumibi, qbox_id){
    var qbox = document.getElementById(qbox_id);
    if(! sumibi){
	sumibi = qbox.sumibi;
    }
    // if(qbox.use_sumibi === true && qbox && qbox.value){
    if(qbox && qbox.value){
	var ret;
	if(ret = sumibi.setQueryFrom(qbox.value)){
	    sumibi.doConvert(ret);
	    sumibi.guideRoman2Kana(ret);
	}
    }
    var func = "checkKeyInput('', '" + qbox_id + "')";
    setTimeout(func, 1000);
}

function sumibi_define_candidate(qbox_id){
    // 決定テキストボックスがある場合
    // defined.value += sumibi.defineCandidate(query.value);
    var qbox = document.getElementById(qbox_id);
    var sumibi = qbox.sumibi;
    qbox.value = sumibi.replaceQueryByResult(qbox.value);
    sumibi.ime.innerHTML = '';
    sumibi.history_number = sumibi.hist.length - 1;
    sumibi.historyHTML();
    if(sumibi.hb){
	sumibi.hb.style.display = 'inline';
    }
    // テキストボックスにフォーカスを返しておく
    qbox.focus();
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
    var spacer = '';
    if(sumibi.hb.style.display == 'none' && sumibi.hf.style.display == 'none'){
	for(var i = 0; i <= Sumibi_get_backward_button_label( ).length + 2; i++){
	    spacer += '&nbsp;';
	}
	for(var i = 0; i <= Sumibi_get_forward_button_label( ).length + 2; i++){
	    spacer += '&nbsp;';
	}
	sumibi.hs.style.display = 'inline';
	sumibi.hs.innerHTML = spacer;
    }else if(sumibi.hb.style.display == 'none'){
	for(var i = 0; i <= Sumibi_get_backward_button_label( ).length + 2; i++){
	    spacer += '&nbsp;';
	}
	sumibi.hs.style.display = 'inline';
	sumibi.hs.innerHTML = spacer;
    }else if(sumibi.hf.style.display == 'none'){
	for(var i = 0; i <= Sumibi_get_forward_button_label( ).length + 2; i++){
	    spacer += '&nbsp;';
	}
	sumibi.hs.style.display = 'inline';
	sumibi.hs.innerHTML = spacer;
    }else{
	sumibi.hs.style.display = 'none';	
    }
}

function sdebug(message){
    var sdebug = document.getElementById(SUMIBI_DEBUG);
    if(sdebug){
	// var m  = message.replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/\n/g, "<br>");
	sdebug.value += message + "\n\n";
    }
}

onload = function ()
 {
   var inputs = document.getElementsByTagName("input");
   var input_ids = new Array;
   for (var i = 0; i < inputs.length; ++i) {
     if(inputs[i].type == "text"){
	 if(! inputs[i].use_sumibi){
	     input_ids.push(inputs[i].id);
	 }
     }
   }
   var textareas = document.getElementsByTagName("textarea");
   for (var i = 0; i < textareas.length; ++i) {
       if(textareas[i].id != SUMIBI_DEBUG){
	   if(! textareas[i].use_sumibi){
	       input_ids.push(textareas[i].id);
	   }
       }
   }
   for (var i = 0; i < input_ids.length; ++i) {
       sumibi_create_object(document.getElementById(input_ids[i]));
   }
 }

//**************************************************************
// ローマ字かな変換テーブル(順番が重要なので配列)
//**************************************************************

var ROMAN2KANA =
    [
     'nnn', 'んn',
     "[lx]wa","ゎ",
     '[lx]a', 'ぁ',
     '[lx]i', 'ぃ',
     '[lx]u', 'ぅ',
     'vu', 'う゛',
     'va', 'う゛ぁ',
     'vi', 'う゛ぃ',
     've', 'う゛ぇ',
     'vo', 'う゛ぉ',
     '[lx]e', 'ぇ',
     '[lx]o', 'ぉ',
     '[ck]a', 'か',
     'ga', 'が',
     '[ck]i', 'き',
     'kya', 'きゃ',
     'kyu', 'きゅ',
     'kyo', 'きょ',
     'gi', 'ぎ',
     '[ck]u', 'く',
     'gu', 'ぐ',
     '[ck]e', 'け',
     'ge', 'げ',
     '[ck]o', 'こ',
     'go', 'ご',
     'sa', 'さ',
     'za', 'ざ',
     'sh?i', 'し',
     'sha', 'しゃ',
     's[hy]e', 'しぇ',
     's[hy]a', 'しゃ',
     's[hy]u', 'しゅ',
     's[hy]o', 'しょ',
     '[zj]i', 'じ',
     'ja', 'じゃ',
     'zya', 'じゃ',
     'ju', 'じゅ',
     'zyu', 'じゅ',
     'jo', 'じょ',
     'zyo', 'じょ',
     'su', 'す',
     'zu', 'ず',
     'se', 'せ',
     'ze', 'ぜ',
     'so', 'そ',
     'zo', 'ぞ',
     'ta', 'た',
     'da', 'だ',
     'da', 'だ',
     'chi', 'ち',
     'ti', 'ち',
     '[ct]ya', 'ちゃ',
     '[ct]yu', 'ちゅ',
     '[ct]yo', 'ちょ',
     'di', 'ぢ',
     'di', 'ぢ',
     'dyi', 'ぢぃ',
     'dye', 'ぢぇ',
     'dya', 'ぢゃ',
     'dyu', 'ぢゅ',
     'dyo', 'ぢょ',
     'xtu', 'っ',
     'ts?u', 'つ',
     'du', 'づ',
     'du', 'づ',
     'te', 'て',
     'de', 'で',
     'de', 'で',
     'dhi', 'でぃ',
     'to', 'と',
     'do', 'ど',
     'do', 'ど',
     'na', 'な',
     'ni', 'に',
     'nya', 'にゃ',
     'nyu', 'にゅ',
     'nyo', 'にょ',
     'nu', 'ぬ',
     'ne', 'ね',
     'no', 'の',
     'ma', 'ま',
     'mi', 'み',
     'mya', 'みゃ',
     'myu', 'みゅ',
     'myo', 'みょ',
     'mu', 'む',
     'me', 'め',
     'mo', 'も',
     '[lx]ya', 'ゃ',
     '[lx]yu', 'ゅ',
     '[lx]yo', 'ょ',
     'ra', 'ら',
     'ri', 'り',
     'rya', 'りゃ',
     'ryu', 'りゅ',
     'ryo', 'りょ',
     'ru', 'る',
     're', 'れ',
     'ro', 'ろ',
     'wa', 'わ',
     'wi', 'ゐ',
     'we', 'ゑ',
     'wo', 'を',
     'ha', 'は',
     'ba', 'ば',
     'pa', 'ぱ',
     'hi', 'ひ',
     'hya', 'ひゃ',
     'hyu', 'ひゅ',
     'hyo', 'ひょ',
     'bi', 'び',
     'pi', 'ぴ',
     'pya', 'ぴゃ',
     'pyu', 'ぴゅ',
     'pyo', 'ぴょ',
     '[hf]u', 'ふ',
     'fa', 'ふぁ',
     'fi', 'ふぃ',
     'fe', 'ふぇ',
     'fo', 'ふぉ',
     'bu', 'ぶ',
     'pu', 'ぷ',
     'he', 'へ',
     'be', 'べ',
     'pe', 'ぺ',
     'ho', 'ほ',
     'bo', 'ぼ',
     'po', 'ぽ',
     'ya', 'や',
     'yu', 'ゆ',
     'yo', 'よ',
     'a', 'あ',
     'i', 'い',
     'u', 'う',
     'e', 'え',
     'o', 'お',
     'nn?', 'ん',
     '\-', 'ー'
     //'ー', '\^', 
];

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
