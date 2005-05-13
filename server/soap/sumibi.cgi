#!/usr/bin/perl -w

use strict;
use SOAP::Transport::HTTP;

my $VERSION = "0.3.0";

my $server = SOAP::Transport::HTTP::CGI
    -> dispatch_to( 'SumibiAPI' )
    -> handle
    ;

package SumibiAPI;

# サーバーの状態を返す
sub status {
    return( 'result',
	    [
	     { version => $VERSION },
	     { sumi => [ "sumi_current", "sumi_current2" ] }
	    ]
	);
}

# 変換:S式で返す
sub convert_sexp {
    shift;
    my( $input_str );

    return( 'result',
	    "((\"変換\" \"返還\" \"ヘンカン\") (\"エンジン\" \"猿人\" \"円陣\" \"遠人\"))"
	);
}

# 変換:構造体の配列で返す
sub convert {
    shift;
    my( $input_str ) = @_;

    return ( 'result',

	     [
	      {  no => 0, candidate  => 0, type => "j", word => "変換"      },
	      {  no => 0, candidate  => 1, type => "j", word => "返還"      },
	      {  no => 0, candidate  => 2, type => "j", word => "ヘンカン"  },
	      {  no => 0, candidate  => 3, type => "h", word => "へんかん"  },
	      {  no => 0, candidate  => 4, type => "k", word => "ヘンカン"  },
	      {  no => 1, candidate  => 0, type => "j", word => "エンジン"  },
	      {  no => 1, candidate  => 1, type => "j", word => "猿人"      },
	      {  no => 1, candidate  => 2, type => "j", word => "円陣"      },
	      {  no => 1, candidate  => 3, type => "j", word => "遠人"      },
	      {  no => 1, candidate  => 4, type => "h", word => "えんじん"  },
	      {  no => 1, candidate  => 5, type => "k", word => "エンジン"  }
	     ]
	);
}
