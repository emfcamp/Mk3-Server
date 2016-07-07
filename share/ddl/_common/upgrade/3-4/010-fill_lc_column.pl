#! perl

use strict;
use warnings;

use DBIx::Class::DeploymentHandler::DeployMethod::SQL::Translator::ScriptHepers
  qw/ schema_from_schema_loader /;

schema_from_schema_loader({ naming => 'v7' }, sub {
  my ( $schema, $version_set ) = @_;

  my $users_rs = $schema->resultset('User');

  while ( my $user_result = $users_rs->next ) {
    $user_result->lc_username( lc $user_result->username );
    $user_result->update;
  }

  my $projects_rs = $schema->resultset('Project');

  while ( my $project_Result = $projects_rs->next ) {
    $project_result->lc_name( lc $project_result->name );
    $project_result->update;
  }
});
