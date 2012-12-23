use 5.006;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Archive::Rgssad',
    license             => 'perl',
    dist_author         => q{Zejun Wu <watashi@watashi.ws>},
    dist_version_from   => 'lib/Archive/Rgssad.pm',
    script_files        => qw{script/rgssad.pl},
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'perl' => 5.006,
    },
    add_to_cleanup      => [ 'Archive-Rgssad-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
