package Mk3::AppServer::Controller::Upload;
use Moose;
use Path::Class::File ();
use DateTime;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Mk3::AppServer::Controller::Upload - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
  my ( $self, $c ) = @_;

  if ( $c->user_exists ) {
    my $app_id = $c->request->parameters->{app_id};
    my $app_result = $c->user->search_related('projects', {id => $app_id })->first;

    if ( defined $app_result ) {
      if ( my $upload = $c->request->upload( 'app_archive' ) ) {
        $self->save_file( $c, $app_result, $upload );
      }
    } else {
      $c->stash(
        error => 'You dont own that app, you cannot upload a new version to it!',
        template => 'error.tt',
      );
      $c->res->status(404);
    }
  } else {
    $c->res->redirect( $c->uri_for( '/' ) );
  }

}

sub save_file {
  my ( $self, $c, $app_result, $upload ) = @_;
  $c->stash( upload_dump => Dumper $upload );

  my $latest_version = $app_result->latest_version;
  my $version_num = defined $latest_version ? $latest_version->version + 1 : 1;

  my $create_hash = {
    project_id => $app_result->id,
    version => $version_num,
    description => '',
    timestamp => DateTime->now,
  };
  my $file = Path::Class::File->new( $upload->tempname );
  if ( $upload->type eq 'application/zip' ) {
    # *.zip file
    $create_hash->{ zip_file } = $file;
  } elsif ( $upload->type eq 'application/x-tar' ) {
    # .tar file
    $create_hash->{ tar_file } = $file;
  } elsif ( $upload->type eq 'application/gzip' ) {
    # .tar.gz file
    $create_hash->{ gz_file } = $file;
  } elsif ( $upload->type eq 'application/x-compressed-tar' ) {
    # .tgz file (same as tar.gz file)
    $create_hash->{ gz_file } = $file;
  } else {
    $c->stash( error => "Unrecognised Archive Type", template => 'error.tt' );
    return;
  }
  my $new_version = $c->model('DB::Version')->new_version( $create_hash );
  $c->stash( create_error => $new_version->{ error } );
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
