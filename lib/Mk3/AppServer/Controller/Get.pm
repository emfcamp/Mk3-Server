package Mk3::AppServer::Controller::Get;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Mk3::AppServer::Controller::Get - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(1) {
  my ( $self, $c, $file_id ) = @_;

  my $file_result = $c->model('DB::File')->find( $file_id );

  if ( defined $file_result ) {
    $self->_serve_file( $c, $file_result->filename, $file_result->file );
  } else {
    $c->stash(
      template => 'error.tt',
      error => 'File does not exist',
    );
  }
}

sub _serve_file {
  my ( $self, $c, $filename, $file ) = @_;

  my $mime_type = MIME::Types->new->mimeTypeOf( $filename );
  my $mime_string = defined $mime_type ? $mime_type->type : 'application/octet-stream';
  $c->res->content_type( $mime_string );
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
