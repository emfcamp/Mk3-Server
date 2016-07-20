package Mk3::AppServer::View::JSON;

use strict;
use base 'Catalyst::View::JSON';

__PACKAGE__->config({
  expose_stash => 'json',
});

=head1 NAME

Mk3::AppServer::View::JSON - Catalyst JSON View

=head1 SYNOPSIS

See L<Mk3::AppServer>

=head1 DESCRIPTION

Catalyst JSON View.

=head1 AUTHOR

Tom Bloor,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
