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

=head1 ̾��

Sumibi -- Sumibi�� Perl�⥸�塼��

=head1 ����

Sumibi �� kiyoka���󤬺����������޻������Ѵ����󥸥�Ǥ���
sourceforge.jp �˥ץ������Ȥ�����ޤ�(http://sourceforge.jp/projects/sumibi/)��
����ϡ�Sumibi��ڤ��ि���Perl�⥸�塼��Ǥ���

=head1 �Ȥ���

 use Sumibi;

 print Sumibi->new->convert("Perl no module wo tukutte mimashita.h .");
 # "Perl��module���äƤߤޤ�����"�Ƚ��Ϥ���ޤ�

�����������Ϥ���ʸ����� Sumibi ���Ѵ����������ϡ�

 perl -MSumibi -e 'Sumibi::shell();'

Sumibi shell ��Ω���夬�ꡢ�����Τ褦�����ϤǤ��ޤ���

 Sumibi> konnnichiha .

=head1 �᥽�å�

=over 4

=item new

 my $sumibi = Sumibi->new(encode => 'euc-jp', history => '.sumibi_history');

���󥹥ȥ饯���������ϲ������̤ꡣ

 encode .... ���Ѥ��륨�󥳡���(�ǥե���Ȥ�euc-jp)
 history ... shell �ξ��˻��Ѥ��������ե�����(�ǥե���Ȥ� $ENV{HOME}/.sumibi_history)
 ca_file ... $ENV{HTTPS_CA_FILE} ������ޤ�
 server .... sumibi �����Ф���ꤷ�ޤ�(�ǥե���Ȥϡ�https://sumibi.org/cgi-bin/sumibi/unstable/sumibi.cgi)

=item shell

 $sumibi->shell;

���饹�᥽�åɡ��ؿ��Ȥ��Ƥ�Ƥ٤ޤ���

 Sumibi->shell;
 Sumibi::shell()

���ξ�硢������Ϳ����� new ��Ϳ���������Ʊ���ˤʤ�ޤ���

=item ca_file

 $sumibi->ca_file
 $sumibi->ca_file($ca_file);

$ENV{HTTPS_CA_FILE} ���ͤ�Ф����줷�ޤ������饹�᥽�åɤȤ��Ƥ���ѤǤ��ޤ���

=item server

 $sumibi->server($url);

�����Ф��ѹ����ޤ���

=item dev_server

 $sumibi->dev_server;

�����Ф�ȯ�ѥ����Фˤ��ޤ���https://sumibi.org/cgi-bin/sumibi/develop/sumibi.cgi

=item encode

 $sumibi->encode;
 $sumibi->encode('sjis');

Sumibi ���֤����󥳡��ɤ���ꤷ�ޤ����ǥե���Ȥ� euc-jp �Ǥ���

=item convert

 $sumibi->convert('konnnichiha .');

ʸ�����������Ѵ����ޤ���

=item can_choose

 $sumibi->can_choose(1);

�Ѵ���������Ǥ��뤫�ɤ�����shell �⡼�ɤǤϡ����꤬�ʤ��¤��1���֤��ޤ���

=item current_error

 $sumibi->current_error;

���ߤΥ��顼���֤��ޤ���

=item dump_error

 $sumibi->dump_error;

���ΤΥ��顼����� Data::Dumper �η������֤��ޤ���

=item error

���ΤΥ��顼�������äƤ��롢$sumibi->{error} ���֤��ޤ���

=item history

�������¸����ե�����̾����ꤷ�ޤ���
�ǥե���Ȥϡ� $ENV{HOME}/.sumibi_history �Ǥ���

=back

=head1 Sumibi shell

ʸ��������Ϥ������Ԥ� Sumibi ���Ѵ���Ԥ��ޤ���shell ����ȴ������ϡ�ctrl + d ��ȴ���뤳�Ȥ��Ǥ��ޤ���

 Sumibi> konnnichiha .

Sumibi ��ʣ�����Ѵ�������֤�����硢�����Τ褦��ɽ������ޤ���

 [Sumibi-candidate]
 => 0:������  1:������  2:����ˤ���
 => 0:��  1:��  2:��  3:��

shell �Υץ��ץȤ������Τ褦���Ѥ��ޤ���

 sumibi-candidate>

���ξ��֤ǡ����򤹤�����򥹥ڡ������ڤ�����Ϥ��ޤ���
���� 0 ���ɤ����ϲ��Ԥ������Ǥ��ޤ������Ϥ�����ϡ������Τ褦�ˤʤ�ޤ���

 Sumibi-candidate> 2 0

������Ѵ����줿��Τ��Ǥޤ������Τ�ή��ϲ����Τ褦�ˤʤ�ޤ���

 Sumibi> konnnichiha .
 [Sumibi candidate]
 => 0:������  1:������  2:����ˤ���
 => 0:��  1:��  2:��  3:��
 Sumibi-candidate> 2 0
 ����ˤ��ϡ�
 sumibi>

=head1 �Х�

�����ƥ��Ȥ��Ƥޤ��󡣤��äȤɤ����Х��äƤ��뤳�ȤǤ��礦���ä˥��顼�ط��ϻȤäƤʤ��Τǡ�

=head1 �ռ�

���򤤥��޻������Ѵ����󥸥���äƤ������ä� kiyoka����˴��ա�
http://www.netfort.gr.jp/~kiyoka/
http://sourceforge.jp/projects/sumibi/

=head1 ����

 Ktat <atusi@pure.ne.jp>

=head1 ���

 Copyright 2005 by Ktat <atusi@pure.ne.jp>.

 This program is free software; you can redistribute it
 and/or modify it under the same terms as Perl itself.

 See http://www.perl.com/perl/misc/Artistic.html

=cut

1;
