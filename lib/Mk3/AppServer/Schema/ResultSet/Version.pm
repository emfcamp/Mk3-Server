package Mk3::AppServer::Schema::ResultSet::Version;

use strict;
use warnings;

use Archive::Extract;
use File::Temp ();
use File::Spec;
use Path::Class::File ();
use Digest::SHA;
use IO::All;

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

sub _inflate_archive_file {
  my ( $self, $create_hash, $key ) = @_;

  my $archive_file = delete $create_hash->{ $key };

  my $archive = Archive::Extract->new( archive => $archive_file );
  return { error => 'Not a valid Archive' } unless defined $archive;

  my $tempdir = File::Temp->newdir;

  return { error => 'Error opening Archive' } unless $archive->extract( to => $tempdir->dirname );

  my $io_archive = io->dir( $tempdir->dirname );

  $io_archive = $self->_cleanup_files( $io_archive );

  my @io_archive_files = $io_archive->all;

  if ( scalar( @io_archive_files ) == 1 ) {
    $io_archive = $self->_cleanup_files( $io_archive_files[0] );
  } else {
    return { error => 'Archive must be a flat file structure, or only contain one folder' };
  }

  my @local_files = $io_archive->all;

  my $main_flag = 0;
  for my $file ( @local_files ) {
    return { error => 'Filenames must not contain any whitespace' } if $file->filename =~ /\s/;
    $main_flag = 1 if $file->filename eq 'main.py';
  }

  unless ( $main_flag eq 1 ) {
    return { error => 'App must contain "main.py" file' };
  }

  my @checked_files = map {
    {
      filename => $_->filename,
      file => Path::Class::File->new( $_->name ),
      file_hash => Digest::SHA->new(256)->addfile( $_->name )->hexdigest,
    }
  } @local_files;

  $create_hash->{ files } = \@checked_files;

  my $result = $self->create( $create_hash );

  return { result => $result };
}

sub _inflate_tar_file {
  my ( $self, $create_hash ) = @_;

  return $self->_inflate_archive_file( $create_hash, 'tar_file' );
}

sub _inflate_gz_file {
  my ( $self, $create_hash ) = @_;

  return $self->_inflate_archive_file( $create_hash, 'gz_file' );
}

sub _inflate_zip_file {
  my ( $self, $create_hash ) = @_;

  return $self->_inflate_archive_file( $create_hash, 'zip_file' );
}

sub _cleanup_files {
  my ( $self, $io ) = @_;

  my @files = $io->all;
  for my $file ( @files ) {
    if ( $file->filename =~ /^\./ ) {
      $self->_remove_file_or_folder( $file );
      next;
    }
    if ( $file->filename eq '__MACOSX' ) {
      $self->_remove_file_or_folder( $file );
      next;
    }
  }
  return $io;
}

sub _remove_file_or_folder {
  my ( $self, $io ) = @_;

  if ( $io->is_dir ) {
    $io->rmtree;
  }

  if ( $io->is_file ) {
    $io->unlink;
  }
}

1;
