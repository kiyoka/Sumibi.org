#!/usr/bin/perl -w
#
# "sumibi.cgi" is an SOAP server for sumibi engine.
#
#   Copyright (C) 2005 Kiyoka Nishyama
#     $Date: 2005/06/22 14:53:08 $
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

my $server = SOAP::Transport::HTTP::CGI
    -> dispatch_to( 'SumibiConvert' )
    -> handle
    ;

package SumibiConvert;
use Jcode;
use FileHandle;
use IPC::Open2;


# Sumiibエンジンを呼出す
sub _sumibiEngine {
    my( $arg ) = @_;
    my( @result );

    local( *Reader, *Writer );
    my $pid = open2( *Reader, *Writer, './sumibi' );
    Writer->autoflush(); # default here, actually
    print Writer $arg;
    my $ok     = <Reader>; # ok/error

    # 空行が来るまで入力を読みこむ
    while( 1 ) {
	$_ = <Reader>;
	# 改行を落とす
	chomp;
	if ( 0 >= length( $_ )  ) {
	    last;
	}
	else {
	    push( @result, $_ );
	}
    }

    close( Reader );
    close( Writer );
    waitpid($pid, 0);

    return ( $ok, @result );
}


# サーバーの状態を返す
sub doGetStatus {
    shift;
    # sumibiエンジンを呼びだす
    my( $ok, @result ) = _sumibiEngine( "version\n" );

    return( 
	{ version => $result[0],  sumi => [ "sumi_current", "sumi_current2" ] }
	);
}



# 変換:S式で返す
sub doSumibiConvertSexp {
    shift;
    my( $query, $sumi, $ie, $oe ) = @_;

    # sumibiエンジンを呼びだす
    my( $ok, @result ) = _sumibiEngine( sprintf( "convertsexp\t%s\n", $query ));

    return(
	MIME::Base64::encode( 
	    Jcode::convert( $result[0], "euc", "utf8" ),
	    '' )
	);
}

# 変換:構造体の配列で返す
sub doSumibiConvert {
    shift;
    my( $query, $sumi, $ie, $oe ) = @_;

    # sumibiエンジンを呼びだす
    my( $ok, @result ) = _sumibiEngine( sprintf( "convert\t%s\n", $query ));
    my( @ar );

    # レスポンス形式を変換する
    foreach ( @result ) {
	my( @member ) = split;
	push( @ar
	      ,{
		  type      => $member[0],
		  word      => $member[1],
		  no        => $member[2],
		  candidate => $member[3]
	      }
	    );
    }

    return ( 
	{  convertTime => 1.0, 
	   resultElements => [ @ar ]
	}
	);
}
