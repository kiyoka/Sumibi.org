#!/usr/bin/perl
#
# "SumibiWebApiSample.pl" is a sample program.
#
#   Copyright (C) 2005 Kiyoka Nishyama
#     $Date: 2005/06/24 16:14:47 $
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
my $query = join( ' ', @ARGV );
my $sumi  = "sumi_current";
my $ie    = "utf-8";
my $oe    = "utf-8";


my $sumibi = SOAP::Lite -> service("http://sumibi.org/sumibi/Sumibi_testing.wsdl");

#
# doGetStatus();
#
my $som = $sumibi -> doGetStatus( );
print "version: ", $som->{version}, "\n";


#
# doSumibiConvertSexp()
#
my $som = $sumibi -> doSumibiConvertSexp( $query, $sumi, $ie, $oe );
print "sexp   : ", $som, "\n";


#
# doSumibiConvert()
#
my $som = $sumibi -> doSumibiConvert( $query, $sumi, $ie, $oe );

print "time   : ", $som->{convertTime}, "\n";
my $ar = $som->{resultElements};
print "dump   : ", Dumper($ar);


exit 0;
