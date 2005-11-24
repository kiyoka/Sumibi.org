function setFocusToQ() {document.getElementById('q').focus();}

function submitGform() {sumibi_define_candidate();document.getElementById('gform').submit();}
function Sumibi_candidate_html_hook(space_array,words_array) {
    var ret = '';
    var str = '';
    var i;
    for(i=0; i < words_array.length; i++){
	str += space_array[i] + words_array[i];
    }

    ret = '<br>'
    + '<div style="text-align:center;">' 
    + '<input type="button" id="search" name="search" value="『' + str + '』でGoogle検索"'
    + ' onClick="submitGform();">'
    + '</div>';

    ret += '<br>'
    for(i=0; i < words_array.length; i++){
      if ( ! includeHiragana( words_array[i] )) {
        ret += make_amazon( words_array[i] );
      }
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

function make_amazon(keyword){
   var ret = '';
   ret += '<iframe src="http://rcm-jp.amazon.co.jp/e/cm?t=kiye-22&o=9&p=8&l=st1&mode=books-jp&search=' + keyword + '&=1&fc1=&lt1=&lc1=&bg1=&f=ifr"';
   ret += ' marginwidth="0" marginheight="0" width="120" height="240" border="0" frameborder="0" style="border:none;" scrolling="no"></iframe>';
   return ret;
}


