#!/usr/bin/perl -w
#
# "sumibi.cgi" is an SOAP server for sumibi engine.
#
#   Copyright (C) 2005 Kiyoka Nishyama
#     $Date: 2005/05/17 14:52:14 $
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

use strict;
use SOAP::Transport::HTTP;

my $VERSION = "0.3.0";

my $server = SOAP::Transport::HTTP::CGI
    -> dispatch_to( 'SumibiConvert' )
    -> handle
    ;

package SumibiConvert;

# �����С��ξ��֤��֤�
sub doGetStatus {
    return( 
	{ version => $VERSION,  sumi => [ "sumi_current", "sumi_current2" ] }
	);
}

# �Ѵ�:S�����֤�
sub doSumibiConvertSexp {
    shift;
    my( $input_str );

    return( 
	"(" .
	" (" .
	"  ((  type . \"j\") (  word . \"�Ѵ�\"      )) " .
	"  ((  type . \"j\") (  word . \"�ִ�\"      )) " .
	"  ((  type . \"j\") (  word . \"�إ󥫥�\"  )) " .
	"  ((  type . \"h\") (  word . \"�ؤ󤫤�\"  )) " .
	"  ((  type . \"k\") (  word . \"�إ󥫥�\"  )) " .
	" )" .
	" (" .
	"  ((  type . \"j\") (  word . \"���󥸥�\"  )) " .
	"  ((  type . \"j\") (  word . \"���\"      )) " .
	"  ((  type . \"j\") (  word . \"�߿�\"      )) " .
	"  ((  type . \"j\") (  word . \"���\"      )) " .
	"  ((  type . \"h\") (  word . \"���󤸤�\"  )) " .
	"  ((  type . \"k\") (  word . \"���󥸥�\"  )) " .
	" )" .
	")"
	);
}

# �Ѵ�:��¤�Τ�������֤�
sub doSumibiConvert {
    shift;
    my( $input_str ) = @_;

    return ( 
	[
	 {  no => 0, candidate  => 0, type => "j", word => "�Ѵ�"      },
	 {  no => 0, candidate  => 1, type => "j", word => "�ִ�"      },
	 {  no => 0, candidate  => 2, type => "j", word => "�إ󥫥�"  },
	 {  no => 0, candidate  => 3, type => "h", word => "�ؤ󤫤�"  },
	 {  no => 0, candidate  => 4, type => "k", word => "�إ󥫥�"  },
	 {  no => 1, candidate  => 0, type => "j", word => "���󥸥�"  },
	 {  no => 1, candidate  => 1, type => "j", word => "���"      },
	 {  no => 1, candidate  => 2, type => "j", word => "�߿�"      },
	 {  no => 1, candidate  => 3, type => "j", word => "���"      },
	 {  no => 1, candidate  => 4, type => "h", word => "���󤸤�"  },
	 {  no => 1, candidate  => 5, type => "k", word => "���󥸥�"  }
	]
	);
}
