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

var progress  = document.getElementById('progress'); // 進行状況を表示するブロックオブジェクト
var ime       = document.getElementById('ime');      // IMEを表示するブロックオブジェクト
var query     = document.getElementById('qbox');     // query box
var hist      = document.getElementById('hist');     // 
var guide     = document.getElementById('guide');    // 
// var resultbox = document.getElementById('r');        // 結果テキストボックス
// var defined   = document.getElementById('defined');  // 決定テキストボックス
var server_type = 'unstable';

var sumibi = sumibi_create_object(query, [progress, ime, server_type, guide, hist]);
query.use_sumibi = true;

function select_server(s){
	sumibi.server(s);
}
