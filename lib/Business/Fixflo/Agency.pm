package Business::Fixflo::Agency;

=head1 NAME

Business::Fixflo::Agency

=head1 DESCRIPTION

A class for a fixflo issue, extends L<Business::Fixflo::Resource>

=cut

use Moo;

extends 'Business::Fixflo::Resource';

has [ qw/
    Id
    AgencyName
    CustomDomain
    EmailAddress
    IsDeleted
    Created
    FeatureType
    IssueTreeRoot
    SiteBaseUrl
/ ] => (
    is => 'rw',
);

sub create {
    my ( $self ) = @_;
    return $self->client->api_post( 'Agency',{ $self->to_hash } );
}

sub delete {
    my ( $self ) = @_;
    return $self->client->api_delete( 'Agency',{ $self->to_hash } );
}

1;

# vim: ts=4:sw=4:et
