#!/usr/bin/perl

#
# This program is sample client for Sumibi Web API
#

use SOAP::Lite;
use Data::Dumper;


if( 1 > length(@ARGV)) {
    print "usage : SumibiWebApiSample.pl string";
    exit( 0 );
}

my $sumibi = SOAP::Lite -> service("http://sumibi.org/sumibi/Sumibi_testing.wsdl");

#
# doGetStatus();
#
my $in  = 'dummy';
my $som = $sumibi -> doGetStatus( $in );
print $som->{version}, "\n";


#
# doSumibiConvertSexp()
#
my $query = join( ' ', @ARGV );
my $sumi  = "sumi_current";
my $ie    = "utf-8";
my $oe    = "utf-8";

my $som = $sumibi -> doSumibiConvertSexp( $query, $sumi, $ie, $oe );
print " sexp: ", $som, "\n";

#
# doSumibiConvert()
#
my $som = $sumibi -> doSumibiConvert( $query, $sumi, $ie, $oe );

print "time: ", $som->{convertTime}, "\n";

my $ar = $som->{resultElements};
print Dumper($ar);


exit 0;
