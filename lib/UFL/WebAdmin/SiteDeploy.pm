package UFL::WebAdmin::SiteDeploy;

use strict;
use warnings;

our $VERSION = '0.01';

=head1 NAME

UFL::WebAdmin::SiteDeploy - Automatic Web site deployment

=cut

=head1 SYNOPSIS

    svn checkout https://svn.webadmin.ufl.edu/websites/www.ufl.edu/trunk/ www.ufl.edu
    emacs index.html
    svn commit -m "Some cool change"

=head1 DESCRIPTION

This is a set of scripts designed to ease deployment of static Web
sites managed by Web Administration at the University of Florida.

Based on a small amount of configuration, content is deployed via
C<rsync(1)> to one or more sites. For example, when a change is
committed to the C<www.ufl.edu> repository, that change is
automatically sent to L<http://test.www.ufl.edu/>.

This saves each committer time and effort in figuring out what files
need to be uploaded.

=head1 AUTHOR

Daniel Westermann-Clark E<lt>dwc@ufl.eduE<gt>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
