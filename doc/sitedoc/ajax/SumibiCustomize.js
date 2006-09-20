function setFocusToQ() {document.getElementById('qbox').focus();}


function getEvent (event)
{
    return (event) ? event : ((window.event) ? event : null);
}

function getKeyCode(event)
{
    var e = getEvent(event);
    return ((e.which) ? e.which : e.keyCode);
}

function Sumibi_key_process(event)
{
    var e = getEvent(event);
    var k = getKeyCode(event);

    if ((k == 0x4A || k == 0x6A ) && e.ctrlKey) {
	sumibi_define_candidate( );
	return false;
    }

    if ((k == 0x47 || k == 0x67 ) && e.ctrlKey) {
	Submit_kakutei_and_google_search( );
	return false;
    }

    return true;
}

function Sumibi_get_kakutei_button_label( )
{
    return "確定 ( Ctrl+J )";
}

function Submit_kakutei_and_google_search() {sumibi_define_candidate();document.getElementById('gform').submit();}
function Sumibi_candidate_html_hook(space_array,words_array) {
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
	    + '<input type="button" id="search" name="search" value="『' + str + '』でGoogle検索 ( Ctrl+G )"'
	    + ' onClick="submitGform();">'
	    + '</div>';
    }

    if( amazon_mode() ) {
	ret += '<br>';
	for(i=0; i < words_array.length; i++){
	    if ( ! includeHiragana( words_array[i] )) {
		ret += generate_amazon( words_array[i] );
		search_str += ' ' + words_array[i];
	    }
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

function generate_amazon(keyword){
   var ret = '';
   ret += '<iframe src=\"http://rcm-jp.amazon.co.jp/e/cm?t=kiye-22&o=9&p=8&l=st1&mode=books-jp&search=' + keyword + '&=1&fc1=&lt1=&lc1=&bg1=&f=ifr\"';
   ret += ' marginwidth=\"0\" marginheight=\"0\" width=\"120\" height=\"240\" border=\"0\" frameborder=\"0\" style=\"border:none;\" scrolling=\"no\"></iframe>';
   return ret;
}
