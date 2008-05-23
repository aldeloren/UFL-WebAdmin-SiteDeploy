#!perl

use strict;
use warnings;
use Test::More tests => 9;

BEGIN {
    use_ok('UFL::WebAdmin::SiteDeploy::Repository');
}

# file repository URI
{
    my $repo = UFL::WebAdmin::SiteDeploy::Repository->new(uri => 'file:///var/svn/repos/websites');

    isa_ok($repo, 'UFL::WebAdmin::SiteDeploy::Repository');

    isa_ok($repo->uri, 'URI::file');
    is($repo->uri, 'file:///var/svn/repos/websites', 'URI is file:///var/svn/repos/websites');
    is($repo->uri->path, '/var/svn/repos/websites', 'path translated from URI is /var/www/repos/websites');
}

# https repository URI
{
    my $repo = UFL::WebAdmin::SiteDeploy::Repository->new(uri => 'https://svn.webadmin.ufl.edu/repos/websites/');

    isa_ok($repo, 'UFL::WebAdmin::SiteDeploy::Repository');

    isa_ok($repo->uri, 'URI::https');
    is($repo->uri, 'https://svn.webadmin.ufl.edu/repos/websites/', 'URI is https://svn.webadmin.ufl.edu/repos/websites/');
    is($repo->uri->path, '/repos/websites/', 'path translated from URI is /repos/websites/');
}
