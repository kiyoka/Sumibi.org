package Sumibi;

our $VERSION = '0.08';

use strict;

use Term::ReadLine ();
use LWP::UserAgent ();
use Data::Dumper ();

use constant SUMIBI => 'https://sumibi.org/cgi-bin/sumibi/unstable/sumibi.cgi';
use constant SUMIBIDEV => 'https://sumibi.org/cgi-bin/sumibi/develop/sumibi.cgi';

sub new{
  my $class = shift;
  my $ua = LWP::UserAgent->new();
  my %hash = @_;
  my $self =
    {
     ua      => $ua,
     count   => 0,
     encode  => 'euc-jp',
     history => $ENV{HOME} . '/.sumibi_history',
     ca_file => undef,
     server  => SUMIBI,
     can_choose => undef,
    };
  foreach my $key (qw/encode history ca_file server/){
    $self->{$key} = $hash{$key} if exists $hash{$key};
  }
  return bless $self => $class;
}

sub ca_file{
  my $self = shift;
  $ENV{HTTPS_CA_FILE} = shift if @_;
}

sub ua{
  my $self = shift;
  return $self->{ua};
}

sub server{
  my $self = shift;
  return $self->{server};
}

sub dev_server{
  my $self = shift;
  return $self->{server} = SUMIBIDEV;
}

sub encode{
  my $self = shift;
  $self->{encode} = shift if @_;
  return $self->{encode};
}

sub convert{
  my $self = shift;
  $self->count_plus();
  my $str = shift;
  my $r = $self->ua->post($self->server, {string => $str, encode => $self->encode});
  if($r->is_success){
    return $self->parse($r->content);
  }else{
    $self->current_error({status => $r->status_line, content => $r->content});
  }
}

sub _parse{
  my($self, $result, $ret, $choosen, $candidate) = @_;
  my $i = 0;
 LOOP: while($_ = shift @$result){
    my @candidate_list = split /\s/, $_;
    foreach my $string (grep s/"//g, @candidate_list){
      if(!$self->can_choose){
        push @$ret, shift @candidate_list;
      }elsif(!$candidate){
        push @$ret, $candidate_list[$choosen->[$i]];
        $i++;
      }else{
        push @$candidate, \@candidate_list;
      }
      next LOOP;
    }
  }
}

sub parse{
  my $self = shift;
  my $contents = shift;
  $contents =~s/\((.+)\)/$1/;
  my @result = $contents =~/\((.+?)\)/g;
  $self->result(@result);
  my @ret;
  my $candidate = [];
  $self->_parse(\@result, \@ret, undef, $candidate);
  if(@$candidate){
    $self->candidate($candidate);
    return '';
  }else{
    return join "", @ret;
  }
}

sub can_choose{
  my $self = shift;
  $self->{can_choose} = shift  if @_;
  return defined $self->{can_choose} ? $self->{can_choose} : $self->shell_mode;
}

sub get_string{
  my $self = shift;
  my $choosen = shift;
  my @ret;
  $self->_parse($self->result, \@ret, $choosen);
  return join "", @ret;
}

sub clear_candidate{
  my $self = shift;
  $self->{result} = $self->{candidate} = undef;
}

sub result{
  my $self = shift;
  $self->{result} = [ @_ ] if @_;
  return $self->{result};
}

sub candidate{
  my $self = shift;
  $self->{candidate} = shift if @_;
  return $self->{candidate};
}

sub count{
  my $self = shift;
  $self->{count};
}

sub count_plus{
  my $self = shift;
  $self->{count}++;
}

sub current_error{
  my $self = shift;
  my $count = $self->count;
  $self->{error}->{$count} = shift if @_;
  return $self->{error}->{$count};
}

sub dump_error{
  my $self = shift;
  print Data::Dumper::Dumper($self->error);
}

sub error{
  my $self = shift;
  $self->{error};
}

