#!perl

use strict;
use warnings;

use Test::Most;
use Test::Deep;

use Business::Fixflo::Client;

use_ok( 'Business::Fixflo::Resource' );
isa_ok(
    my $Resource = Business::Fixflo::Resource->new(
        'client'          => Business::Fixflo::Client->new(
            username      => 'foo',
            password      => 'bar',
            custom_domain => 'baz',
        ),
    ),
    'Business::Fixflo::Resource'
);

can_ok(
    $Resource,
    qw/
		url
		to_hash
		to_json
    /,
);

cmp_deeply(
    { $Resource->to_hash },
    {},
    'to_hash',
);

cmp_deeply(
    $Resource->to_json,
    '{}',
    'to_json',
);

no warnings 'redefine';
no warnings 'once';
*Business::Fixflo::Resource::Id    = sub { 1 };
*Business::Fixflo::Client::api_get = sub {
	return {
        Id => 2,
	}
};

cmp_deeply(
    $Resource->get,
    bless( {
        'client' => ignore(),
        'url'    => 'https://baz.fixflo.com/api/v2/Resource/1',
    }, 'Business::Fixflo::Resource' ),
    'get'
);

isa_ok(
    $Resource->_parse_envelope_data({
        Entity             => undef,
        Errors             => undef,
        HttpStatusCode     => 200,
        HttpStatusCodeDesc => 'OK',
        Messages           => undef,
    }),
    'Business::Fixflo::Resource',
    '_parse_envelope_data (no data)',
);

done_testing();

# vim: ts=4:sw=4:et
