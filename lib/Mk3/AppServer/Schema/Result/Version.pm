package Mk3::AppServer::Schema::Result::Version;

use DBIx::Class::Candy
  -autotable => v1,
  -components => [ 'InflateColumn::DateTime', 'InflateColumn::FS' ];

use Archive::Tar;
use Archive::Zip;
use File::Temp;
use File::Spec;
use File::chdir;
use Path::Class::File;

primary_column id => {
  data_type => 'int',
  is_auto_increment => 1,
};

column project_id => {
  data_type => 'int',
};

column version => {
  data_type => 'int',
  default_value => 1,
};

unique_constraint [ qw/ project_id version / ];

column timestamp => {
  data_type => 'datetime',
};

column description => {
  data_type => 'text',
};

column tar_file => {
  data_type => 'text',
  is_fs_column => 1,
  fs_column_path => '/tmp/mk3appserver',
  is_nullable => 1,
};

column zip_file => {
  data_type => 'text',
  is_fs_column => 1,
  fs_column_path => '/tmp/mk3appserver',
  is_nullable => 1,
};

column gz_file => {
  data_type => 'text',
  is_fs_column => 1,
  fs_column_path => '/tmp/mk3appserver',
  is_nullable => 1,
};

# new, allowed, rejected
column status => {
  data_type => 'varchar',
  default_value => 'new',
  size => '10',
};

belongs_to(
  'project' => 'Mk3::AppServer::Schema::Result::Project',
  { 'foreign.id' => 'self.project_id' },
);

has_many( 'files' => 'Mk3::AppServer::Schema::Result::File', 'version_id' );

sub get_tar {
  my $self = shift;

  if ( defined ( my $tar_file = $self->tar_file ) ) {
    return $tar_file;
  }

  my $tar = Archive::Tar->new;
  my $tmpdir = File::Temp->newdir;
  my $tmpfile = File::Temp->new( SUFFIX => '.tar' );

  {
    local $CWD = $tmpdir->dirname;

    my @files = $self->_copy_files( $tmpdir );

    $tar->add_files( @files );

    $tar->write( $tmpfile->filename );

    $self->tar_file( Path::Class::File->new( $tmpfile->filename ) );
    $self->update;
  }

  return $self->tar_file;
}

sub get_tgz {
  my $self = shift;

  if ( defined ( my $gz_file = $self->gz_file ) ) {
    return $gz_file;
  }

  my $tar = Archive::Tar->new;
  my $tmpdir = File::Temp->newdir;
  my $tmpfile = File::Temp->new( SUFFIX => '.tgz' );

  {
    local $CWD = $tmpdir->dirname;

    my @files = $self->_copy_files( $tmpdir );

    $tar->add_files( @files );

    $tar->write( $tmpfile->filename, COMPRESS_GZIP );

    $self->gz_file( Path::Class::File->new( $tmpfile->filename ) );
    $self->update;
  }

  return $self->gz_file;
}

sub get_zip {
  my $self = shift;

  if ( defined ( my $zip_file = $self->zip_file ) ) {
    return $zip_file;
  }

  my $zip = Archive::Zip->new;
  my $tmpdir = File::Temp->newdir;
  my $tmpfile = File::Temp->new( SUFFIX => '.zip' );

  my @files = $self->_copy_files( $tmpdir );

  $zip->addTree( $tmpdir->dirname, '' );

  $zip->writeToFileNamed( $tmpfile->filename );
  $self->zip_file( Path::Class::File->new( $tmpfile->filename ) );
  $self->update;

  return $self->zip_file;
}

sub _copy_files {
  my ( $self, $tmpdir ) = @_;

  my $files_rs = $self->search_related_rs( 'files', undef );

  my @files;

  while ( my $file_result = $files_rs->next ) {
    my $filename = File::Spec->catfile( $tmpdir->dirname, $file_result->filename );
    $file_result->file->copy_to( $filename );
    push @files, $file_result->filename;
  }

  return @files;
}

sub allow {
  my ( $self ) = @_;
  
  $self->status( 'allowed' );
  $self->update;
  return $self;
}

sub reject {
  my ( $self ) = @_;

  $self->status( 'rejected' );
  $self->update;
  return $self;
}

1;
