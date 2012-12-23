package Archive::Rgssad::Keygen;

use Exporter 'import';
our @EXPORT_OK = qw(keygen);

use 5.006;
use strict;
use warnings FATAL => 'all';

=head1 NAME

Archive::Rgssad::Keygen - Internal utilities to generate magickeys.

=head1 VERSION

Version 0.1

=cut

our $VERSION = '0.1';

=head1 SYNOPSIS

    use Archive::Rgssad::Keygen qw(keygen);

    my $seed = 0xDEADCAFE;
    my $key = keygen($seed);        # get next key
    my @keys = keygen($seed, 10);   # get next 10 keys


=head1 DESCRIPTION

=over 4

=item keygen KEY

=item keygen KEY, NUM

Uses KEY as seed, generates NUM keys, and stores the new seed back to KEY.
If NUM is omitted, it generates 1 key, which is exactly KEY.
In scalar context, returns the last keys generated.

=cut

sub keygen (\$;$) {
  use integer;
  my $key = shift;
  my $num = shift || 1;
  my @ret = ();
  for (1 .. $num) {
    push @ret, $$key;
    $$key = ($$key * 7 + 3) & 0xFFFFFFFF;
  }
  return wantarray ? @ret : $ret[-1];
}

=back

=head1 AUTHOR

Zejun Wu, C<< <watashi at watashi.ws> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-archive-rgssad at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Archive-Rgssad>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Archive::Rgssad::Keygen


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

1; # End of Archive::Rgssad::Keygen
