package Mk3::AppServer::Schema::ResultSet::Version;

use strict;
use warnings;

use Archive::Extract;
use File::Temp ();
use File::Spec;
use Path::Class::File ();

use base qw/ DBIx::Class::InflateColumn::FS::ResultSet /;

sub new_version {
  my ( $self, $create_hash ) = @_;

  if ( defined $create_hash->{ tar_file } ) {
    return $self->_inflate_tar_file( $create_hash );
  } elsif ( defined $create_hash->{ gz_file } ) {
    return $self->_inflate_gz_file( $create_hash );
  } elsif ( defined $create_hash->{ zip_file } ) {
    return $self->_inflate_zip_file( $create_hash );
  }
}

sub _inflate_tar_file {
  my ( $self, $create_hash, $tar_file ) = @_;

  my $tar = Archive::Extract->new( archive => $tar_file || $create_hash->{ tar_file } );
  return { error => 'Not a valid Archive' } unless defined $tar;

  my $tempdir = File::Temp->newdir;

  return { error => 'Error opening Archive' } unless $tar->extract( to => $tempdir->dirname );

  my $local_filenames = $tar->files;

  return { error => 'Must be a flat file structure' } if grep(/\//, @$local_filenames);
  return { error => 'Filenames must not contain any whitespace' } if grep(/\s/, @$local_filenames);

  my @checked_files = map {
    {
      filename => $_,
      file => Path::Class::File->new( File::Spec->catfile( $tempdir->dirname, $_ ) ),
    }
  } @$local_filenames;

  $create_hash->{ files } = \@checked_files;

  my $result = $self->create( $create_hash );

  return { result => $result };
}

sub _inflate_gz_file {
  my ( $self, $create_hash ) = @_;

  return $self->_inflate_tar_file( $create_hash, $create_hash->{ gz_file } );
}

sub _inflate_zip_file {
  my ( $self, $create_hash ) = @_;

  return $self->_inflate_tar_file( $create_hash, $create_hash->{ zip_file } );
}

1;
