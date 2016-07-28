#! /usr/bin/env perl

use strict;
use warnings;

use FindBin qw/ $Bin /;
use lib "$Bin/../lib";

BEGIN {
  package My::Schema::Script::Migration;

  use Moo;
  use MooX::Options;
  use Module::Runtime qw/ use_module /;
  use DBIx::Class::Fixtures;

  option to_con => (
    is       => 'ro',
    format   => 's',
    required => 1,
    doc      => "The connection you are migrating data to",
  );

  option from_con => (
    is       => 'ro',
    format   => 's',
    required => 1,
    doc      => "The connection you are migrating data from",
  );

  option schema_class => (
    is => 'ro',
    format => 's',
    required => 1,
    doc => "The DBIC schema to use for the migration",
  );

  has to_schema => (
    is      => 'lazy',
    builder => sub {
      my $self = shift;
      my $connection = $self->to_con;
      $connection =~ s/username=(.*?);//; my $user = $1;
      $connection =~ s/password=(.*?);//; my $pass = $1;
      return use_module( $self->schema_class )->connect(
        $connection,
        $user,
        $pass,
        { quote_names => 1 },
      );
    },
  );

  has from_schema => (
    is      => 'lazy',
    builder => sub {
      my $self = shift;
      my $connection = $self->from_con;
      $connection =~ s/username=(.*?);//; my $user = $1;
      $connection =~ s/password=(.*?);//; my $pass = $1;
      return use_module( $self->schema_class )->connect(
        $connection,
        $user,
        $pass,
        { quote_names => 1 },
      );
    },
  );

  sub BUILD {
    my $self = shift;
    print "Migrating data\n\n";
    print "From Con: " . $self->from_con . "\n";
    print "To Con: " . $self->to_con . "\n\n";

    print "Getting sorted array of sources...\n";
    my @sorted_sources = DBIx::Class::Fixtures::_get_sorted_sources( undef, $self->from_schema );

    print "Migrating Data from Source:\n";
    $self->to_schema->storage->with_deferred_fk_checks( sub {
      for my $source_name ( @sorted_sources ) {
        print "    $source_name ... ";
        my $from_rs = $self->from_schema->resultset($source_name);
        $from_rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
        my $to_rs = $self->to_schema->resultset($source_name);
        while ( my $from_result = $from_rs->next ) { $to_rs->find_or_create( $from_result ); }
        print "Done\n";
      }
    });
  }
}

My::Schema::Script::Migration->new_with_options;
