/////////////////////////////////////////////////////////////////////////////////////////////
//
// Sumibi Ajax is a client for Sumibi server.
//
//   Copyright (C) 2006 Kiyoka Nishiyama
//     $Date: 2006/12/23 04:52:15 $
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

// CHANGELOG
//  - Ajaxクライアント
//    1. 変換確定ボタンの文字列をカスタマイズ可能にした
//       サンプルでは"確定(Ctrl+J)"という文字列にしている
//    2. テキスト入力エリアでのキー入力をフック関数で横取り出来るようにした。
//       サンプルではCtrl+Jで確定処理にしている
//    3. Undoボタンの文字列をカスタマイズ可能にした
//       サンプルでは"戻る(Ctrl+Z)"という文字列にしている
//    4. Undoのキー入力をフック関数で横取り出来るようにした。
//       サンプルではCtrl+ZでUndo処理にしている

function Sumibi_onload_hook() {document.getElementById('qbox').focus();}

function getEvent (event)
{
    return (event) ? event : ((window.event) ? event : null);
}

function getKeyCode(event)
{
    var e = getEvent(event);
    return ((e.which) ? e.which : e.keyCode);
}

function resetEvent(event)
{
    event.returnValue = false;
}


function judge_key(event, check_key)
{
    var e = getEvent(event);
    var k = getKeyCode(event);

    // Ctrl + 以下のキー
    // -----------0x0X--------------
    // a b c d e f g h i j k l m n o 
    // 1 2 3 4 5 6 7 8 9 A B C D E F 
    // -----------0x1X--------------
    // p q r s t u v w x y z
    // 0 1 2 3 4 5 6 7 8 9 A

    switch( check_key ) {
    case 'G':
	if (( k == 0x7 ) ||
	    ((k == 0x47  || k == 0x67 ) && e.ctrlKey)) {
	    return true;
	}
	break;

    case 'Z':
	if (( k == 0x1A ) ||
	    ((k == 0x5A || k == 0x7A ) && e.ctrlKey)) {
	    return true;
	}
	break;

    case 'C':
	if (( k == 0x3 ) ||
	    ((k == 0x43 || k == 0x63 ) && e.ctrlKey)) {
	    return true;
	}
	break;

    case 'J':
	if (( k == 0xA ) ||
	    ((k == 0x4A || k == 0x6A ) && e.ctrlKey)) {
	    return true;
	}
	break;
    }
    return false;
}


function Sumibi_key_process_common(qbox_id, event, cur_no)
{
    // Ctrl+G
    if ( judge_key( event, 'G' )) {
	Submit_kakutei_and_google_search( );

	resetEvent( event );
	return false;
    }

    // Ctrl+Z
    if ( judge_key( event, 'Z' )) {
	sumibi_backward( qbox_id );

	resetEvent( event );
	return false;
    }
    return true;
}

function Sumibi_key_process_in_select(qbox_id, event, cur_no)
{
    var sumibi = document.getElementById(qbox_id).sumibi;
    var e = getEvent(event);
    var k = getKeyCode(event);
    // 変換中は確定を実行しない
    if ( sumibi.progress.style.display == 'block' ) {
	return true;
    }

    // カーソルコントロール系のキーコード
    var space_key=32;      //Spaceキー
    var return_key=13;     //Returnキー

    var cand = document.getElementById('sumibi_candidate' + qbox_id + cur_no);
    // Ctrl+Cまたは、Ctrl+Jで次のselectボックスに移動
    if ( judge_key( event, 'C' ) || judge_key( event, 'J' )) {
	sdebug('sumibi_candidate' + qbox_id + (cur_no + 1));
	cand     = document.getElementById('sumibi_candidate' + qbox_id + (cur_no + 1));
	if ( null == cand ) {
	    // queryボックスにフォーカスを戻す
	    var query     = document.getElementById(qbox_id);
	    resetEvent( event );
	    query.focus();
	}
	else {
	    resetEvent( event );
	    cand.focus();
	}
	return false;
    }
    
    if ( k == space_key ) {
	if(cand.selectedIndex >= cand.length - 1){ // WHY ???
		cand.selectedIndex = 0;
	}else{
		cand.selectedIndex++;
	}

	resetEvent( event );
	return false;
    }

    if ( k == return_key ) {
	sumibi_define_candidate( qbox_id );

	resetEvent( event );
	return false;
    }

    // 共通処理
    Sumibi_key_process_common(qbox_id, event, cur_no);
    return true;
}

function Sumibi_key_process_in_text(qbox_id, event)
{
    var sumibi = document.getElementById(qbox_id).sumibi;
    var e = getEvent(event);
    var k = getKeyCode(event);

    // 変換中は確定を実行しない
    if ( sumibi.progress.style.display == 'block' ) {
	return true;
    }


    // Ctrl+Cまたは、Ctrl+J
    if ( judge_key( event, 'C' ) || judge_key( event, 'J' )) {
	var kakutei     = document.getElementById('sumibi_candidate' + qbox_id + 0); // kakutei button
//	resetEvent( event ); 
	kakutei.focus();
	return true;
    }

    // 共通処理
    Sumibi_key_process_common(qbox_id, event);
    return true;
}

function Sumibi_get_backward_button_label( )
{
    return "戻る (Ctrl+Z)";
}

function Sumibi_get_forward_button_label( )
{
    return "進む";
}

function Sumibi_close_history_button_label( )
{
    return "閉";
}

function Sumibi_get_kakutei_button_label( )
{
    return "確定";
}

function Sumibi_get_kouho_desc_label( )
{
    return '(Ctrl+CまたはCtrl+J)で次ボックスへ / SPACEで次候補へ<br>';
}

function Submit_kakutei_and_google_search() {sumibi_define_candidate('qbox');document.getElementById('gform').submit();}
function Sumibi_candidate_html_hook(sumibi, space_array,words_array) {
    var ret = '';
    var str = '';
    var search_str = '';
    var i;
    for(i=0; i < words_array.length; i++){
	str += space_array[i] + words_array[i];
    }

    if( google_mode() ) {
    	ret = '<br>'
	    + '<div style="text-align:center;">' 
	    + '<input type="button" id="search" name="search" value="『' + str + '』でGoogle検索 (Ctrl+G)"'
	    + ' onClick="Submit_kakutei_and_google_search();">'
	    + '</div>';
    }

    return ret;
}

function isKatakanaStr(str){
   var i;
   for(i=0; i<str.length; i++){
     if('ー' != str.charAt(i) ) {
       if(str.charAt(i) < 'ア' || str.charAt(i) > 'ン' ) {
         return false;
       }
     }
   }
   return true;
}

function includeHiragana(str){
   var i;
   for(i=0; i<str.length; i++){
     if('ー' == str.charAt(i) ) {
     }
     else if(('あ' <= str.charAt(i)) && (str.charAt(i) <= 'ん' )) {
         return true;
     }
   }
   return false;
}

