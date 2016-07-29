package Mk3::AppServer::View::Email;

use strict;
use base 'Catalyst::View::Email::Template';

__PACKAGE__->config(
  stash_key       => 'email',
  default => {
    view => 'Email::TT',
  },
  content_type => 'text/plain',
);

=head1 NAME

Mk3::AppServer::View::Email - Templated Email View for Mk3::AppServer

=head1 DESCRIPTION

View for sending template-generated email from Mk3::AppServer. 

=head1 AUTHOR

Tom Bloor,,,

=head1 SEE ALSO

L<Mk3::AppServer>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
