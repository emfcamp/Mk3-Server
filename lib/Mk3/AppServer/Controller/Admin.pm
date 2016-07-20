package Mk3::AppServer::Controller::Admin;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Mk3::AppServer::Controller::Admin - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub auto :Private {
  my ( $self, $c ) = @_;

  unless ( $c->user_exists && $c->check_user_roles( qw/ admin / ) ) {
    $c->res->redirect( $c->uri_for( '/' ) );
    $c->detach;
  }
}

=head2 index

=cut

sub index :Path :Args(0) {
  my ( $self, $c ) = @_;

  my $new_apps_rs = $c->model('DB::Version')->search(
    { status => 'new' },
    { order_by => { -desc => 'timestamp' } },
  );

  $c->stash( new_apps_rs => $new_apps_rs );
}

sub allow :Local :Args(1) {
  my ( $self, $c, $id ) = @_;

  my $version = $c->model('DB::Version')->find( $id );
  if ( defined $version ) {
    $version->allow;
  }
  $c->res->redirect( $c->uri_for( '/admin' ) );
}

sub reject :Local :Args(1) {
  my ( $self, $c, $id ) = @_;

  my $version = $c->model('DB::Version')->find( $id );
  if ( defined $version ) {
    $version->reject;
  }
  $c->res->redirect( $c->uri_for( '/admin' ) );
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
