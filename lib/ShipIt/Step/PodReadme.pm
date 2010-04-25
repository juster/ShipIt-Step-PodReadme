package ShipIt::Step::PodReadme;

use warnings;
use strict;

use File::Spec  qw();
use Pod::Readme qw();
use Carp        qw();

our $VERSION = '0.01';

sub new
{
    my $class = shift;
    bless {}, $class;
}

sub run
{
    my ($state) = @_;

    my $pod_path = _find_pod_file();
}

#---HELPER FUNCTION---
# Finds the main POD file in order to run Pod::Readme on it.
sub _find_pod_file
{
    my $modname   = _find_modname();
    my $base_path = $modname;
    $base_path    =~ tr{:}{/}s;

    my ($pod_path) = ( grep { -e $_ }
                       map { $base_path . $_ }
                       qw/ .pod .pm / );

    Carp::confess "Could not find the main module files for $modname"
        unless $pod_path;

    return $pod_path;
}

#---HELPER FUNCTION---
sub _find_modname
{
    foreach ( qw/ Build.PL Makefile.PL / ) {
        _find_modname_in_file( $_ ) if -f $_;
    }

    Carp::confess 'Could not find Makefile.PL or Build.PL';
}

my %REGEXS_FOR =
    ( 'Makefile.PL' =>
      [ qr{ NAME .+ (['"]) (.+?) \1 }xms, # ExtUtils::MakeMaker
        qr{ \b name                       # Module::Install
            (?: \s* [(] | \s+ )
            (['"]) (.+?) \1 }xms ],
      'Build.PL'    => 
      [ qr{ \b name \b .+                 # Module::Build
            (['"]) (.+?) \1 }xms ] );

#---HELPER FUNCTION---
# Partly copied from ShipIt::ProjectType::Perl
# ... then, made super badass
sub _find_modname_in_file
{
    my ($path) = @_;

    open my $distfile, '<', $path,
        or die qq{Can't open $path: $!};

    my ($file) = reverse File::Spec->splitpath( $path );
    my $modname;
    my @regexs = @{ $REGEXS_FOR{ $file } };
    while ( my $line = <$distfile> ) {
        for my $regex ( @regexs ) {
            return $2 if $line =~ $regex;
        }
    }

    close $distfile;
    Carp::confess "Could not find the module name in $path";
}

1; # End of ShipIt::Step::PodReadme

__END__

=head1 NAME

ShipIt::Step::PodReadme - The great new ShipIt::Step::PodReadme!

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use ShipIt::Step::PodReadme;

    my $foo = ShipIt::Step::PodReadme->new();
    ...

=head1 AUTHOR

Justin Davis, C<< <juster at cpan dot org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-shipit-step-podreadme at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=ShipIt-Step-PodReadme>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc ShipIt::Step::PodReadme


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=ShipIt-Step-PodReadme>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/ShipIt-Step-PodReadme>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/ShipIt-Step-PodReadme>

=item * Search CPAN

L<http://search.cpan.org/dist/ShipIt-Step-PodReadme/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2010 Justin Davis.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut
