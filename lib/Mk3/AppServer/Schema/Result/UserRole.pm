package Mk3::AppServer::Schema::Result::UserRole;

use DBIx::Class::Candy
  -autotable => v1;

column user_id => {
  data_type => 'int',
};

column role_id => {
  data_type => 'int',
};

primary_key qw/ role_id user_id /;

belongs_to 'user', 'Mk3::AppServer::Schema::Result::User', { id => 'user_id' };
belongs_to 'role', 'Mk3::AppServer::Schema::Result::Role', { id => 'role_id' };

1;
