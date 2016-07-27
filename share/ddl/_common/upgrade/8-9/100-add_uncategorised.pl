#!perl
 
use strict;
use warnings;
 
use DBIx::Class::DeploymentHandler::DeployMethod::SQL::Translator::ScriptHelpers
   'schema_from_schema_loader';
 
schema_from_schema_loader({ naming => 'v7' }, sub {
  my $schema = shift;
 
  $schema->resultset('Category')->create({
    name => 'uncategorised',
    id => 0,
  });
});
