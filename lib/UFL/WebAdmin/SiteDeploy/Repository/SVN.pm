package UFL::WebAdmin::SiteDeploy::Repository::SVN;

use Moose;
use DateTime;
use SVN::Client;

extends 'UFL::WebAdmin::SiteDeploy::Repository';

has '+client' => (
    isa => 'SVN::Client',
    default => sub { SVN::Client->new },
);

=head1 NAME

UFL::WebAdmin::SiteDeploy::Repository::SVN - An Subversion repository

=head1 SYNOPSIS

    my $repo = UFL::WebAdmin::SiteDeploy::Repository::SVN->new(uri => 'file:///var/svn/repos/websites');
    my $repo = UFL::WebAdmin::SiteDeploy::Repository::SVN->new(uri => 'https://svn.webadmin.ufl.edu/repos/websites/');

=head1 DESCRIPTION

This is an implementation of a repository containing one or more Web
sites, using Subversion as the revision control system.

=head1 METHODS

=head2 entries

Return the contents of the repository as of C<HEAD>.

    my $entries = $repo->entries;
    print $entries->{www.ufl.edu}->created_rev;

=cut

sub entries {
    my ($self) = @_;

    my $entries = $self->client->ls($self->uri, 'HEAD', 0);

    return $entries;
}

=head2 deploy_site

Deploy the specified Web site from the repository. In Subversion
repositories, this operation involves copying the C<trunk> directory
to a location in the C<tags> directory named based on the current date
and time. For example:

    svn copy trunk/ tags/200806101037/
    svn ci -m "Deploying to production"

=cut

sub deploy_site {
    my ($self, $site, $revision, $message) = @_;

    my $src = $self->_source_uri($site);
    my $dst = $self->_destination_uri($site);

    $self->client->log_msg(sub {
        my ($msg) = @_;
        $$msg = $message;
    });

    $self->client->copy($src, $revision, $dst);

    $self->client->log_msg(undef);
}

=head2 _site_uri

Return a L<URI> relative to the repository URI.

=cut

sub _site_uri {
    my ($self, @path_segments) = @_;

    my $uri = $self->uri->clone;
    $uri->path_segments($uri->path_segments, @path_segments);

    # Collapse multiple slashes
    my $path = $uri->path;
    $path =~ s|/{2,}|/|g;
    $uri->path($path);

    return $uri;
}

=head2 _source_uri

Return a L<URI> to the location of the site in the repository that
will be used as the source of the tagging operation.

=cut

sub _source_uri {
    my ($self, $site) = @_;

    my $uri = $self->_site_uri($site->uri->host, 'trunk');

    return $uri;
}

=head2 _destination_uri

Return a L<URI> to the location of the site in the repository that
will be used as the destination of the tagging operation.

=cut

sub _destination_uri {
    my ($self, $site) = @_;

    my $dt = DateTime->now(time_zone => 'local');
    my $stamp = $dt->ymd('') . $dt->strftime('%H%M');

    my $uri = $self->_site_uri($site->uri->host, 'tags', $stamp);

    return $uri;
}

=head1 AUTHOR

Daniel Westermann-Clark E<lt>dwc@ufl.eduE<gt>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
