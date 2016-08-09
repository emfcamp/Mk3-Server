package Mk3::AppServer::Schema::Result::Project;

use DBIx::Class::Candy
  -autotable => v1;

primary_column id => {
  data_type => 'int',
  is_auto_increment => 1,
};

column user_id => {
  data_type => 'int',
};

column name => {
  data_type => 'varchar',
  size => 255,
};

column lc_name => {
  data_type => 'varchar',
  size => 255,
};

column description => {
  data_type => 'text',
};

belongs_to(
  'user' => 'Mk3::AppServer::Schema::Result::User',
  { 'foreign.id' => 'self.user_id' },
);

has_many( 'versions' => 'Mk3::AppServer::Schema::Result::Version', 'project_id' );

column category_id => {
  data_type => 'int',
  is_nullable => 1,
  default_value => '0',
};

belongs_to(
  'category' => 'Mk3::AppServer::Schema::Result::Category',
  { 'foreign.id' => 'self.category_id' },
);

column latest_allowed_version => {
  data_type => 'int',
  is_nullable => 1,
};

column published => {
  data_type => 'boolean',
  default_value => \1,
};

sub set_latest_allowed_version {
  my $self = shift;

  my $latest_allowed_version = $self->search_related(
    'versions',
    { status => 'allowed' },
    { order_by => { -desc => 'version' } },
  )->first;
  
  if ( defined $latest_allowed_version ) {
    $self->latest_allowed_version( $latest_allowed_version->id );
    $self->update;
  } else {
    $self->latest_allowed_version( undef );
    $self->update;
  }
  return $self;
}

sub get_latest_allowed_version {
  my $self = shift;

  my $latest_allowed_version = $self->search_related(
    'versions',
    { id => $self->latest_allowed_version },
  )->first;

  return $latest_allowed_version;
}

sub latest_version {
  my $self = shift;

  return $self->search_related(
    'versions',
    undef,
    { order_by => { -desc => 'version' } }
  )->first;
}

1;
