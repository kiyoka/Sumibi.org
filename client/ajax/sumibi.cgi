#!/usr/bin/perl

# use lib qw(/home/ktat);

use strict;
use Sumibi;
use CGI::Carp qw/fatalsToBrowser/;
use XMLRPC::Transport::HTTP;
use Jcode;

my $server = XMLRPC::Transport::HTTP::CGI
  -> dispatch_to('sumibiXMLRPC')
  -> handle;

package sumibiXMLRPC;

sub convert_dev{
  shift;
  my $query = shift;
  my $sumibi = new Sumibi;
  $sumibi->dev_server;
  _convert($query, $sumibi);
}

sub convert{
  shift;
  my $query = shift;
  my $sumibi = new Sumibi;
  _convert($query, $sumibi);
}

sub _convert{
  my $query = shift;
  my $sumibi = shift;
  $sumibi->can_choose(1);
  my %hash;
  my $res;
  if(my $result = $sumibi->convert($query)){
    $hash{has_candidate} = 0;
    $hash{result} = $result;
  }else{
    $hash{has_candidate} = 1;
    $hash{candidate} = $sumibi->candidate;
  }
  $res = sumibi_response(%hash);
  use Data::Dumper;
  $res =~s/\s//g;
  my $line = qq{<?xml version="1.0"?>\n};
  print "Content-Type:text/xml\nContent-Length:" . length($line .$res) . "\n\n";
  print $line .$res;
  exit;
}

sub sumibi_response{
  my %hash = @_;
  my $string;
  my $name;
  if($hash{has_candidate}){
    $name = 'candidate';
    my @candidate;
    foreach my $candidate (@{$hash{candidate}}){
      my $str;
      foreach my $value (@{$candidate}){
        $value = Jcode::jcode($value, "euc")->utf8;
        $str .= "<value><string>$value</string></value>";
      }
      push(@candidate, $str);
    }
    $string .= "<array><data>" . join("\n", map {"<value><array><data>" . $_ . "</data></array></value>"} @candidate) . "</data></array>";
  }else{
    $name = 'result';
    $string = $hash{result};
  }
  return sprintf(<<__XML__, $name, $string);
<methodResponse>
  <params>
    <param>
      <value>
        <struct>
          <member>
             <name>%s</name>
             <value>%s</value>
          </member>
        </struct>
      </value>
    </param>
  </params>
</methodResponse>
__XML__
}
