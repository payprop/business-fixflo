# NAME

Business::Fixflo - Perl library for interacting with the Fixflo API
(https://www.fixflo.com)

<div>

    <a href='https://travis-ci.org/leejo/business-fixflo?branch=master'><img src='https://travis-ci.org/leejo/business-fixflo.svg?branch=master' alt='Build Status' /></a>
    <a href='https://coveralls.io/r/leejo/business-fixflo?branch=master'><img src='https://coveralls.io/repos/leejo/business-fixflo/badge.png?branch=master' alt='Coverage Status' /></a>
</div>

# VERSION

0.02

# DESCRIPTION

Business::Fixflo is a library for easy interface to the fixflo property
repair service, it implements all of the functionality currently found
in the service's API documentation: http://www.fixflo.com/Tech/WebAPI

**You should refer to the official fixflo API documentation in conjunction**
**with this perldoc**, as the official API documentation explains in more depth
some of the functionality including required / optional parameters for certain
methods.

Please note this library is a work in progress

# SYNOPSIS

    # agency API:
    my $ff = Business::Fixflo->new(
        username      => $username,
        password      => $password,
        custom_domain => $domain,
    );

    my $issues   = $ff->issues,
    my $agencies = $ff->agencies,

    while ( my @issues = $issues->next ) {
        foreach my $issue ( @issues ) {
            ...
        }
    }

    my $issue = $ff->issue( $id );
    my $json  = $issue->to_json;

    # third party API:
    my $ff = Business::Fixflo->new(
        username      => $third_party_username,
        password      => $third_party_password,
    );

    my $agency = Business::Fixflo::Agency->new(
        client     => $ff->client,
        AgencyName => 'foo',
    );

    $agency->create;
    $agency->delete;

# ERROR HANDLING

Any problems or errors will result in a Business::Fixflo::Exception
object being thrown, so you should wrap any calls to the library in the
appropriate error catching code (TryCatch in the below example):

    use TryCatch;

    try {
        ...
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

# ATTRIBUTES

## username

Your Fixflo username

## password

Your Fixflo password

## custom\_domain

Your Fixflo custom domain, defaults to "api" (which will in fact call
the third party Fixflo API)

## url\_suffix

The url suffix to use after the custom domain, defaults to fixflo.com

## client

A Business::Fixflo::Client object, this will be constructed for you so
you shouldn't need to pass this

# METHODS

    issues
    agencies
    properties
    property_addresses
    issue
    agency
    property
    property_address
    quick_view_panels

Get a \[list of\] issue(s) / agenc(y|ies) / propert(y|ies) / property address(es):

    my $paginator = $ff->issues( %query_params );

    my $issue     = $ff->issue( $id );

Will return a [Business::Fixflo::Paginator](https://metacpan.org/pod/Business::Fixflo::Paginator) object (when calling endpoints
that return lists of items) or a Business::Fixflo:: object for the Issue,
Agency, etc.

%query\_params refers to the possible query params as shown in the currency
Fixflo API documentation. For example: page=\[n\]. You can pass DateTime objects
through and these will be correctly changed into strings when calling the API:

    # issues raised in the previous month
    my $paginator = $ff->issues(
        CreatedSince  => DateTime->now->subtract( months => 1 ),
    );

    # properties in given postal code
    my $paginator = $ff->properties(
        Keywords => 'NW1',
    );

Refer to the [Business::Fixflo::Paginator](https://metacpan.org/pod/Business::Fixflo::Paginator) documentation for what to do with
the returned paginator object.

Note the property method can take a flag to indicate that the passed $id is an
external reference:

    my $Property = $ff->property( 'P123',1 );

# EXAMPLES

See the t/002\_end\_to\_end.t test included with this distribution. you can run
this test against the fixflo test server (requires ENV variables to set the
Fixflo credentials)

# SEE ALSO

[Business::Fixflo::Address](https://metacpan.org/pod/Business::Fixflo::Address)

[Business::Fixflo::Agency](https://metacpan.org/pod/Business::Fixflo::Agency)

[Business::Fixflo::Client](https://metacpan.org/pod/Business::Fixflo::Client)

[Business::Fixflo::Issue](https://metacpan.org/pod/Business::Fixflo::Issue)

[Business::Fixflo::Paginator](https://metacpan.org/pod/Business::Fixflo::Paginator)

[Business::Fixflo::Property](https://metacpan.org/pod/Business::Fixflo::Property)

[Business::Fixflo::PropertyAddress](https://metacpan.org/pod/Business::Fixflo::PropertyAddress)

[Business::Fixflo::QuickViewPanel](https://metacpan.org/pod/Business::Fixflo::QuickViewPanel)

[http://www.fixflo.com/Tech/Api/V2/Urls](http://www.fixflo.com/Tech/Api/V2/Urls)

# AUTHOR

Lee Johnson - `leejo@cpan.org`

# LICENSE

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. If you would like to contribute documentation,
features, bug fixes, or anything else then please raise an issue / pull request:

    https://github.com/leejo/business-fixflo
