package Business::Fixflo::Issue;

=head1 NAME

Business::Fixflo::Issue

=head1 DESCRIPTION

A class for a fixflo issue, extends L<Business::Fixflo::Resource>

=cut

use Moo;

extends 'Business::Fixflo::Resource';

has [ qw/
	CallbackId
	FaultTitle
	TermsAccepted
	TenantNotes
	Address
	Id
	Firstname
	EmailAddress
	DirectEmailAddress
	DirectMobileNumber
	TenantId
	TenantPresenceRequested
	TenantAcceptComplete
	Salutation
	Surname
	Title
	Status
	FaultCategory
	Media
	FaultPriority
	Created
	FaultNotes
	ContactNumber
	StatusChanged
/ ] => (
    is => 'rw',
);

sub report {
	my ( $self ) = @_;
	return $self->client->api_get( join( '/',$self->url,'Report' ) );
}

1;

# vim: ts=4:sw=4:et
