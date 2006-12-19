#!/usr/bin/perl
#
# "SumibiWebApiSample.pl" is a sample program.
#
#   Copyright (C) 2005 Kiyoka Nishiyama
#     $Date: 2006/12/19 13:14:40 $
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
#


use SOAP::Lite;
use Data::Dumper;

if( 1 > scalar(@ARGV)) {
    print "usage : SumibiWebApiSample.pl string";
    exit( 0 );
}

# make parameters
my $query   = join( ' ', @ARGV );
my $sumi    = "sumi_current";
my $history = "";
my $dummy   = "";

my $sumibi = SOAP::Lite -> service("http://sumibi.org/sumibi/Sumibi_testing.wsdl");

#
# getStatus();
#
my $som = $sumibi -> getStatus( );
print "version : ", $som->{version}, "\n";


#
# doSumibiConvertSexp()
#
my $som = $sumibi -> doSumibiConvertSexp( $query, $sumi, $history, $dummy );
print "sexp    : ", $som, "\n";


#
# doSumibiConvert()
#
my $som = $sumibi -> doSumibiConvert( $query, $sumi, $history, $dummy );

print "time    : ", $som->{convertTime}, "\n";
my $ar = $som->{resultElements};
print "dump    : ", Dumper($ar);


#
# doSumibiConvertHira()
#
my $som = $sumibi -> doSumibiConvertHira( $query, $sumi, $history, $dummy );
print "hiragana: ", $som, "\n";


exit 0;
