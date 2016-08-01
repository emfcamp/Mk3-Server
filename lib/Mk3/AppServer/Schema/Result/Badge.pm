package Mk3::AppServer::Schema::Result::Badge;

use DBIx::Class::Candy
  -autotable => v1;

primary_column id => {
  data_type => 'int',
  is_auto_increment => 1,
};

unique_column badge_id => {
  data_type => 'varchar',
  size => 100,
};

column secret => {
  data_type => 'varchar',
  size => 100,
};

1;
