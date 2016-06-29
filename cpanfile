requires 'Catalyst::Runtime' => '5.90105';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Moose';
requires 'namespace::autoclean';
requires 'Config::General';
requires 'DBIx::Class';
requires 'DBIx::Class::Candy';
requires 'DBIx::Class::PassphraseColumn';
requires 'DBIx::Class::DeploymentHandler';
requires 'Authen::Passphrase::BlowfishCrypt';
requires 'Moo';
requires 'MooX::Options';
requires 'Module::Runtime';
requires 'namespace::clean';

on 'test' => sub {
  requires 'Test::More' => '0.88';
}
