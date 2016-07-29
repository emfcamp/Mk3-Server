package Mk3::AppServer::Controller::Login;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Mk3::AppServer::Controller::Login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) GET {
  my ( $self, $c ) = @_;

  if ( $c->user_exists ) {
    $c->res->redirect( $c->uri_for( '/' ) );
  }
}

sub login_post :Path :Args(0) POST {
  my ( $self, $c ) = @_;

  my $username = $c->request->body_data->{username};
  my $password = $c->request->body_data->{password};

  if ( $c->authenticate({ username => $username, password => $password }) ) {
    $c->user->set_password_code(undef);
    $c->user->update;
    $c->res->redirect( $c->uri_for( '/' ) );
  } else {
    $c->stash( error => 'Unrecognised Username/Password' );
    $c->stash( template => 'login/index.tt' );
  }
}

sub forgot_pass :Local :Args(0) {
  my ( $self, $c ) = @_;

}

sub forgot_pass_post :Path('forgot_pass') :Args(0) POST {
  my ( $self, $c ) = @_;

  my $username = $c->req->body_data->{ username };
  my $user_result = $c->model('DB::User')->find({ username => $username });

  if ( defined $user_result ) {
    my $code = $user_result->create_password_code;

    $c->stash( set_url => $c->uri_for( '/login/set/' . $code ) );
    $c->stash( email => {
      to => $user_result->email,
      from => $c->config->{ forgot_pass_email }->{ from_address },
      subject => 'Tilde Mk3 Apps Server Password Reset',
      template => 'forgot_pass.tt',
    });
    $c->forward('View::Email');
  }

  $c->stash( message => 'An email has been sent to your registered address' );
  $c->stash( template => 'login/forgot_pass.tt' );
}

sub set :Local :Args(1) {
  my ( $self, $c, $code ) = @_;

  my $user_result = $c->model('DB::User')->find({ set_password_code => $code });

  if ( defined $user_result ) {
    $c->stash( set_code => $code );
  } else {
    $c->res->redirect( $c->uri_for( '/login' ) );
  }
}

sub set_pass :Local :Args(0) POST {
  my ( $self, $c ) = @_;

  my $code = $c->req->body_data->{ set_code };
  my $new_pass = $c->req->body_data->{ new_pass };
  my $new_pass2 = $c->req->body_data->{ new_pass2 };

  my $user_result = $c->model('DB::User')->find({ set_password_code => $code });

  if ( defined $user_result ) {
    if ( $new_pass eq $new_pass2 ) {
      $user_result->set_new_password( $new_pass );
      $c->res->redirect( $c->uri_for( '/login' ) );
    } else {
      $c->stash(
        set_code => $code,
        error => 'Passwords do not match',
        template => 'login/set.tt'
      );
    }
  } else {
    $c->res->redirect( $c->uri_for( '/login' ) );
  }
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
