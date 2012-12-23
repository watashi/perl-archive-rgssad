use 5.006;
use strict;
use warnings FATAL => 'all';
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Archive::Rgssad',
    license             => 'Perl_5',
    dist_author         => q{Zejun Wu <watashi@watashi.ws>},
    dist_abstract       =>
      'Provide an interface to RGSS (ruby game scripting system) archive files.',
    dist_version_from   => 'lib/Archive/Rgssad.pm',
    release_status      => 'stable',
    script_files        => qw{script/rgssad.pl},
    configure_requires  => {
        'Module::Build' => 0,
    },
    build_requires      => {
        'Test::More'    => 0,
    },
    requires => {
        'perl' => 5.006,
    },
    add_to_cleanup      => [ 'Archive-Rgssad-*' ],
    create_makefile_pl  => 'traditional',
);

$builder->create_build_script();
