package Business::Fixflo::Client;

=head1 NAME

Business::Fixflo::Client

=head1 DESCRIPTION

This is a class for the lower level requests to the fixflo API. generally
there is nothing you should be doing with this.

=cut

use Moo;
with 'Business::Fixflo::Utils';
with 'Business::Fixflo::Version';

use Business::Fixflo::Exception;

use Carp qw/ confess /;
use POSIX qw/ strftime /;
use MIME::Base64 qw/ encode_base64 /;
use LWP::UserAgent;
use JSON ();

=head1 ATTRIBUTES

=cut

has [ qw/ username password / ] => (
    is       => 'ro',
);

sub _api_request {
    my ( $self,$method,$path,$params ) = @_;

    my $ua = LWP::UserAgent->new;
    $ua->agent( $self->user_agent );

    my $req = HTTP::Request->new(
        # passing through the absolute URL means we don't build it
        $method => $path =~ /^http/
            ? $path : join( '/',$self->base_url . $self->api_path . $path ),
    );

    $req->header( 'Authorization' =>
        "basic "
        . encode_base64( join( ":",$self->username,$self->password ) )
    );
    $req->header( 'Accept' => 'application/json' );

    if ( $method =~ /POST|PUT/ ) {
      $req->content_type( 'application/x-www-form-urlencoded' );
      $req->content( $self->normalize_params( $params ) );
    }

    my $res = $ua->request( $req );

    if ( $res->is_success ) {
        my $data  = JSON->new->decode( $res->content );
        my $links = $res->header( 'link' );
        my $info  = $res->header( 'x-pagination' );
        return wantarray ? ( $data,$links,$info ) : $data;
    }
    else {
        Business::Fixflo::Exception->throw({
            message  => $res->content,
            code     => $res->code,
            response => $res->status_line,
        });
    }
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
