#!perl
 
use strict;
use warnings;
 
use DBIx::Class::DeploymentHandler::DeployMethod::SQL::Translator::ScriptHelpers
   'schema_from_schema_loader';
 
schema_from_schema_loader({ naming => 'v7' }, sub {
  my $schema = shift;
 
  my $projects_rs = $schema->resultset('Project');
  while ( my $project_result = $projects_rs->next ) {
    my $latest_allowed_version = $project_result->search_related(
      'versions',
      { status => 'allowed' },
      { order_by => { -desc => 'version' } },
    )->first;

    if ( defined $latest_allowed_version ) {
      $project_result->latest_allowed_version( $latest_allowed_version->id );
      $project_result->update;
    }
  }
});
