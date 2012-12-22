package Archive::Rgssad::Entry;

use 5.006;
use strict;
use warnings;

=head1 NAME

Archive::Rgssad::Entry - The great new Archive::Rgssad::Entry!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Archive::Rgssad::Entry;

    my $foo = Archive::Rgssad::Entry->new();
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
    path => $_[0] // '',
    data => $_[1] // ''
  };
  bless $self, $class;
  return $self;
}

=head2 path

=cut

sub path {
  my $self = shift;
  $self->{path} = shift if @_;
  return $self->{path};
}

=head2 data

=cut

sub data {
  my $self = shift;
  $self->{data} = shift if @_;
  return $self->{data};
}

=head2 pack

=cut

sub pack {
  my $self = shift;
  pack '(V/a)*', $self->path, $self->data;
}

=head2 unpack

=cut

sub unpack {
  my $self = shift;
  my ($path, $data) = unpack '(V/a)*', shift;
  $self->path($path);
  $self->data($data);
  return $self;
}

=head1 AUTHOR

Zejun Wu, C<< <watashi at watashi.ws> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-archive-rgssad at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Archive-Rgssad>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Archive::Rgssad::Entry


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

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Archive::Rgssad::Entry
