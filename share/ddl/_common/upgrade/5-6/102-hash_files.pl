#!perl
 
use strict;
use warnings;

use File::Spec;

use DBIx::Class::DeploymentHandler::DeployMethod::SQL::Translator::ScriptHelpers
   'schema_from_schema_loader';
 
schema_from_schema_loader({ naming => 'v7' }, sub {
  my $schema = shift;

  print "Storage Path Directory?\n";
  my $path = readline(STDIN);
  chomp $path;

  my $files_rs = $schema->resultset('File');
  while ( my $file_result = $files_rs->next ) {
    my $file = File::Spec->catfile( $path, $file_result->file );
    $file_result->file_hash( Digest::SHA->new(256)->addfile($file)->hexdigest );
    $file_result->update;
  }
});
