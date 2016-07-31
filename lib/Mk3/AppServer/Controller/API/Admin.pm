package Mk3::AppServer::Controller::API::Admin;
use Moose;
use IO::All;
use File::Temp;
use File::Spec;
use LWP::UserAgent;
use Archive::Extract;
use Digest::SHA;
use JSON::MaybeXS qw/ encode_json /;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Mk3::AppServer::Controller::API::Admin - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

has access_key => (
  is => 'ro',
  required => 1,
);

# TODO factor this out somewhere else
has firmware_uri => (
  is => 'ro',
  default => 'https://github.com/emfcamp/Mk3-Firmware/archive/%s.zip',
);

sub auto :Private {
  my ( $self, $c ) = @_;

  unless ( defined $c->req->params->{ key } && $c->req->params->{ key } eq $self->access_key ) {
    $c->stash( json => {
      success => \0,
      message => 'Access Denied',
    });
    $c->res->status( 403 );
    $c->detach;
  }
}

=head2 index

=cut

sub index :Path :Args(0) {
  my ( $self, $c ) = @_;

  $c->stash( json => {
    success => \1,
    message => 'Access Granted',
  });
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
  $c->stash( json => { success => \1, message => "Updated $branch" } );
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

EMFCamp Appserver Account

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
