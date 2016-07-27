package Mk3::AppServer::Controller::Admin::Category;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Mk3::AppServer::Controller::Admin::Category - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
  my ( $self, $c ) = @_;

  my $categories_rs = $c->model('DB::Category');

  $c->stash( categories_rs => $categories_rs );
}

sub add :Local :Args(0) {
  my ( $self, $c ) = @_;

  my $category_name = $c->req->body_params->{ cat_name };
  $self->index( $c );

  unless ( $category_name =~ /^[\w\-]+$/ ) {
    $c->stash(
      error => "Category name can only contain Alphanumeric characters and '-'",
      cat_name => $category_name,
    );
  } elsif ( length $category_name > 25 ) {
    $c->stash(
      error => "Category name must be 25 characters or less",
      cat_name => $category_name,
    );
  } else {
    my $category_result = $c->model('DB::Category')->find_or_new(
      { name => $category_name },
    );
    if ( $category_result->in_storage ) {
      $c->stash(
        error => "Category [$category_name] already exists!",
        cat_name => $category_name,
      );
    } else {
      $category_result->insert;
      $c->stash(
        message => "Successfully added new category: $category_name",
      );
    }
  }

  $c->stash( template => 'admin/category/index.tt' );
}

sub delete :Local :Args(1) {
  my ( $self, $c, $id ) = @_;

  my $category_result = $c->model('DB::Category')->find( $id );
  $self->index( $c );

  if ( $id == 0 ) {
    $c->stash( error => "You cannot delete uncategorised" );
  } elsif ( defined $category_result ) {
    $category_result->projects->update({ category_id => undef });
    $category_result->delete;
    $c->stash( message => "Successfully deleted category: " . $category_result->name );
  } else {
    $c->stash( error => "No category with that id" );
  }

  $c->stash( template => 'admin/category/index.tt' );
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
