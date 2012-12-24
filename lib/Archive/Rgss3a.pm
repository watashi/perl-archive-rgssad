package Archive::Rgss3a;

use 5.006;
use strict;
use warnings FATAL => 'all';

use Archive::Rgssad;
use Archive::Rgssad::Entry;
use Archive::Rgssad::Keygen 'keygen';

our @ISA = qw(Archive::Rgssad);

=head1 NAME

Archive::Rgss3a - Provide an interface to rgss3a archive files.

=head1 VERSION

Version 0.1

=cut

our $VERSION = '0.1';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Archive::Rgss3a;

    my $foo = Archive::Rgss3a->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 new

=cut

sub new {
  my $class = shift;
  my $self = {
    magic   => "RGSSAD\x00\x03",
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

  $fh->read($_, 8);
  $fh->read($_, 4);
  my $key = unpack('V');
  {
    use integer;
    $key = ($key * 9 + 3) & 0xFFFFFFFF;
  }

  my @headers = ();
  while (1) {
    $fh->read($_, 16);
    my @header = map { $_ ^ $key } unpack('V*');
    last if $header[0] == 0;

    $fh->read($_, $header[3]);
    $_ ^= pack('V', $key) x (($header[3] + 3) / 4);
    push @header, substr($_, 0, $header[3]);
    push @headers, \@header;
  }

  my @entries = ();
  for my $header (@headers) {
    my ($off, $len, $key) = @$header;
    my $path = $header->[-1];
    my $data = '';
    $fh->seek($off, 0);
    $fh->read($data, $len);
    $data ^= pack('V*', keygen($key, ($len + 3) / 4));
    push @entries, Archive::Rgssad::Entry->new($path, substr($data, 0, $len));
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

  $fh->close;
}

=head1 AUTHOR

Zejun Wu, C<< <watashi at watashi.ws> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-archive-rgssad at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Archive-Rgssad>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Archive::Rgss3a


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

1; # End of Archive::Rgss3a

return 1 if caller;

my $rgss3a = Archive::Rgss3a->new('../_build/Game.rgss3a');
for my $entry ($rgss3a->entries) {
  printf "%s\t\t%d\n", $entry->path, length $entry->data;
  open FH, '>', '/tmp/tmp/' . $entry->path;
  binmode FH;
  print FH $entry->data;
  close FH;
}
