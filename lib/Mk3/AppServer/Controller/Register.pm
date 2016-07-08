package Mk3::AppServer::Controller::Register;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Mk3::AppServer::Controller::Register - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) :GET {
  my ( $self, $c ) = @_;

}

sub register_post :Path :Args(0) POST {
  my ( $self, $c ) = @_;

  my $username   = $c->request->body_data->{username};
  my $email      = $c->request->body_data->{email};
  my $password   = $c->request->body_data->{password};
  my $pass_check = $c->request->body_data->{pass_check};

  my $user_rs = $c->model('DB::User');

  unless ( $username =~ /^\w*$/ ) {
    $c->stash(
      error => 'Username contains invalid characters, only alphanumeric and \'_\' allowed.',
      username => $username,
      email => $email,
      template => 'register/index.tt',
    );
  } elsif ( $user_rs->find({ username => $username }) ) {
    $c->stash(
      error    => 'Username already exists',
      username => $username,
      email    => $email,
      template => 'register/index.tt',
    );
  } elsif ($user_rs->find({ email => $email }) ) {
    $c->stash(
      error    => 'Email already exists',
      username => $username,
      email    => $email,
      template => 'register/index.tt',
    );
  } elsif ( $password ne $pass_check ) {
    $c->stash(
      error    => 'Passwords do not Match',
      username => $username,
      email    => $email,
      template => 'register/index.tt',
    );
  } else {
    $user_rs->create({
      username => $username,
      lc_username => lc $username,
      email    => $email,
      password => $password,
    });
    $c->res->redirect( $c->uri_for( '/' ) );
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
