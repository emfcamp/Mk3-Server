package Mk3::AppServer::Controller::API::Admin::Badge;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Mk3::AppServer::Controller::API::Admin::Badge - Catalyst Controller

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
    message => 'Access Granted',
  });
}

sub add :Local :Args(0) POST {
  my ( $self, $c ) = @_;

  my $badge_id = $c->req->body_data->{ badge_id };
  my $secret = $c->req->body_data->{ secret };

  my $badge_rs = $c->model( 'DB::Badge' );

  unless ( defined $badge_rs->find({ badge_id => $badge_id }) ) {
    $badge_rs->create({
      badge_id => $badge_id,
      secret   => $secret,
    });
    $c->stash( json => { success => \1, badge_id => $badge_id, secret => $secret });
  } else {
    $c->stash( json => { success => \0, message => "badge id already exists" });
    $c->res->status( 404 );
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
