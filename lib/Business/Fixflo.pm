package Business::Fixflo;

=head1 NAME

Business::Fixflo - Perl library for interacting with the Fixflo API
(https://fixflo.com)

=for html
<a href='https://travis-ci.org/leejo/business-fixflo?branch=master'><img src='https://travis-ci.org/leejo/business-fixflo.svg?branch=master' alt='Build Status' /></a>
<a href='https://coveralls.io/r/leejo/business-fixflo?branch=master'><img src='https://coveralls.io/repos/leejo/business-fixflo/badge.png?branch=master' alt='Coverage Status' /></a>

=head1 VERSION

0.01

=head1 DESCRIPTION

Business::Fixflo is a library for easy interface to the fixflo property
repair service, it implements most of the functionality currently found
in the service's API documentation: http://www.fixflo.com/Tech/WebAPI

B<You should refer to the official fixflo API documentation in conjunction>
B<with this perldoc>, as the official API documentation explains in more depth
some of the functionality including required / optional parameters for certain
methods.

=head1 SYNOPSIS

=head1 ERROR HANDLING

Any problems or errors will result in a Business::Fixflo::Exception
object being thrown, so you should wrap any calls to the library in the
appropriate error catching code (TryCatch in the below example):

    use TryCatch;

    try {
    }
    catch ( Business::Fixflo::Exception $e ) {
        # error specific to Business::Fixflo
        ...
        say $e->message;  # error message
        say $e->code;     # HTTP status code
        say $e->response; # HTTP status message
    }
    catch ( $e ) {
        # some other failure?
        ...
    }

=head1 PAGINATION

=cut

use Moo;
with 'Business::Fixflo::Version';

use Carp qw/ confess /;

use Business::Fixflo::Client;

=head1 ATTRIBUTES

=cut

has [ qw/ username password custom_domain / ] => (
    is       => 'ro',
    required => 1,
);

has client => (
    is       => 'ro',
    isa      => sub {
        confess( "$_[0] is not a Business::Fixflo::Client" )
            if ref $_[0] ne 'Business::Fixflo::Client'
    },
    required => 0,
    lazy     => 1,
    default  => sub {
        my ( $self ) = @_;

        return Business::Fixflo::Client->new(
            username      => $self->username,
            password      => $self->password,
            custom_domain => $self->custom_domain,
        );
    },
);

sub issues {
    my ( $self,%params ) = @_;
    return $self->client->_get_issues( \%params );
}

sub agencies {
    my ( $self,%params ) = @_;
    return $self->client->_get_agencies( \%params );
}

sub issue {
    my ( $self,$id ) = @_;
    return $self->client->_get_issue( $id );
}

sub agency {
    my ( $self,$id ) = @_;
    return $self->client->_get_agency( $id );
}

=head1 SEE ALSO

L<Business::Fixflo::Client>

L<Business::Fixflo::Issue>

L<Business::Fixflo::Agency>

=head1 AUTHOR

Lee Johnson - C<leejo@cpan.org>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. If you would like to contribute documentation,
features, bug fixes, or anything else then please raise an issue / pull request:

    https://github.com/leejo/business-fixflo

=cut

1;

# vim: ts=4:sw=4:et
