package ShipIt::Step::PodReadme;

use warnings;
use strict;

use File::Spec  qw();
use Pod::Readme qw();
use Carp        qw();

use ShipIt::Util qw(bool_prompt);

our $VERSION = '0.01';

sub new
{
    my $class = shift;
    bless {}, $class;
}

sub run
{
    my ($self, $state) = @_;

    my $pod_path = _find_pod_file();
    my $pr_obj   = Pod::Readme->new();

    unless ( $state->dry_run ) {
        $pr_obj->parse_from_file( $pod_path, 'README' );
        return;
    }

    print "*** DRY RUN for PodReadme\n";
    my $tmp_dir  = File::Spec->tmpdir();
    my $tmp_path = File::Spec->catfile( $tmp_dir, 'README' );

    $pr_obj->parse_from_file( $pod_path, $tmp_path );
    print "Wrote new README file to $tmp_path\n";

    return 1;
}

#---HELPER FUNCTION---
# Finds the main POD file in order to run Pod::Readme on it.
sub _find_pod_file
{
    my $modname   = _find_modname();
    my $base_path = $modname;
    $base_path    =~ tr{:}{/}s;
    $base_path    = "lib/$base_path" if -d 'lib';

    my ($pod_path) = ( grep { -e $_ }
                       map { $base_path . $_ }
                       qw/ .pod .pm / );

    die "Could not find the main module files for $modname"
        unless $pod_path;

    return $pod_path;
}

#---HELPER FUNCTION---
sub _find_modname
{
    foreach ( qw/ Build.PL Makefile.PL / ) {
        return _find_modname_in_file( $_ ) if -f $_;
    }

    die 'Could not find Makefile.PL or Build.PL';
}

my %REGEXS_FOR =
    ( 'Makefile.PL' =>
      [ qr{ NAME .+ (['"]) (.+?) \1 }xms, # ExtUtils::MakeMaker
        qr{ \b name                       # Module::Install
            (?: \s* [(] | \s+ )
            (['"]) (.+?) \1 }xms ],
      'Build.PL'    => 
      [ qr{ \b module_name \b .+          # Module::Build
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
    die "Could not find the module name in $path";
}

1; # End of ShipIt::Step::PodReadme

__END__

=head1 NAME

ShipIt::Step::PodReadme - Generate a README from POD when using ShipIt

=head1 SYNOPSIS

Generates your README file from your POD documentation by using
Pod::Readme.  This is an automated step when you use the ShipIt
distribution creation tool.  Just add it to the list of steps in your
C<.shipit> file.

steps = FindVersion, ChangeVersion, B<PodReadme>, DistTest, Commit, Tag, MakeDist, UploadCPAN

=head1 BUGS

Please report any bugs or feature requests to C<bug-shipit-step-podreadme at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=ShipIt-Step-PodReadme>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

You can also report bugs on github if you have a github account
at L<http://github.com/juster/ShipIt-Step-PodReadme/issues>.

=head1 SUPPORT

Email me if you need help or have a bug.

=head1 SEE ALSO

=over 4

=item * ShipIt

L<http://search.cpan.org/dist/ShipIt>

=item * Pod::Readme

L<http://search.cpan.org/dist/Pod-Readme>

=item * Git Repository

L<http://github.com/juster/ShipIt-Step-PodReadme>

=back

=head1 AUTHOR

Justin Davis, C<< <juster at cpan dot org> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2010 Justin Davis.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut
