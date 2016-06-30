package Mk3::AppServer::Schema::Result::Version;

use DBIx::Class::Candy
  -autotable => v1,
  -components => [ 'InflateColumn::DateTime' ];

primary_column id => {
  data_type => 'int',
  is_auto_increment => 1,
};

column project_id => {
  data_type => 'int',
};

column timestamp => {
  data_type => 'datetime',
};

column description => {
  data_type => 'text',
};

belongs_to(
  'project' => 'Mk3::AppServer::Schema::Result::Project',
  { 'foreign.id' => 'self.project_id' },
);

has_many( 'files' => 'Mk3::AppServer::Schema::Result::File', 'version_id' );

1;
