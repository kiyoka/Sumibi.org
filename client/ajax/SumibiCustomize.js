/////////////////////////////////////////////////////////////////////////////////////////////
//
// Sumibi Ajax is a client for Sumibi server.
//
//   Copyright (C) 2005 Kiyoka Nishiyama
//     $Date: 2005/11/26 16:42:44 $
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
// 候補表示部分へのフック関数
//
// Sumibi_candidate_html_hook(space_array,words_array);
//   ※ この関数は自由にカスタマイズしてください。
//      変換候補選択のフォームの下に自分の好きな機能を追加できます。
//      現状は第一候補しか受け取れませんが、ちょっとした機能を追加するには十分でしょう。
//
// space_array ........ 第一候補文字列の配列(スペース部分)
// words_array ........ 第一候補文字列の配列(候補文字列)
//
// 戻り値      ........ 挿入したいHTML
//********************************************************************
function Sumibi_candidate_html_hook(space_array,words_array) {
    var ret = '';

    /// 以下は実装サンプルです。
    //    var i;
    //    ret += '<br>'
    //    for(i=0; i < words_array.length; i++){
    //	ret += '第' + i + '文節 : ';
    //	ret += '[' + space_array[i] + words_array[i] + ']';
    //	ret += '<br>';
    //    }

    return ret;
}
