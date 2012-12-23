package Archive::Rgssad;

use 5.006;
use strict;
use warnings FATAL => 'all';

use Archive::Rgssad::Entry;

=head1 NAME

Archive::Rgssad - Provide an interface to RGSS (ruby game scripting system) archive files.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Archive::Rgssad;

    my $foo = Archive::Rgssad->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=cut

sub _next (\$;$) {
  use integer;
  my $key = shift;
  my $n = shift || 1;
  my @ret = ();
  for (1 .. $n) {
    push @ret, $$key;
    $$key = ($$key * 7 + 3) & 0xFFFFFFFF;
  }
  return wantarray ? @ret : $ret[-1];
}

=head2 new

=cut

sub new {
  my $class = shift;
  my $self = {
    magic   => "RGSSAD\x00\x01",
    seed    => 0xDEADCAFE,
    entries => []
  };
  bless $self, $class;
  $self->load(shift) if @_;
  return $self;
}

=head2 load

=cut

sub load {
  my $self = shift;
  my $file = shift;
  my $fh = ref($file) eq '' ? IO::File->new($file, 'r') : $file;
  $fh->binmode(1);

  my @entries = ();
  my $key = $self->{seed};

  $fh->read($_, 8);
  until ($fh->eof) {
    my $entry = Archive::Rgssad::Entry->new;
    my ($buf, $len);

    $fh->read($buf, 4);
    $len = unpack('V', $buf) ^ _next($key);

    $fh->read($buf, $len);
    $buf ^= pack('C*', map { $_ & 0xFF } _next($key, $len));
    $entry->path($buf);

    $fh->read($buf, 4);
    $len = unpack('V', $buf) ^ _next($key);

    $fh->read($buf, $len);
    $buf ^= pack('V*', _next($_ = $key, ($len + 3) / 4));
    $entry->data(substr($buf, 0, $len));

    push @entries, $entry;
  }

  $self->{entries} = \@entries;
  $fh->close;
}

=head2 save

=cut

sub save {
  my $self = shift;
  my $file = shift;
  my $fh = ref($file) eq '' ? IO::File->new($file, 'w') : $file;
  $fh->binmode(1);

  my $key = $self->{seed};

  $fh->write($self->{magic}, 8);
  for my $entry ($self->entries) {
    my ($buf, $len);

    $len = length $entry->path;
    $fh->write(pack('V', $len ^ _next($key)), 4);

    $buf = $entry->path ^ pack('C*', map { $_ & 0xFF } _next($key, $len));
    $fh->write($buf, $len);

    $len = length $entry->data;
    $fh->write(pack('V', $len ^ _next($key)), 4);

    $buf = $entry->data ^ pack('V*', _next($_ = $key, ($len + 3) / 4));
    $fh->write($buf, $len);
  }

  $fh->close;
}

=head2 entries

=cut

sub entries {
  my $self = shift;
  return @{$self->{entries}};
}

=head2 get

=cut

sub get {
  my $self = shift;
  my $arg = shift;
  my @ret = grep { $_->path eq $arg } $self->entries;
  return wantarray ? @ret : $ret[0];
}

=head2 add

=cut

sub add {
  my $self = shift;
  while (@_ > 0) {
    $_ = shift;
    if (ref eq 'Archive::Rgssad::Entry') {
      push $self->{entries}, $_;
    } else {
      push $self->{entries}, Archive::Rgssad::Entry->new($_, shift);
    }
  }
}

=head2 remove

=cut

sub remove {
  my $self = shift;
  my $arg = shift;
  if (ref($arg) eq 'Archive::Rgssad::Entry') {
    $self->{entries} = [grep { $_->path ne $arg->path ||
                               $_->data ne $arg->data } $self->entries];
  } else {
    $self->{entries} = [grep { $_->path ne $arg } $self->entries];
  }
}

=head1 AUTHOR

Zejun Wu, C<< <watashi at watashi.ws> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-archive-rgssad at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Archive-Rgssad>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Archive::Rgssad


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Archive-Rgssad>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Archive-Rgssad>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Archive-Rgssad>

=item * Search CPAN

L<http://search.cpan.org/dist/Archive-Rgssad/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2012 Zejun Wu.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.


=cut

1; # End of Archive::Rgssad
