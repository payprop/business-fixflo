package Business::Fixflo::Paginator;

use Moo;
use JSON ();

use Business::Fixflo::Issue;

has [ qw/ client objects class links / ] => (
    is => 'rw'
);

sub next {
    my ( $self ) = @_;

    if ( my @objects = @{ $self->objects // [] } ) {
        # get the next chunk and return the current chunk
        $self->objects( $self->_objects_from_page( 'next' ) );
        return @objects;
    }

    return;
}

sub previous {
    my ( $self ) = @_;
    return @{ $self->_objects_from_page( 'previous' ) };
}

sub _objects_from_page {

    my ( $self,$page ) = @_;

    # see if we have more data to get
    if ( my $url = $self->links->{$page} ) {

        my $data    = $self->client->api_get( $url );
        my $class   = $self->class;

        my @objects = map {
			$class->new(
				client => $self->client,
				url    => $_,
			)
		} @{ $data->{Items} };

        $self->links({
            next     => $data->{NextURL},
            previous => $data->{PreviousURL},
		});

        return [ @objects ];
    }

    return [];
}

1;

# vim: ts=4:sw=4:et
