package Business::Fixflo::Utils;

=head1 NAME

Business::Fixflo::Utils

=head1 DESCRIPTION

A role containing fixflo utilities.

=cut

use Moo::Role;

use MIME::Base64 qw/ encode_base64 /;
use Digest::SHA qw/ hmac_sha256_hex /;

=head1 METHODS

=head2 foo

=cut

sub foo {
    my ( $self ) = @_;
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
