package Business::Fixflo::Issue;

=head1 NAME

Business::Fixflo::Issue

=head1 DESCRIPTION

A class for a fixflo issue, extends L<Business::Fixflo::Resource>

=cut

use Moo;

extends 'Business::Fixflo::Resource';

=head1 ATTRIBUTES

	Address
	CallbackId
	ContactNumber
	Created
	DirectEmailAddress
	DirectMobileNumber
	EmailAddress
	FaultCategory
	FaultNotes
	FaultPriority
	FaultTitle
	Firstname
	Id
	Media
	Salutation
	Status
	StatusChanged
	Surname
	TenantAcceptComplete
	TenantId
	TenantNotes
	TenantPresenceRequested
	TermsAccepted
	Title

=cut

has [ qw/
	Address
	CallbackId
	ContactNumber
	Created
	DirectEmailAddress
	DirectMobileNumber
	EmailAddress
	FaultCategory
	FaultNotes
	FaultPriority
	FaultTitle
	Firstname
	Id
	Media
	Salutation
	Status
	StatusChanged
	Surname
	TenantAcceptComplete
	TenantId
	TenantNotes
	TenantPresenceRequested
	TermsAccepted
	Title
/ ] => (
    is => 'rw',
);

=head1 Operations on an issue

=head2 report

Returns the report content (binary, pdf)

    my $pdf_report = $issue->report;

=cut

sub report {
	my ( $self ) = @_;
	return $self->client->api_get( join( '/',$self->url,'Report' ) );
}

1;

# vim: ts=4:sw=4:et
