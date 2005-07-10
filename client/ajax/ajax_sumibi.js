/////////////////////////////////////////////////////////////////////////////////////////////
//
// Sumibi Ajax is a client for Sumibi server.
//
//   Copyright (C) 2005 ktat atusi@pure.ne.jp
//     $Date: 2005/07/10 03:50:26 $
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
var defined   = document.getElementById('defined');  // 決定ボックス
var resultbox = document.getElementById('r');
var server_type = 'unstable';
var i;

var sumibi = new SumibiSOAP(progress, ime, server_type);

function displayResult(){
    sumibi.displayResult();
}

checkKeyInput();
checkResultBox();

function checkKeyInput(){
    if(query && query.value){
	var q = query.value;
	var ret;
	if(ret = sumibi.setQueryFrom(q)){
	    sumibi.doConvert(ret);
	}
    }
    setTimeout("checkKeyInput()", 1000);
}

function checkResultBox(){
    sumibi.displayResult();
    setTimeout("checkResultBox()", 100);
}

function sumibi_define_candidate(){
    // defined.value += sumibi.defineCandidate();
    query.value = sumibi.replaceQueryByResult(query.value);
    sumibi.ime.innerHTML = '';
}

function select_server(server){
    sumibi.server(server);
}
