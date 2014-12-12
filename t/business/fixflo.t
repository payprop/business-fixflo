#!perl

use strict;
use warnings;

use Test::Most;
use Test::Deep;
use Test::Exception;

# this makes Business::Fixflo::Exception show a stack
# trace when any error is thrown so i don't have to keep
# wrapping stuff in this test in evals to debug
$ENV{FIXFLO_DEV_TESTING} = 1;

use Business::Fixflo::Issue;

use_ok( 'Business::Fixflo' );
isa_ok(
    my $Fixflo = Business::Fixflo->new(
        username      => 'foo',
        password      => 'bar',
        custom_domain => 'baz',
    ),
    'Business::Fixflo'
);

can_ok(
    $Fixflo,
    qw/
        username
        password
        custom_domain
        client
    /,
);

no warnings 'redefine';
*Business::Fixflo::Client::_api_request = sub {
	return {
		NextURL     => 'foo',
		PreviousURL => 'bar',
		Items       => [ qw/
			url1 url2 url3
		/ ],
	}
};

isa_ok(
    my $Issues = $Fixflo->issues,
    'Business::Fixflo::Paginator',
);

cmp_deeply(
	$Issues->objects,
	[
		map { Business::Fixflo::Issue->new(
			client => $Fixflo->client,
			url    => "url" . $_,
		) } 1 .. 3,
	],
	'issues',
);

isa_ok(
    my $Agencies = $Fixflo->agencies,
    'Business::Fixflo::Paginator',
);

cmp_deeply(
	$Agencies->objects,
	[
		map { Business::Fixflo::Agency->new(
			client => $Fixflo->client,
			url    => "url" . $_,
		) } 1 .. 3,
	],
	'agencies',
);

*Business::Fixflo::Client::_api_request = sub {
	return {
        'Id'        => 1,
	}
};

isa_ok(
    my $Issue = $Fixflo->issue( 1 ),
    'Business::Fixflo::Issue',
);

is( $Issue->Id,1,'issue (Id)' );

isa_ok(
    my $Agency = $Fixflo->agency( 1 ),
    'Business::Fixflo::Agency',
);

is( $Agency->Id,1,'agency (Id)' );

done_testing();

# vim: ts=4:sw=4:et
