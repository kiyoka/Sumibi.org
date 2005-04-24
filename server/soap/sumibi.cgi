#!/usr/bin/perl -w

#use strict;
use SOAP::Transport::HTTP;

my $server = SOAP::Transport::HTTP::CGI
    -> dispatch_to( 'SumibiAPI' )
    -> handle
    ;

package SumibiAPI;
sub version {
    return "0.3.0";
}

sub choose {
    my $random = int(rand(9))+1;
    return $random;
}
