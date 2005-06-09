#!/usr/bin/perl -w
#
# "sumibi.cgi" is an SOAP server for sumibi engine.
#
#   Copyright (C) 2005 Kiyoka Nishyama
#     $Date: 2005/06/09 15:35:27 $
#
# This file is part of Sumibi
#
# Sumibi is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
# 
# Sumibi is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with Sumibi; see the file COPYING.
#
#

use utf8;
use strict;
use SOAP::Transport::HTTP;
use MIME::Base64;
use File::Temp;

my $VERSION = "0.3.0";

my $server = SOAP::Transport::HTTP::CGI
    -> dispatch_to( 'SumibiConvert' )
    -> handle
    ;

package SumibiConvert;

# サーバーの状態を返す
sub doGetStatus {
    return( 
	{ version => $VERSION,  sumi => [ "sumi_current", "sumi_current2" ] }
	);
}

# 変換:S式で返す
sub doSumibiConvertSexp {
    shift;
    my( $query, $sumi, $ie, $oe ) = @_;

    open( FP, "|./sumibi -i > /tmp/log" );
    printf( FP "convertsexp %s\n", $query );
    close( FP );

    open( FP, "/tmp/log" );
    my( $line ) = "";
    my( $result ) = "";
    while( read( FP, $line, 1024 )) {
	$result .= $line;
    }
    close( FP );

    return(
	MIME::Base64::encode( $result, '' )
	);
}

# 変換:構造体の配列で返す
sub doSumibiConvert {
    shift;
    my( $input_str ) = @_;

    return ( 
	{  convertTime => 5, 
	   resultElements => 
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
	}
	);
}
