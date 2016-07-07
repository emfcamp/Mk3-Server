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

1;
