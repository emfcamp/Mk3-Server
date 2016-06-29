package Mk3::AppServer::Controller::Login;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Mk3::AppServer::Controller::Login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) GET {
  my ( $self, $c ) = @_;

  if ( $c->user_exists ) {
    $c->res->redirect( $c->uri_for( '/' ) );
  }
}

sub login_post :Path :Args(0) POST {
  my ( $self, $c ) = @_;

  my $username = $c->request->body_data->{username};
  my $password = $c->request->body_data->{password};

  if ( $c->authenticate({ username => $username, password => $password }) ) {
    $c->res->redirect( $c->uri_for( '/' ) );
  } else {
    $c->stash( error => 'Unrecognised Username/Password' );
    $c->stash( template => 'login/index.tt' );
  }
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
