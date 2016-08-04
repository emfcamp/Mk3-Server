package Mk3::AppServer::Controller::Admin;
use Moose;
use LWP::UserAgent;
use File::Temp;
use Archive::Extract;
use IO::All;
use Digest::SHA;
use JSON::MaybeXS qw/ encode_json /;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Mk3::AppServer::Controller::Admin - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

has firmware_uri => (
  is => 'ro',
  default => 'https://github.com/emfcamp/Mk3-Firmware/archive/%s.zip',
);

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

  my $redirect = $c->req->headers->referer || $c->uri_for( '/admin' );

  my $version = $c->model('DB::Version')->find( $id );
  if ( defined $version ) {
    $version->allow;
    $version->project->set_latest_allowed_version;
  }
  $c->res->redirect( $redirect );
}

sub reject :Local :Args(1) {
  my ( $self, $c, $id ) = @_;

  my $redirect = $c->req->headers->referer || $c->uri_for( '/admin' );

  my $version = $c->model('DB::Version')->find( $id );
  if ( defined $version ) {
    $version->reject;
  }
  $c->res->redirect( $redirect );
}

sub users :Local {
  my ( $self, $c ) = @_;

  my $users_rs = $c->model('DB::User');
  $c->stash( users_rs => $users_rs );
}

sub give_admin :Local :Args(1) {
  my ( $self, $c, $id ) = @_;

  my $user = $c->model('DB::User')->find( $id );
  if ( defined $user ) {
    my $role = $c->model('DB::Role')->find({ name => 'admin' });
    $user->find_or_create_related('user_roles', { role_id => $role->id });
  }
  $c->res->redirect( $c->uri_for( '/admin/users' ) );
}

sub take_admin :Local :Args(1) {
  my ( $self, $c, $id ) = @_;

  my $user = $c->model('DB::User')->find( $id );
  if ( defined $user ) {
    my $role = $c->model('DB::Role')->find({ name => 'admin' });
    $user->delete_related('user_roles', { role_id => $role->id });
  }
  $c->res->redirect( $c->uri_for( '/admin/users' ) );
}

sub update :Local :Args(1) {
  my ( $self, $c, $branch ) = @_;

  my $fetch_url = sprintf( $self->firmware_uri, $branch );

  my $tmpfile = File::Temp->new( SUFFIX => '.zip' );
  my $tempdir = File::Temp->newdir;
  my $ua = LWP::UserAgent->new;

  my $response = $ua->get( $fetch_url, ':content_file' => $tmpfile->filename );

  my $zip = Archive::Extract->new( archive => $tmpfile->filename );

  my $firmware_path = $c->path_to( qw/ root firmware /, $branch );

  $zip->extract( to => $tempdir->dirname );

  my $files = $zip->files;

  my $target_dir = io->dir( $firmware_path->stringify );
  $target_dir->rmtree;

  io->dir(
    File::Spec->catdir( $tempdir->dirname, 'Mk3-Firmware-' . $branch )
    )->copy( $firmware_path->stringify );

  my $json_path = $firmware_path->stringify . ".json";

  my $json_file = io( $json_path );
  $json_file->print(
    encode_json(
      $self->create_hashed_array( $target_dir )
    )
  );
  $c->stash( template => 'error.tt', error => "Updated $branch" );
}

sub create_hashed_array {
  my ( $self, $io ) = @_;

  if ( $io->is_dir ) {
    return { map { $_->filename => $self->create_hashed_array( $_ ) } $io->all };
  } else {
    return Digest::SHA->new(256)->addfile($io->name)->hexdigest;
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
