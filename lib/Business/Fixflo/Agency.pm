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
    DefaultTimeZoneId
    Locale
    Password
    ApiKey
    TermsAcceptanceUrl
    TermsAcceptanceDate

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
    DefaultTimeZoneId
    Locale
    Password
    ApiKey
    TermsAcceptanceUrl
    TermsAcceptanceDate
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

=head2 undelete

Undeletes an agency in the Fixflo API - will throw an exception if the Id
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

sub update {
    my ( $self ) = @_;
    return $self->create( 'update' );
}

sub delete {
    my ( $self,$undelete ) = @_;

    $undelete //= 'delete';

    if ( ! $self->Id ) {
        Business::Fixflo::Exception->throw({
            message  => "Can't $undelete Agency if Id is not set",
        });
    }

    $self->_parse_envelope_data(
        # implemented as POST rather than DELETE as DELETE with content
        # is a contentious issue in API design (and also webservers).
        # the fixflo API says call to DELETE Agency/{Id} should include
        # a content body with an Id matching the Id in the URL, but they
        # also offer delete via POST - so we are using the POST here
        $self->client->api_post( $self->url_no_id . "/$undelete",{ $self->to_hash } )
    );

    $self->IsDeleted( $undelete eq 'undelete' ? 0 : 1 );

    return $self;
}

sub undelete {
    my ( $self ) = @_;
    return $self->delete( 'undelete' );
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
