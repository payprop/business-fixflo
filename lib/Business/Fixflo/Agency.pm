package Business::Fixflo::Agency;

=head1 NAME

Business::Fixflo::Agency

=head1 DESCRIPTION

A class for a fixflo agency, extends L<Business::Fixflo::Resource>

=cut

use Moo;
use Business::Fixflo::Exception;
use Business::Fixflo::Envelope;

extends 'Business::Fixflo::Resource';

=head1 ATTRIBUTES

    AgencyName
    Created
    CustomDomain
    EmailAddress
    FeatureType
    Id
    IsDeleted
    IssueTreeRoot
    SiteBaseUrl

=cut

has [ qw/
    AgencyName
    Created
    CustomDomain
    EmailAddress
    FeatureType
    Id
    IsDeleted
    IssueTreeRoot
    SiteBaseUrl
/ ] => (
    is => 'rw',
);

=head1 Operations on an agency

=head2 create

Creates an agency in the Fixflo API - will throw an exception if the Id
is already set

=head2 update

Updates an agency in the Fixflo API - will throw an exception if the Id
is not set

=head2 delete

Deletes an agency in the Fixflo API - will throw an exception if the Id
is not set

=cut

sub create {
    my ( $self,$update ) = @_;

    if ( ! $update && $self->Id ) {
        Business::Fixflo::Exception->throw({
            message  => "Can't create Agency when Id is already set",
        });
    } elsif ( $update && ! $self->Id ) {
        Business::Fixflo::Exception->throw({
            message  => "Can't update Agency if Id is not set",
        });
    }

    return $self->_parse_envelope_data(
        $self->client->api_post( 'Agency',{ $self->to_hash } )
    );
}

sub _parse_envelope_data {
    my ( $self,$data ) = @_;

    return $self if ! ref( $data );

    my $Envelope = Business::Fixflo::Envelope->new(
        client => $self->client,
        %{ $data }
    );

	foreach my $attr ( keys( %{ $Envelope->Entity // {} } ) ) {
		$self->$attr( $Envelope->Entity->{$attr} );
	}

    return $self;
}

sub update {
    my ( $self ) = @_;
    return $self->create( 'update' );
}

sub delete {
    my ( $self ) = @_;

    if ( ! $self->Id ) {
        Business::Fixflo::Exception->throw({
            message  => "Can't delete Agency if Id is not set",
        });
    }

    $self->_parse_envelope_data(
        $self->client->api_delete( $self->url,{ $self->to_hash } )
    );

    $self->IsDeleted( 1 );

    return $self;
}

=head1 AUTHOR

Lee Johnson - C<leejo@cpan.org>

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. If you would like to contribute documentation,
features, bug fixes, or anything else then please raise an issue / pull request:

    https://github.com/leejo/business-fixflo

=cut

1;

# vim: ts=4:sw=4:et
