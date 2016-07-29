package Mk3::AppServer::Controller::User;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Mk3::AppServer::Controller::User - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub auto :Private {
  my ( $self, $c ) = @_;

  # Redirect to root if there is no logged in user
  unless ( $c->user_exists ) {
    $c->res->redirect( $c->uri_for( '/' ) );
  }
}


=head2 index

=cut

sub index :Path :Args(0) {
  my ( $self, $c ) = @_;

}

sub settings :Local :Args(0) {
  my ( $self, $c ) = @_;

}

=encoding utf8

=head1 AUTHOR

Tom Bloor,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
