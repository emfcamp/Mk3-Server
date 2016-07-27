package Mk3::AppServer::Controller::API;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Mk3::AppServer::Controller::API - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
  my ( $self, $c ) = @_;

  $c->stash( json => {
    success => \1,
    message => 'Endpoint Working',
  });
}

sub apps :Local :Args(0) {
  my ( $self, $c ) = @_;

  my $apps_rs = $c->model('DB::Project');

  my $json = {};

  while ( my $app_result = $apps_rs->next ) {
    my $latest_version = $app_result->latest_version;

    if ( defined $latest_version ) {
      my $app_data = {
        user => $app_result->user->username,
        name => $app_result->name,
        description => $app_result->description,
        link => $c->uri_for( sprintf(
          '/api/app/%s/%s',
          $app_result->user->lc_username,
          $app_result->lc_name,
        ))->as_string,
      };
      push @{$json->{all}}, $app_data;
      push @{$json->{ $app_result->category->name }}, $app_data;
    }
  }

  $c->stash( json => $json );
}

sub app :Local :Args(2) {
  my ( $self, $c, $username, $appname ) = @_;

  my $user_result = $c->model('DB::User')->find({ lc_username => $username });

  if ( defined $user_result ) {
    my $app_result = $user_result->search_related( 'projects',
      { lc_name => $appname },
    )->first;

    if ( defined $app_result ) {
      my $version_result = $app_result->latest_version;

      if ( defined $version_result ) {
        my $json = {
          user => $user_result->username,
          name => $app_result->name,
          description => $app_result->description,
          files => [],
        };

        my $file_rs = $version_result->search_related_rs( 'files', undef );

        while ( my $file_result = $file_rs->next ) {
          push @{$json->{files}}, {
            file => $file_result->filename,
            hash => $file_result->file_hash,
            link => $c->uri_for( sprintf(
              '/app/%s/%s/%s/get/file/%s',
              $user_result->lc_username,
              $app_result->lc_name,
              $version_result->version,
              $file_result->filename,
            ))->as_string,
          };
        }

        $c->stash( json => $json );
      } else {
        $c->stash( json => { success => \0, message => "no available version" } );
        $c->res->status(404);
      }
    } else {
      $c->stash( json => { success => \0, message => "app does not exist" } );
      $c->res->status(404);
    }
  } else {
    $c->stash( json => { success => \0, message => "user does not exist" } );
    $c->res->status(404);
  }
}

# Forces all views in this namespace to be json endpoints.
sub end :Private {
  my ( $self, $c ) = @_;
  $c->res->content_type('application/json');
  $c->forward('View::JSON');
}

=encoding utf8

=head1 AUTHOR

Tom Bloor,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
