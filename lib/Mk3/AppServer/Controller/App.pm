package Mk3::AppServer::Controller::App;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Mk3::AppServer::Controller::App - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
  my ( $self, $c ) = @_;

  $c->response->redirect( $c->uri_for( '/apps' ) );
}

sub apps :Path('/apps') :Args(0) {
  my ( $self, $c ) = @_;

  my $app_where_clause = {
    'latest_allowed_version' => { '!=' => undef },
  };

  if ( $c->user_exists ) {
    $app_where_clause = {
      '-or' => {
        'user_id' => $c->user->id,
        %$app_where_clause,
      }
    };
  }

  my $apps_rs = $c->model( 'DB::Project' )->search(
    $app_where_clause,
    {
      order_by => { -asc => 'lc_name' },
    },
  );

  $c->stash( apps_rs => $apps_rs );
}

sub add :Local :Args(0) {
  my ( $self, $c ) = @_;

  my $app_name = $c->req->body_params->{ app_name };

  if ( $c->user_exists ) {
    unless( $app_name =~ /^[\w\-]+$/ ) {
      $c->stash(
        error => "App name can only contain alphanumeric characters, '-' and '_'",
        app_name => $app_name,
      );
    } elsif ( length $app_name > 15 ) {
      $c->stash(
        error => "App name must be 15 characters or less",
        app_name => $app_name,
      );
    } elsif ( $c->user->projects->find({ lc_name => lc $app_name }) ) {
      $c->stash(
        error => 'App Already Exists',
        app_name => $app_name,
      );
    } else {
      my $lc_name = lc $app_name;
      $lc_name =~ s/ /-/g;
      $c->user->create_related(
        'projects',
        {
          name => $app_name,
          lc_name => $lc_name,
          description => '',
        }
      );
      $c->res->redirect(
        $c->uri_for(
          sprintf( '/app/%s/%s', $c->user->lc_username, $lc_name )
        )
      );
    }
  } else {
    $c->stash( error => 'You cannot create an app when not logged in' );
  }
}

sub category :Local :Args(0) {
  my ( $self, $c ) = @_;

  my $app_id = $c->req->body_params->{ app_id };
  my $category_id = $c->req->body_params->{ category_id };

  if ( $c->user_exists ) {
    my $app_result = $c->model('DB::Project')->find( $app_id );
    my $category_result = $c->model('DB::Category')->find( $category_id );
    unless ( defined $app_result ) {
      $c->stash(
        error => 'App does not exist',
        template => 'error.tt',
      );
    } elsif ( ! defined $category_result ) {
      $c->stash(
        error => 'Category does not exist',
        template => 'error.tt',
      );
    } elsif ( $c->user->id == $app_result->user_id || $c->check_user_roles('admin') ) {
      $app_result->update({ category_id => $category_result->id });
      $c->res->redirect(
        $c->uri_for(
          sprintf( '/app/%s/%s', $app_result->user->lc_username, $app_result->lc_name )
        )
      );
    }
  } else {
    $c->stash(
      error => 'You cannot set a category when not logged in',
      template => 'error.tt',
    );
  }
}

sub chain_root :Chained(/) :PathPart('app') :CaptureArgs(0) {
  my ( $self, $c ) = @_;

}

sub chain_user :Chained('chain_root') :PathPart('') :CaptureArgs(1) {
  my ( $self, $c, $username ) = @_;

  my $user_result = $c->model( 'DB::User' )->find({ lc_username => $username });
  if ( defined $user_result ) {
    my $owner_flag = 0;
    if ( $c->user_exists ) {
      $owner_flag = $c->user->id eq $user_result->id ? 1 : 0;
    }
    $c->stash(
      user_result => $user_result,
      owner => $owner_flag,
    );
  } else {
    $c->stash(
      template => 'error.tt',
      error => 'That user does not exist',
    );
    $c->res->status(404);
  }
}

sub end_user :Chained('chain_root') :PathPart('') :Args(1) {
  my ( $self, $c, $username ) = @_;

  $self->chain_user( $c, $username );
  if ( defined ( my $user_result = $c->stash->{ user_result } ) ) {
    my $where_clause = $c->stash->{ owner }
      ? undef
      : { latest_allowed_version => { '!=' => undef } };
    $c->stash(
      apps_rs => $user_result->search_related_rs( 'projects', $where_clause,
        { order_by => { -asc => 'lc_name' } }
      ),
    );
  }
}

sub chain_app :Chained('chain_user') :PathPart('') :CaptureArgs(1) {
  my ( $self, $c, $appname ) = @_;

  my $app_result = $c->stash->{ user_result }->projects->find({ lc_name => $appname });
  if ( defined $app_result ) {
    $c->stash( app_result => $app_result );
  } else {
    $c->stash(
      template => 'error.tt',
      error => 'That app does not exist',
    );
    $c->res->status(404);
  }
}

sub end_app :Chained('chain_user') :PathPart('') :Args(1) {
  my ( $self, $c, $appname ) = @_;

  $self->chain_app( $c, $appname );
  if ( defined ( my $app_result = $c->stash->{ app_result } ) ) {
    my $where_clause = $c->stash->{ owner }
      ? undef
      : { status => 'allowed' };
    my $versions_rs = $app_result->search_related_rs(
      'versions',
      $where_clause,
      { order_by => { -desc => 'version' } },
    );
    my $categories_rs = $c->model('DB::Category')->search(
      { id => { '!=' => 0 } },
      { order_by => { -asc => 'name' } }
    );
    $c->stash(
      versions_rs => $versions_rs,
      categories_rs => $categories_rs
    );
  }
}

sub chain_version :Chained('chain_app') :PathPart('') :CaptureArgs(1) {
  my ( $self, $c, $version ) = @_;

  if ( defined ( my $app_result = $c->stash->{ app_result } ) ) {
    my $version_result = $app_result->search_related_rs(
      'versions',
      { version => $version },
    )->first;
    if ( defined $version_result ) {
      $c->stash(
        version_result => $version_result,
      );
    } else {
      $c->stash(
        template => 'error.tt',
        error => 'Version does not exist for this app',
      );
    }
  }
}

sub end_version :Chained('chain_app') :PathPart('') :Args(1) {
  my ( $self, $c, $version ) = @_;

  $self->chain_version( $c, $version );
  if ( defined ( my $version_result = $c->stash->{ version_result } ) ) {
    my $files_rs = $version_result->search_related_rs(
      'files',
      undef,
      { order_by => { -asc => 'filename' } },
    );
    $c->stash( files_rs => $files_rs );
  }
}

sub edit_desc_get :Chained('chain_app') :PathPart('edit_desc') :Args(0) GET {
  my ( $self, $c, $version ) = @_;

  unless ( $c->stash->{ owner } ) {
    $c->res->redirect( $self->app_url( $c ) );
  }
}

sub edit_desc_post :Chained('chain_app') :PathPart('edit_desc') :Args(0) POST {
  my ( $self, $c, $version ) = @_;

  if ( $c->stash->{ owner } ) {
    my $description = $c->req->body_data->{ desc };
    $c->stash->{ app_result }->description( $description );
    $c->stash->{ app_result }->update;
  }

  $c->res->redirect( $self->app_url( $c ) );
}

sub app_url {
  my ( $self, $c ) = @_;

  return $c->uri_for( sprintf(
    '/app/%s/%s',
    $c->stash->{ user_result }->lc_username,
    $c->stash->{ app_result }->lc_name,
  ));
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
