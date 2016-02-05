package Business::Fixflo::IssueDraft;

=head1 NAME

Business::Fixflo::IssueDraft

=head1 DESCRIPTION

A class for a fixflo issue draft, extends L<Business::Fixflo::Resource>

=cut

use Moo;

extends 'Business::Fixflo::Resource';
with 'Business::Fixflo::Utils';

use Business::Fixflo::Address;

=head1 ATTRIBUTES

    Address
    ContactNumber
    ContactNumberAlt
    Updated
    EmailAddress
    FaultId
    FaultNotes
    Firstname
    Id
    IssueDraftMedia
    IssueTitle
    Surname
    Title

=cut

has [ qw/
    Address
    ContactNumber
    ContactNumberAlt
    Updated
    EmailAddress
    FaultId
    FaultNotes
    Firstname
    Id
    IssueDraftMedia
    IssueTitle
    Surname
    Title
/ ] => (
    is => 'rw',
);

=head1 Operations on a issue draft

=head2 create

Creates an issue draft in the Fixflo API

=head2 update

Updates an issue draft in the Fixflo API - will throw an exception if the Id
is not set

=head2 commit

Commits the issue draft, returning a Business::Fixflo::Issue object

=head2 delete

Deletes the issue draft.

=cut

sub create {
    my ( $self,$update ) = @_;

    if ( ! $update && $self->Id ) {
        Business::Fixflo::Exception->throw({
            message  => "Can't create IssueDraft when Id is already set",
        });
    } elsif ( $update && ! $self->Id ) {
        Business::Fixflo::Exception->throw({
            message  => "Can't update IssueDraft if Id is not set",
        });
    }

    $self->Id or $self->Id( 0 );

    my $post_data = { $self->to_hash };
    $post_data->{Address} = { $self->Address->to_hash }
        if $self->Address;

    return $self->_parse_envelope_data(
        $self->client->api_post( 'IssueDraft',$post_data )
    );
}

sub update {
    my ( $self ) = @_;
    return $self->create( 'update' );
}

sub commit {
    my ( $self ) = @_;

    Business::Fixflo::Exception->throw({
        message  => "Can't commit IssueDraft if Id is not set",
    }) if ! $self->Id;

    my $post_data = { Id => $self->Id };

    return Business::Fixflo::Issue->new(
        client => $self->client,
    )->_parse_envelope_data(
        $self->client->api_post( 'IssueDraft/Commit',$post_data )
    );
}

sub delete {
    my ( $self ) = @_;

    Business::Fixflo::Exception->throw({
        message  => "Can't delete IssueDraft if Id is not set",
    }) if ! $self->Id;

    my $post_data = { Id => $self->Id };

    return $self->_parse_envelope_data(
        $self->client->api_post( 'IssueDraft/Delete',$post_data )
    );
}

=head1 AUTHOR

Lee Johnson - C<leejo@cpan.org>

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. If you would like to contribute documentation,
features, bug fixes, or anything else then please raise an issue / pull request:

    https://github.com/G3S/business-fixflo

=cut

1;

# vim: ts=4:sw=4:et
