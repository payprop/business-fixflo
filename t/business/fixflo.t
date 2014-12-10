#!perl

use strict;
use warnings;

use Test::Most;
use Test::Deep;
use Test::MockObject;
use Test::Exception;
use JSON;

# this makes Business::Fixflo::Exception show a stack
# trace when any error is thrown so i don't have to keep
# wrapping stuff in this test in evals to debug
$ENV{FIXFLO_DEV_TESTING} = 1;

use_ok( 'Business::Fixflo' );
isa_ok(
    my $Fixflo = Business::Fixflo->new(
    ),
    'Business::Fixflo'
);

can_ok(
    $Fixflo,
    qw/
        username
        password
        client
    /,
);

isa_ok( $Fixflo->client,'Business::Fixflo::Client' );

# monkey patching LWP here to make this test work without
# having to actually hit the endpoints or use credentials
no warnings 'redefine';
no warnings 'once';
my $mock = Test::MockObject->new;
$mock->mock( 'is_success',sub { 1 } );
$mock->mock( 'header',sub {} );
*LWP::UserAgent::request = sub { $mock };

done_testing();

# vim: ts=4:sw=4:et
