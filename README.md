# NAME

Business::Fixflo - Perl library for interacting with the Fixflo API
(https://fixflo.com)

<div>

    <a href='https://travis-ci.org/leejo/business-fixflo?branch=master'><img src='https://travis-ci.org/leejo/business-fixflo.svg?branch=master' alt='Build Status' /></a>
    <a href='https://coveralls.io/r/leejo/business-fixflo?branch=master'><img src='https://coveralls.io/repos/leejo/business-fixflo/badge.png?branch=master' alt='Coverage Status' /></a>
</div>

# VERSION

0.01

# DESCRIPTION

Business::Fixflo is a library for easy interface to the fixflo property
repair service, it implements most of the functionality currently found
in the service's API documentation: http://www.fixflo.com/Tech/WebAPI

**You should refer to the official fixflo API documentation in conjunction**
**with this perldoc**, as the official API documentation explains in more depth
some of the functionality including required / optional parameters for certain
methods.

# SYNOPSIS

# ERROR HANDLING

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

# PAGINATION

# ATTRIBUTES

# SEE ALSO

[Business::Fixflo::Client](https://metacpan.org/pod/Business::Fixflo::Client)

[Business::Fixflo::Issue](https://metacpan.org/pod/Business::Fixflo::Issue)

# AUTHOR

Lee Johnson - `leejo@cpan.org`

# LICENSE

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. If you would like to contribute documentation,
features, bug fixes, or anything else then please raise an issue / pull request:

    https://github.com/leejo/business-fixflo
