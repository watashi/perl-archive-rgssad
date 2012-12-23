#!/usr/bin/perl

use strict;
use warnings;
use Archive::Rgssad;
use File::Basename;
use File::Path 'mkpath';
use Getopt::Long;

my $help = 0;
my $list = 0;
my $dest = '.';

my $result = GetOptions(
  'help'   => \$help,
  'list'   => \$list,
  'dest:s' => \$dest);
my $file = shift;

sub usage {
  print STDERR <<USAGE;
Usage: $0 [-h] [-l] [-d exdir] archive [file(s) ...]
Extract files from rgssad or rgss2a archive

  -h, --help    show this usage
  -l, --list    list all entries
  -d, --dest    extract files to the specified directory
USAGE
}

if ($help) {
  usage;
  exit 0;
} elsif (!$result || !defined($file)) {
  usage;
  exit 1;
} elsif (! -e $file) {
  print STDERR "File '$file' doesn't exist.\n";
  exit 1;
} else {
  my $rgssad = Archive::Rgssad->new($file);
  my %files = ();
  $files{$_} = 1 for (@ARGV);
  for my $entry ($rgssad->entries) {
    my $path = $entry->path;
    $path =~ s|\\|/|g;
    $path = "$dest/$path";
    next if @ARGV > 0 && !exists($files{$path});
    print STDOUT $path, "\n";
    if (!$list) {
      mkpath(dirname($path));
      open FH, '>', $path;
      binmode FH;
      print FH $entry->data;
      close FH;
    }
  }
  exit 0;
}