sub shell{
  my $self = $_[0];
  $self = shift->new(@_) if (ref $self and ref $self ne __PACKAGE__) or $self eq __PACKAGE__;
  $self = __PACKAGE__->new(@_) unless $self eq __PACKAGE__;
  $self->shell_mode(1);
  my $term = new Term::ReadLine 'sumibi shell';
  $self->{term} = $term;
  my $can_history = $self->history ? 1 : 0;
  $self->history_open() if $can_history;
  my($prompt, $prompt2) = ("Sumibi> ", "Sumibi-candidate> ");
  while(defined (my $str = $term->readline($prompt))){
    next if $str =~/^\s*$/;
    my $res = $self->convert($str);
    print $res, "\n" unless !$res or $self->current_error;
    $term->addhistory($str) if $can_history;
    $self->addhistory($str);
    if(my @candidate = @{$self->candidate || []}){
      print "[Sumibi candidate]\n";
      foreach my $candidate (@candidate){
        print "=> ", join("  ",map{ $_ . ':' . $candidate->[$_]}(0.. $#{$candidate})), "\n";
      }
      while(defined(my $str = $term->readline($prompt2))){
        my @define = $str =~/^\s*$/ ? ('0') x @candidate : $str =~/(\d+)/g;
        if(@define == @candidate){
          print $self->get_string(\@define);
          $self->clear_candidate();
          last;
        }else{
          print "nubmer of your choice is more or lesser. ( you must write ",scalar(@candidate)," nubmer.)\n";
        }
      }
      print "\n";
    }
  }
  print "\n";
  $self->history_close() if $can_history;
}

sub history{
  my $self = shift;
  $self->{history} = shift if @_;
  return $self->{history};
}

sub addhistory{
  my $self = shift;
  my $fh = $self->{histfh};
  print $fh shift, "\n";
}

sub term{
  my $self = shift;
  return $self->{term};
}

sub history_open{
  my $self = shift;
  $self->create_history unless -e $self->history;
  open my $fh, '+<', $self->history;
  seek $fh, 0, 0;
  unless(-z $self->history){
    while(<$fh>){
      chomp;
      next unless $_;
      $self->term->addhistory($_);
    }
  }
  return $self->{histfh} = $fh;
}

sub create_history{
  my $self = shift;
  open OUT, '>', $self->history;
  close OUT;
}

sub history_close{
  my $self = shift;
  close $self->{histfh};
}

sub shell_mode{
  my $self = shift;
  $self->{shell_mode} = shift if @_;
  return $self->{shell_mode};
}

=pod

=head1 名前

Sumibi -- Sumibi用 Perlモジュール

=head1 概要

Sumibi は kiyokaさんが作成したローマ字漢字変換エンジンです。
sourceforge.jp にプロジェクトがあります(http://sourceforge.jp/projects/sumibi/)。
これは、Sumibiを楽しむためのPerlモジュールです。

=head1 使い方

 use Sumibi;

 print Sumibi->new->convert("Perl no module wo tukutte mimashita.h .");
 # "Perlのmoduleを作ってみました。"と出力されます

シェル上で入力した文字列を Sumibi で変換したい場合は、

 perl -MSumibi -e 'Sumibi::shell();'

Sumibi shell が立ち上がり、下記のように入力できます。

 Sumibi> konnnichiha .

=head1 メソッド

=over 4

=item new

 my $sumibi = Sumibi->new(encode => 'euc-jp', history => '.sumibi_history');

コンストラクタ。引数は下記の通り。

 encode .... 使用するエンコード(デフォルトはeuc-jp)
 history ... shell の場合に使用される履歴ファイル(デフォルトは $ENV{HOME}/.sumibi_history)
 ca_file ... $ENV{HTTPS_CA_FILE} に入ります
 server .... sumibi サーバを指定します(デフォルトは、https://sumibi.org/cgi-bin/sumibi/unstable/sumibi.cgi)

=item shell

 $sumibi->shell;

クラスメソッド、関数としても呼べます。

 Sumibi->shell;
 Sumibi::shell()

この場合、引数を与えると new に与える引数と同じになります。

=item ca_file

 $sumibi->ca_file
 $sumibi->ca_file($ca_file);

$ENV{HTTPS_CA_FILE} に値を出し入れします。クラスメソッドとしても使用できます。

=item server

 $sumibi->server($url);

サーバを変更します。

=item dev_server

 $sumibi->dev_server;

サーバを開発用サーバにします。https://sumibi.org/cgi-bin/sumibi/develop/sumibi.cgi

=item encode

 $sumibi->encode;
 $sumibi->encode('sjis');

Sumibi が返すエンコードを指定します。デフォルトは euc-jp です。

=item convert

 $sumibi->convert('konnnichiha .');

文字列を漢字に変換します。

=item can_choose

 $sumibi->can_choose(1);

変換候補選択できるかどうか。shell モードでは、指定がない限りは1を返します。

=item current_error

 $sumibi->current_error;

現在のエラーを返します。

=item dump_error

 $sumibi->dump_error;

全体のエラー情報を Data::Dumper の形式で返します。

=item error

全体のエラー情報が入っている、$sumibi->{error} を返します。

=item history

履歴を保存するファイル名を指定します。
デフォルトは、 $ENV{HOME}/.sumibi_history です。

=back

=head1 Sumibi shell

文字列を入力し、改行で Sumibi で変換を行います。shell から抜ける場合は、ctrl + d で抜けることができます。

 Sumibi> konnnichiha .

Sumibi が複数の変換候補を返した場合、下記のように表示されます。

 [Sumibi-candidate]
 => 0:今日は  1:今日は  2:こんにちは
 => 0:。  1:・  2:．  3:…

shell のプロンプトが下記のように変わります。

 sumibi-candidate>

この状態で、選択する数字をスペース区切りで入力します。
全て 0 で良い場合は改行だけを打ちます。入力する場合は、下記のようになります。

 Sumibi-candidate> 2 0

これで変換されたものがでます。全体の流れは下記のようになります。

 Sumibi> konnnichiha .
 [Sumibi candidate]
 => 0:今日は  1:今日は  2:こんにちは
 => 0:。  1:・  2:．  3:…
 Sumibi-candidate> 2 0
 こんにちは。
 sumibi>

=head1 バグ

全然テストしてません。きっとどこかバグっていることでしょう。特にエラー関係は使ってないので。

=head1 謝辞

面白いローマ字漢字変換エンジンを作ってくださった kiyokaさんに感謝。
http://www.netfort.gr.jp/~kiyoka/
http://sourceforge.jp/projects/sumibi/

=head1 著者

 Ktat <atusi@pure.ne.jp>

=head1 著作権

 Copyright 2005 by Ktat <atusi@pure.ne.jp>.

 This program is free software; you can redistribute it
 and/or modify it under the same terms as Perl itself.

 See http://www.perl.com/perl/misc/Artistic.html

=cut

1;
