use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new
    ( module_name         => 'ShipIt::Step::PodReadme',
      license             => 'perl',
      dist_author         => q{Justin Davis <juster at cpan dot org>},
      dist_version_from   => 'lib/ShipIt/Step/PodReadme.pm',
      build_requires      => { 'Test::More'  => 0, },
      requires            => { map { ($_ => 0) } qw/ Pod::Readme / },
      add_to_cleanup      => [ 'ShipIt-Step-PodReadme-*' ],
      create_makefile_pl  => 'traditional',
     );

$builder->create_build_script();
