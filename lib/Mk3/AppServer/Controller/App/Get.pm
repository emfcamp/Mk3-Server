package Mk3::AppServer::Controller::App::Get;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Mk3::AppServer::Controller::App::Get - Catalyst Controller

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

sub chain_get :Chained('../chain_version') :PathPart('get') :CaptureArgs(0) {
  my ( $self, $c ) = @_;

  # This does nothing, just acts as an extra path point
}

sub end_archive :Chained('chain_get') :PathPart('archive') :Args(1) {
  my ( $self, $c, $archive_type ) = @_;

  if ( defined ( my $version_result = $c->stash->{ version_result } ) ) {
    if ( $archive_type eq 'tar' ) {
      my $file = $version_result->get_tar;
      my $filename = sprintf(
        '%s-%s-%s.tar',
        $c->stash->{ user_result }->lc_username,
        $c->stash->{ app_result }->lc_name,
        $version_result->version,
      );
      $c->res->content_type('application/x-tar');
      $c->res->header('Content-Disposition', qq[attachment; filename="$filename"]);
      $c->res->body( $file->openr );
    } elsif ( $archive_type eq 'tgz' ) {
      my $file = $version_result->get_tgz;
      my $filename = sprintf(
        '%s-%s-%s.tgz',
        $c->stash->{ user_result }->lc_username,
        $c->stash->{ app_result }->lc_name,
        $version_result->version,
      );
      $c->res->content_type('application/x-compressed-tar');
      $c->res->header('Content-Disposition', qq[attachment; filename="$filename"]);
      $c->res->body( $file->openr );
    } elsif ( $archive_type eq 'zip' ) {
      my $file = $version_result->get_zip;
      my $filename = sprintf(
        '%s-%s-%s.zip',
        $c->stash->{ user_result }->lc_username,
        $c->stash->{ app_result }->lc_name,
        $version_result->version,
      );
      $c->res->content_type('application/zip');
      $c->res->header('Content-Disposition', qq[attachment; filename="$filename"]);
      $c->res->body( $file->openr );
    } else {
      $c->stash(
        template => 'error.tt',
        error => 'Unrecognised Archive type',
      );
    }
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
