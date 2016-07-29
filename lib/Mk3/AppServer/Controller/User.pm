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

sub change_pass :Local :Args(0) {
  my ( $self, $c ) = @_;

  if ( $c->req->method eq 'GET' ) {
    $c->res->redirect( $c->uri_for( '/user/settings' ) );
    $c->detach;
  }

  my $old_pass = $c->req->body_data->{ old_pass };
  my $new_pass = $c->req->body_data->{ new_pass };
  my $new_pass2 = $c->req->body_data->{ new_pass2 };

  if ( $c->user->password->match( $old_pass ) ) {
    if ( $new_pass eq $new_pass2 ) {
     $c->user->set_new_password( $new_pass );
     $c->stash( message => 'Password changed successfully' );
    } else {
      # Passwords did not match
      $c->stash( error => 'New Passwords did not match' );
    }
  } else {
    # Original Password was wrong
    $c->stash( error => 'Old Password was incorrect' );
  }

  $c->stash( template => 'user/settings.tt' );
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
