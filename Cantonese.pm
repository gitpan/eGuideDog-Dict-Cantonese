package eGuideDog::Dict::Cantonese;

use 5.008;
use strict;
use warnings;
use utf8;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use eGuideDog::Dict::Cantonese ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.2';


# Preloaded methods go here.

sub new() {
  my $self = {};
  $self->{jyutping} = {};
  $self->{words} = {};
  $self->{word_index} = {};
  bless $self, __PACKAGE__;

  # load zhy_list
  my $dir = __FILE__;
  $dir =~ s/[.]pm$//;
  $self->import_zhy_list("$dir/zhy_list");

  # load words

  return $self;
}

sub import_zhy_list {
  my ($self, $zhy_list) = @_;

  open(ZHY_LIST, '<:utf8', $zhy_list);
  while (my $line = <ZHY_LIST>) {
    if ($line =~ /^(.)\s([^\s]*)\s$/) {
      if ($1 && $2) {
	$self->{jyutping}->{$1} = $2;
      }
    } elsif ($line =~ /^[(]([^)]*)[)]\s([^\s]*)\s$/) {
      my @chars = split(/ /, $1);
      my @symbols = split(/[|]/, $2);
      my $word = join("", @chars);
      if ($self->{word_index}->{$chars[0]}) {
	push(@{$self->{word_index}->{$chars[0]}}, $word);
      } else {
	$self->{word_index}->{$chars[0]} = [$word];
      }
      $self->{words}->{$word} = \@symbols;
    }
  }
  close(ZHY_LIST);
}

sub get_jyutping {
  my ($self, $str) = @_;

  if (not utf8::is_utf8($str)) {
    if (not utf8::decode($str)) {
      warn "$str is not in utf8 encoding.";
      return undef;
    }
  } elsif (not $str) {
    return undef;
  }

  if (wantarray) {
    my @jyutping;
    for (my $i = 0; $i < length($str); $i++) {
      my $char = substr($str, $i, 1);
      my @words = $self->get_words($char);
      my $longest_word = '';
      foreach my $word (@words) {
	if (index($str, $word) == 0) {
	  if (length($word) > length($longest_word)) {
	    $longest_word = $word;
	  }
	}
      }
      if ($longest_word) {
	push(@jyutping, $self->{words}->{$longest_word});
	$i += $#{$self->{words}->{$longest_word}};
      } else {
	push(@jyutping, $self->{jyutping}->{$char});
      }
    }
    return @jyutping;
  } else {
    my $char = substr($str, 0, 1);
    my @words = $self->get_words($char);
    my $longest_word = '';
    foreach my $word (@words) {
      if (index($str, $word) == 0) {
	if (length($word) > length($longest_word)) {
	  $longest_word = $word;
	}
      }
    }
    if ($longest_word) {
      return $self->{words}->{$longest_word}->[0];
    } else {
      return $self->{jyutping}->{$char};
    }
  }
}

sub get_words {
  my ($self, $char) = @_;

  if ($self->{word_index}->{$char}) {
    return @{$self->{word_index}->{$char}};
  } else {
    return ();
  }
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

eGuideDog::Dict::Cantonese - an informal Jyutping dictionary.

=head1 SYNOPSIS

  use utf8;
  use eGuideDog::Dict::Cantonese;

  binmode(stdout, 'utf8');
  my $dict = eGuideDog::Dict::Cantonese::new();
  my $symbol = $dict->get_jyutping("长");
  print "长: $symbol\n"; # 长: coeng4
  $symbol = $dict->get_jyutping("长辈");
  print "长辈的长: $symbol\n"; # zoeng2
  my @symbols = $dict->get_jyutping("粤拼");
  print "粤拼: @symbols\n"; # 粤拼: jyut6 ping3
  my @words = $dict->get_words("长");
  print "Some words begin with 长: @words\n";

=head1 DESCRIPTION

This module is for looking up Jyutping of Cantonese characters or words. It's edited by a programmer not a linguistician. There will be many errors. So don't take it serious. It's a part of the eGuideDog project (http://e-guidedog.sf.net).

=head2 EXPORT

None by default.

=head1 METHODS

=head2 new()

Initialize dictionary.

=head2 get_jyutping($str)

Return a scalar of jyutping symbol of the first character if it is in a scalar context.

Return an array of jyutping symbols of all characters in $str if it is in an array context.

=head2 get_words($char)

Return an array of words which are begined with $char. This list of word contains multi-symbol characters and the symbol used in the word is less frequent.

=head1 SEE ALSO

L<http://e-guidedog.sf.net>

=head1 AUTHOR

Cameron Wong, E<lt>hgn823-perl at yahoo.com.cnE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2008 by Cameron Wong

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
