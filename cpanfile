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
requires 'Catalyst::View::TT';
requires 'Catalyst::Plugin::Session';
requires 'Catalyst::Plugin::Session::Store::FastMmap';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Authentication::Store::DBIx::Class';
requires 'DBIx::Class::InflateColumn::DateTime';
requires 'DBIx::Class::InflateColumn::FS';
requires 'JSON::MaybeXS';
requires 'Cpanel::JSON::XS';
requires 'Path::Class::File';
requires 'IO::Zlib';

on 'test' => sub {
  requires 'Test::More' => '0.88';
}
