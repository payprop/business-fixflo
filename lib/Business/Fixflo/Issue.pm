package Business::Fixflo::Issue;

=head1 NAME

Business::Fixflo::Issue

=head1 DESCRIPTION

A class for a fixflo issue, extends L<Business::Fixflo::Resource>

=cut

use Moo;

extends 'Business::Fixflo::Resource';

use Business::Fixflo::Property;

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
	Property
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

=head2 property

Returns the L<Business::Fixflo::Property> associated with the issue

    my $Property = $issue->property;

=cut

sub property {
    my ( $self ) = @_;

    $self->get if ! $self->Property;

    if ( my $property = $self->Property ) {
        return Business::Fixflo::Property->new(
            client => $self->client,
            %{ $property },
        );
    }

    return undef;
}

1;

# vim: ts=4:sw=4:et
