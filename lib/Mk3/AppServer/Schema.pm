package Mk3::AppServer::Schema;

use base qw/ DBIx::Class::Schema /;

our $VERSION = 7;

__PACKAGE__->load_namespaces();

# reset ResultSet for Version
__PACKAGE__->source('Version')->resultset_class('Mk3::AppServer::Schema::ResultSet::Version');

1;
