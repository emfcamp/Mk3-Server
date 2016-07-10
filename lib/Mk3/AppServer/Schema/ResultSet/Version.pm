package Mk3::AppServer::Schema::ResultSet::Version;

use strict;
use warnings;

use Archive::Tar;
use File::Temp ();
use Path::Class::File ();

use base qw/ DBIx::Class::InflateColumn::FS::ResultSet /;

sub new_version {
  my ( $self, $create_hash ) = @_;

  if ( defined $create_hash->{ tar_file } ) {
    return $self->_inflate_tar_file( $create_hash );
  } elsif ( defined $create_hash->{ gz_file } ) {
    return $self->_inflate_gz_file( $create_hash );
  }
}

sub _inflate_tar_file {
  my ( $self, $create_hash, $tar_file ) = @_;

  my $tar = Archive::Tar->new( $tar_file || $create_hash->{ tar_file } );
  return { result => undef, error => 'Not a valid Tar File' } unless defined $tar;

  my $tempdir = File::Temp->newdir;

  $tar->setcwd( $tempdir->dirname );

  my @local_filenames = $tar->extract;

  my @checked_files = map {
    {
      filename => $_->full_path,
      file => Path::Class::File->new( $tempdir->dirname . '/' . $_->full_path ),
    }
  } @local_filenames;

  $create_hash->{ files } = \@checked_files;

  my $result = $self->create( $create_hash );

  return { result => $result };
}

sub _inflate_gz_file {
  my ( $self, $create_hash ) = @_;

  return $self->_inflate_tar_file( $create_hash, $create_hash->{ gz_file } );
}

1;
