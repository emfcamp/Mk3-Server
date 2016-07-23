package Mk3::AppServer::Schema::Result::Category;

use DBIx::Class::Candy
  -autotable => v1;

primary_column id => {
  data_type => 'int',
  is_auto_increment => 1,
};

unique_column name => {
  data_type => 'varchar',
  size => '10',
};

has_many( 'projects' => 'Mk3::AppServer::Schema::Result::Project', 'category_id' );

1;
