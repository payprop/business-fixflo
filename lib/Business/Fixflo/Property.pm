package Business::Fixflo::Property;

=head1 NAME

Business::Fixflo::Property

=head1 DESCRIPTION

A class for a fixflo property, extends L<Business::Fixflo::Resource>

=cut

use Moo;
use Business::Fixflo::Exception;
use Business::Fixflo::Paginator;
use Business::Fixflo::Address;
use Business::Fixflo::PropertyAddress;

extends 'Business::Fixflo::Resource';

=head1 ATTRIBUTES

    Id
    ExternalPropertyRef
    PropertyAddressId
    Address
    Addresses
    Issues

=cut

use Carp qw/ confess /;

has [ qw/
    Id
    ExternalPropertyRef
    PropertyAddressId
/ ] => (
    is => 'rw',
);

has 'PropertyId' => (
    is      => 'rw',
    lazy    => 1,
    default => sub { shift->Id || 0 },
);

has 'Address' => (
    is   => 'rw',
    isa  => sub {
        confess( "$_[0] is not a Business::Fixflo::Address" )
            if ref $_[0] ne 'Business::Fixflo::Address';
    },
    lazy   => 1,
    coerce => sub {
        $_[0] = Business::Fixflo::Address->new( $_[0] )
            if ref( $_[0] ) ne 'Business::Fixflo::Address';
        return $_[0];
    },
);

has 'Addresses' => (
    is      => 'rw',
    lazy    => 1,
    default => sub {
        my ( $self ) = @_;

        my $addresses = $self->client->api_get(
            "Property/@{[ $self->Id ]}/Addresses",
        );

        my $Paginator = Business::Fixflo::Paginator->new(
            links  => {
                next     => $addresses->{NextURL},
                previous => $addresses->{PreviousURL},
            },
            client  => $self->client,
            class   => 'Business::Fixflo::PropertyAddress',
            objects => [ map { Business::Fixflo::PropertyAddress->new(
                client => $self->client,
                %{ $_ },
            ) } @{ $addresses->{Items} } ],
        );

        return $Paginator;
    },
);

has 'Issues' => (
    is      => 'rw',
    lazy    => 1,
    default => sub {
        my ( $self ) = @_;

        my $issues = $self->client->api_get(
            "Property/@{[ $self->Id ]}/Issues",
        );

        my $Paginator = Business::Fixflo::Paginator->new(
            links  => {
                next     => $issues->{NextURL},
                previous => $issues->{PreviousURL},
            },
            client  => $self->client,
            class   => 'Business::Fixflo::Issue',
            objects => [ map { Business::Fixflo::Issue->new(
                client => $self->client,
                %{ $_ },
            ) } @{ $issues->{Items} } ],
        );

        return $Paginator;
    },
);

=head1 Operations on a property

=head2 get

Gets a property based on either the ExternalPropertyRef or the PropertyId
(ExternalPropertyRef is favoured if this is set)

=head2 create

Creates a property in the Fixflo API

=head2 update

Updates a property in the Fixflo API - will throw an exception if the PropertyId
is not set

=cut

sub create {
    my ( $self,$update ) = @_;

    if ( ! $update && $self->Id ) {
        Business::Fixflo::Exception->throw({
            message  => "Can't create Property when Id is already set",
        });
    } elsif ( $update && ! $self->Id ) {
        Business::Fixflo::Exception->throw({
            message  => "Can't update Property if Id is not set",
        });
    }

    $self->PropertyId or $self->PropertyId( 0 );

    my $post_data = { $self->to_hash };
    $post_data->{Address} = { $post_data->{Address}->to_hash }
        if $post_data->{Address};

    # as per the Fixflo API docs - when creating a property we must POST
    # using the PropertyId of 0 (zero, which PropertyId will default to)
    return $self->_parse_envelope_data(
        $self->client->api_post( 'Property',$post_data )
    );
}

sub get {
	my ( $self ) = @_;

	my $data = $self->client->api_get( $self->ExternalPropertyRef
        ? ( 'Property',$self->_params )
        : ( "Property/".$self->Id )
    );

	foreach my $attr ( keys( %{ $data } ) ) {
		$self->$attr( $data->{$attr} );
	}

	return $self;
}

sub update {
    my ( $self ) = @_;
    return $self->create( 'update' );
}

sub _params {
    my ( $self ) = @_;

    return $self->ExternalPropertyRef
        ? { 'ExternalPropertyRef' => $self->ExternalPropertyRef }
        : { 'PropertyId'          => $self->Id };
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
