package Mk3::AppServer::Controller::App::Get;
use Moose;
use File::Spec;
use MIME::Types;
use IO::File::WithPath;
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
      $self->_serve_archive( $c, $version_result, 'tar' );
    } elsif ( $archive_type eq 'tgz' ) {
      $self->_serve_archive( $c, $version_result, 'tgz' );
    } elsif ( $archive_type eq 'zip' ) {
      $self->_serve_archive( $c, $version_result, 'zip' );
    } else {
      $c->stash(
        template => 'error.tt',
        error => 'Unrecognised Archive type',
      );
    }
  }
}

sub _serve_archive {
  my ( $self, $c, $version_result, $extension ) = @_;

  my $file = $version_result->${\"get_$extension"};
  my $filename = sprintf(
    '%s-%s-%s.%s',
    $c->stash->{ user_result }->lc_username,
    $c->stash->{ app_result }->lc_name,
    $version_result->version,
    $extension,
  );
  $self->_serve_file( $c, $filename, $file );
}

sub end_file :Chained('chain_get') :PathPart('file') :Args {
  my ( $self, $c, @filepath ) = @_;

  if ( defined ( my $version_result = $c->stash->{ version_result } ) ) {
    my $search_filename = File::Spec->catfile( @filepath );
    my $file_result = $version_result->search_related(
      'files',
      { filename => $search_filename },
    )->first;
    if ( defined $file_result ) {
      $self->_serve_file( $c, $file_result->filename, $file_result->file );
    } else {
      $c->stash(
        template => 'error.tt',
        error => 'File does not exist',
      );
    }
  }
}

sub _serve_file {
  my ( $self, $c, $filename, $file ) = @_;

  my $mime_type = MIME::Types->new->mimeTypeOf( $filename );
  $c->res->content_type( $mime_type->type );
  $c->res->header('Content-Disposition', qq[attachment; filename="$filename"]);
  my $io = IO::File::WithPath->new( $file->absolute->stringify );
  $c->res->body( $io );
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
