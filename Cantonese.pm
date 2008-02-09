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

our $VERSION = '0.1';


# Preloaded methods go here.

sub new() {
  my $self = {};
  $self->{jyutping} = {};
  $self->{words} = {};
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
  }

  # one character
  if (length($str) == 1) {
    return $self->{jyutping}->{$str};
  }

  # multi characters
  else {
    my @jyutping;
    for (my $i = 0; $i < length($str); $i++) {
      push(@jyutping, $self->{jyutping}->{substr($str, $i, 1)});
    }
    return @jyutping;
  }
}

sub get_words {
    my ($self, $char) = @_;

    return @{$self->{words}};
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
  my $symbol = $dict->get_jyutping("广");
  print "广: $symbol\n"; # 广: gwong2
  my @symbols = $dict->get_jyutping("粤拼");
  print "粤拼: ", join(' ', @symbols), "\n"; # 粤拼: jyut6 ping3

=head1 DESCRIPTION

This module is for looking up Jyutping of Cantonese characters or words. It's edited by a programmer not a linguistician. There will be many errors. So don't take it serious. It's a part of the eGuideDog project (http://e-guidedog.sf.net).

=head2 EXPORT

None by default.

=head1 METHODS

=head2 new()

Initialize dictionary.

=head2 get_jyutping($chars)

Return a scalar of jyutping symbols if only one character is requested.

Return an array of jyutping symbols if multi-character is requested.

=head1 SEE ALSO

L<http://e-guidedog.sf.net>

=head1 AUTHOR

Cameron Wong, E<lt>hgn823-perl at yahoo.com.cnE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2008 by Cameron Wong

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
