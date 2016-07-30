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
requires 'Catalyst::Plugin::Authorization::Roles';
requires 'Catalyst::Authentication::Store::DBIx::Class';
requires 'DBIx::Class::InflateColumn::DateTime';
requires 'DBIx::Class::InflateColumn::FS';
requires 'Catalyst::View::JSON';
requires 'JSON::MaybeXS';
requires 'Cpanel::JSON::XS';
requires 'Path::Class::File';
requires 'Archive::Extract';
requires 'File::chdir';
requires 'Archive::Tar';
requires 'Archive::Zip';
requires 'MIME::Types';
requires 'Daemon::Control';
requires 'DateTime';
requires 'DBIx::Class::Schema::Loader';
requires 'DateTime::Format::SQLite';
requires 'Starman';
requires 'IO::All';
requires 'File::Copy::Recursive';
requires 'LWP::Protocol::https';
requires 'String::Random';
requires 'Catalyst::View::Email::Template';
requires 'IO::File::WithPath';
requires 'Plack::Middleware::XSendfile';

on 'test' => sub {
  requires 'Test::More' => '0.88';
};

feature 'postgres', 'PostgreSQL Support' => sub {
  requires 'DBD::Pg';
  requires 'DateTime::Format::Pg';
};

feature 'migration', 'Migrate from DB to DB' => sub {
  requires 'DBIx::Class::Fixtures';
};
