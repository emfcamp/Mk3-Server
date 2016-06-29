package Mk3::AppServer::Schema::Result::User;

use DBIx::Class::Candy
  -autotable => v1,
  -components => [ 'PassphraseColumn' ];

primary_column id => {
  data_type => 'int',
  is_auto_increment => 1,
};

unique_column username => {
  data_type => 'varchar',
  size => 255,
};

unique_column email => {
  data_type => 'varchar',
  size => 255,
};

column password => {
  data_type => 'varchar',
  size => 50,
  passphrase => 'crypt',
  passphrase_class => 'BlowfishCrypt',
  passphrase_args => {
    salt_random => 20,
    cost => 8,
  },
  passphrase_check_method => 'check_password',
};

column set_password_code => {
  data_type   => 'varchar',
  size        => 80,
  is_nullable => 1,
};

1;
