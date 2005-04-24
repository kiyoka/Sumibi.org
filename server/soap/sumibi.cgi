#!/usr/bin/perl -w

use strict;
use SOAP::Transport::HTTP;

my $server = SOAP::Transport::HTTP::CGI
    -> dispatch_to( 'SumibiAPI' )
    -> handle
    ;

package SumibiAPI;
sub version {
    return "0.3.0";
}

sub status {
    return "not implemented";
}

sub convert {
    return "not implemented";
}
