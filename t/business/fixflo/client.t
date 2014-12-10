#!perl

use strict;
use warnings;

use Test::Most;
use Test::Deep;

use_ok( 'Business::Fixflo::Client' );
isa_ok(
    my $Client = Business::Fixflo::Client->new(
    ),
    'Business::Fixflo::Client'
);

can_ok(
    $Client,
    qw/
        username
        password
    /,
);

done_testing();

# vim: ts=4:sw=4:et
