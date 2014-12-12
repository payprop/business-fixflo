package Business::Fixflo::Resource;

=head1 NAME

Business::Fixflo::Resource

=head1 DESCRIPTION

This is a base class for Fixflo resource classes, it implements common
behaviour. You shouldn't use this class directly, but extend it instead.

=cut

use Moo;
use Carp qw/ confess /;
use JSON ();

has client => (
    is       => 'ro',
    isa      => sub {
        confess( "$_[0] is not a Business::Fixflo::Client" )
            if ref $_[0] ne 'Business::Fixflo::Client'
    },
    required => 1,
);

has [ qw/ url / ] => (
    is      => 'rw',
	lazy    => 1,
	default => sub {
		my ( $self ) = @_;
        return join(
			'/',
			$self->client->base_url . $self->client->api_path,
			( split( ':',ref( $self ) ) )[-1],
			$self->Id
		);
	},
);

sub to_hash {
    my ( $self ) = @_;

    my %hash = %{ $self };
    delete( $hash{client} );
    return %hash;
}

sub to_json {
    my ( $self ) = @_;
    return JSON->new->canonical->encode( { $self->to_hash } );
}

sub get {
	my ( $self ) = @_;

	my $data = $self->client->api_get( $self->url );

	foreach my $attr ( keys( %{ $data } ) ) {
		$self->$attr( $data->{$attr} );
	}

	return $self;
}

1;

# vim: ts=4:sw=4:et
