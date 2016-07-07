package Mk3::AppServer::Schema::Result::File;

use DBIx::Class::Candy
  -autotable => v1,
  -components => [ 'InflateColumn::FS' ];

primary_column id => {
  data_type => 'int',
  is_auto_increment => 1,
};

column version_id => {
  data_type => 'int',
};

column filename => {
  data_type => 'varchar',
  size => '255',
};

column file => {
  data_type => 'text',
  is_fs_column => 1,
  fs_column_path => '/tmp/mk3appserver',
  is_nullable => 1,
};

belongs_to(
  'version' => 'Mk3::AppServer::Schema::Result::Version',
  { 'foreign.id' => 'self.version_id' },
);

1;
