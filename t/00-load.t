#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'ShipIt::Step::PodReadme' ) || print "Bail out!
";
}

diag( "Testing ShipIt::Step::PodReadme $ShipIt::Step::PodReadme::VERSION, Perl $], $^X" );
