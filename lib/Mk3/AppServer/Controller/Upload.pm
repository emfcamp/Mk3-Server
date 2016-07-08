package Mk3::AppServer::Controller::Upload;
use Moose;
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
    if ( $c->request->parameters->{form_submit} eq 'yes' ) {
      if ( my $upload = $c->request->upload( 'my_file' ) ) {
        use Data::Dumper;
        $c->stash( upload_dump => Dumper $upload );

        if ( $upload->type eq 'application/zip' ) {
          # *.zip file
          #$c->model('DB::Version')
        } elsif ( $upload->type eq 'application/x-tar' ) {
          # .tar file

        } elsif ( $upload->type eq 'application/gzip' ) {
          # .tar.gz file

        } elsif ( $upload->type eq 'application/x-compressed-tar' ) {
          # .tgz file (same as tar.gz file)

        } else {
          $c->stash( upload_error => "Unrecognised Archive Type" );
        }
      }
    }
  } else {
    $c->res->redirect( $c->uri_for( '/' ) );
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
