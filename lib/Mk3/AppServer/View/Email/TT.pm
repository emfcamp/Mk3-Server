package Mk3::AppServer::View::Email::TT;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
  TEMPLATE_EXTENSION => '.tt',
  render_die => 1,
);

=head1 NAME

Mk3::AppServer::View::Email::TT - TT View for Mk3::AppServer

=head1 DESCRIPTION

TT View for Mk3::AppServer.

=head1 SEE ALSO

L<Mk3::AppServer>

=head1 AUTHOR

Tom Bloor,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
