package Mk3::AppServer::Controller::App;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Mk3::AppServer::Controller::App - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
  my ( $self, $c ) = @_;

  $c->response->redirect( $c->uri_for( '/apps' ) );
}

sub apps :Path('/apps') :Args(0) {
  my ( $self, $c ) = @_;

  my $apps_rs = $c->model( 'DB::Project' );
  $c->stash( apps_rs => $apps_rs );
}

sub add :Local :Args(0) {
  my ( $self, $c ) = @_;

  my $app_name = $c->req->body_params->{ app_name };


  if ( $c->user_exists ) {
    unless( $app_name =~ /^[\w- ]+$/ ) {
      $c->stash(
        error => 'App name can only contain alphanumeric characters,'
                 . " spaces, '-' and '_'",
        app_name => $app_name,
      );
    } elsif ( $c->user->projects->find({ name => $app_name }) ) {
      $c->stash(
        error => 'App Already Exists',
        app_name => $app_name,
      );
    } else {
      my $lc_name = lc $app_name;
      $lc_name =~ s/ /-/g;
      $c->user->create_related(
        'projects',
        {
          name => $app_name,
          lc_name => $lc_name,
          description => '',
        }
      );
      $c->res->redirect( $c->uri_for( '/app/' . $lc_name ) );
    }
  } else {
    $c->stash( error => 'You cannot create an app when not logged in' );
  }
}

sub chain_root :Chained(/) :PathPart('app') :CaptureArgs(0) {
  my ( $self, $c ) = @_;

}

sub chain_user :Chained('chain_root') :PathPart('') :CaptureArgs(1) {
  my ( $self, $c, $username ) = @_;

  $c->stash( user_capture => $username );
}

sub end_user :Chained('chain_root') :PathPart('') :Args(1) {
  my ( $self, $c, $username ) = @_;

  $c->stash( user_capture => $username );
}

sub end_app :Chained('chain_user') :PathPart('') :Args(1) {
  my ( $self, $c, $appname ) = @_;

  $c->stash( app_capture => $appname );
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
