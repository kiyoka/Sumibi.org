#!/usr/bin/perl -w

use strict;
use SOAP::Transport::HTTP;

my $VERSION = "0.3.0";

my $server = SOAP::Transport::HTTP::CGI
    -> dispatch_to( 'SumibiAPI' )
    -> handle
    ;

package SumibiAPI;

# �����С��ξ��֤��֤�
sub status {
    return( 'result',
	    [
	     { version => $VERSION },
	     { sumi => [ "sumi_current", "sumi_current2" ] }
	    ]
	);
}

# �Ѵ�:S�����֤�
sub convert_sexp {
    shift;
    my( $input_str );

    return( 'result',
	    "((\"�Ѵ�\" \"�ִ�\" \"�إ󥫥�\") (\"���󥸥�\" \"���\" \"�߿�\" \"���\"))"
	);
}

# �Ѵ�:��¤�Τ�������֤�
sub convert {
    shift;
    my( $input_str ) = @_;

    return ( 'result',

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
