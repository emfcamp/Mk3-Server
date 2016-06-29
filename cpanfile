requires 'Catalyst::Runtime' => '5.90105';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Moose';
requires 'namespace::autoclean';
requires 'Config::General';

on 'test' => sub {
  requires 'Test::More' => '0.88';
}
