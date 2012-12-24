#!/usr/bin/perl

use strict;
use warnings;
use Archive::Rgssad;
use Archive::Rgss3a;
use File::Basename;
use File::Path 'mkpath';
use Getopt::Long;

my $help = 0;
my $list = 0;
my $dest = '.';
my $type = 0;

my $result = GetOptions(
  'help'   => \$help,
  'list'   => \$list,
  'dest:s' => \$dest,
  'type:i' => \$type);
my $file = shift;

sub usage {
  print STDERR <<USAGE;
Usage: $0 [-h] [-l] [-d exdir] archive [file(s) ...]
Extract files from RGSS archive

  -h, --help    show this usage
  -l, --list    list all entries
  -d, --dest    extract files to the specified directory
  -t, --type=0  automatically detect archive type
      --type=1  treat archive as .rgssad or .rgss2a (rgssad v1)
      --type=3  treat archive as .rgss3a (rgssad v3)
USAGE
}

if ($help) {
  usage;
  exit 0;
} elsif (!$result || !defined($file)) {
  usage;
  exit 9;
} elsif (! -e $file) {
  print STDERR "File '$file' doesn't exist.\n";
  exit 1;
} elsif (! -f $file || ! -r $file) {
  print STDERR "Cannot open '$file' to read.\n";
  exit 1;
}

my %files = ();
$files{$_} = 1 for (@ARGV);

my $rgssad = undef;

if ($type == 0) {
  open FH, '<', $file;
  read FH, $_, 8;
  close FH;
  if (substr($_, 0, 7) ne "RGSSAD\0") {
    print STDERR "'$file' is not a valid rgssad archive\n";
    exit 2;
  } else {
    $type = ord substr($_, 7, 1);
  }
}

if ($type == 1) {
  $rgssad = Archive::Rgssad->new($file);
} elsif ($type == 3) {
  $rgssad = Archive::Rgss3a->new($file);
} else {
  print STDERR "Cannot handle rgssad v$type format\n";
  exit 2;
}

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
