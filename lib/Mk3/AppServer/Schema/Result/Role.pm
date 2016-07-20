package Mk3::AppServer::Schema::Result::Role;

use DBIx::Class::Candy
  -autotable => v1;

primary_column id => {
  data_type => 'int',
  is_auto_increment => 1,
};

unique_column name => {
  data_type => 'varchar',
  size => 255,
};

has_many( 'user_roles' => 'Mk3::AppServer::Schema::Result::UserRole', 'role_id' );
many_to_many( 'users' => 'user_roles', 'user' );

1;
