package Mk3::AppServer::Controller::API::BARMS;
use Moose;
use LWP::UserAgent;
use JSON::MaybeXS qw/ encode_json /;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Mk3::AppServer::Controller::API::BARMS - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

has _ua => (
  is => 'ro',
  default => sub {
    return LWP::UserAgent->new;
  },
);

has endpoint => (
  is => 'ro',
);

=head2 index

=cut

sub index :Path :Args(0) {
  my ( $self, $c ) = @_;

  my $data = $c->req->body_data;
  my $success = \0;

  if ( defined $self->endpoint ) {
    my $response = $self->_ua->post(
      $self->endpoint,
      'Content-Type' => 'application/json',
      Content => encode_json( $data ),
    );
    
    if ( $response->code == 201 ) {
      $success = \1,
    }
  }

  $c->stash( json => {
    success => $success,
    message => 'Data Recieved',
    data => $data,
  });
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
