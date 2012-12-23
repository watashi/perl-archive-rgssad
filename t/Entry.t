use strict;
use warnings;
use Archive::Rgssad::Entry;
use Test::More tests => 7;

my $entry = Archive::Rgssad::Entry->new('path', 'data');

is($entry->path, 'path', 'get path');
$entry->path('Data\Scripts.rxdata');
is($entry->path, 'Data\Scripts.rxdata', 'set path');

is($entry->data, 'data', 'get gata');
$entry->data('Hello, World!');
is($entry->data, 'Hello, World!', 'set data');

my $s = $entry->pack;
is($s, "\x13\0\0\0Data\\Scripts.rxdata\x0d\0\0\0Hello, World!", 'pack');

my $entry2 = Archive::Rgssad::Entry->new;
$entry2->unpack($s);
is($entry2->path, $entry->path, 'unpacked path');
is($entry2->data, $entry->data, 'unpacked data');

1;
