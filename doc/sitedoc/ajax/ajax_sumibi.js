/////////////////////////////////////////////////////////////////////////////////////////////
//
// Sumibi Ajax is a client for Sumibi server.
//
//   Copyright (C) 2005 ktat atusi@pure.ne.jp
//     $Date: 2005/09/10 04:37:23 $
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

var progress  = document.getElementById('progress'); // 進行状況を表示するブロックオブジェクト
var ime       = document.getElementById('ime');      // IMEを表示するブロックオブジェクト
var query     = document.getElementById('q');        // query
var hist      = document.getElementById('hist');     // 
// var resultbox = document.getElementById('r');        // 結果テキストボックス
// var defined   = document.getElementById('defined');  // 決定テキストボックス
var server_type = 'unstable';

var sumibi = new SumibiSOAP(progress, ime, server_type);

sumibi.historyHTML(hist);

function displayResult(){
    sumibi.displayResult();
}

checkKeyInput();

function checkKeyInput(){
    if(query && query.value){
	var ret;
	if(ret = sumibi.setQueryFrom(query.value)){
	    sumibi.doConvert(ret);
	}
    }
    setTimeout("checkKeyInput()", 1000);
}

function select_server(server){
    sumibi.server(server);
}

function sumibi_define_candidate(){
    // 決定テキストボックスがある場合
    // defined.value += sumibi.defineCandidate(query.value);
    var h = location.hash;
    h = h.replace(/^#/,'') - 0;
    query.value = sumibi.replaceQueryByResult(query.value);
    sumibi.ime.innerHTML = '';
    location.hash = sumibi.hist.length - 1;
    if(sumibi.hb){
	sumibi.hb.style.display = 'inline';
    }
    // テキストボックスにフォーカスを返しておく
    query.focus();
}

function sumibi_forward(){
    var h = location.hash;
    h = h.replace(/^#/,'') - 0;
    location.hash = sumibi.forward(h);
    sumibi_spacer();
}

function sumibi_backward(){
    var h = location.hash;
    h = h.replace(/^#/,'') - 0;
    location.hash = sumibi.backward(h);
    sumibi_spacer();
}

function sumibi_spacer(){
    //    alert(sumibi.hf.style.display == 'none');
    if(sumibi.hb.style.display == 'none' || sumibi.hf.style.display == 'none'){
	sumibi.hs.style.display = 'inline';
    }else{
	sumibi.hs.style.display = 'none';
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

