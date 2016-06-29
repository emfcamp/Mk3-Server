#! /usr/bin/env perl

use strict;
use warnings;

use FindBin qw/ $Bin /;
use lib "$Bin/../lib";

use Mk3::AppServer::Schema::Script::Deployment;

Mk3::AppServer::Schema::Script::Deployment->new_with_actions(
  schema_class => 'Mk3::AppServer::Schema',
);
