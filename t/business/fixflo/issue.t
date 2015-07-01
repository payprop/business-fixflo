#!perl

use strict;
use warnings;

use Test::Most;
use Test::Deep;
use Test::Exception;

use Business::Fixflo::Client;

use_ok( 'Business::Fixflo::Issue' );
isa_ok(
    my $Issue = Business::Fixflo::Issue->new(
		'Id'              => 1,
        'client'          => Business::Fixflo::Client->new(
            username      => 'foo',
            password      => 'bar',
            custom_domain => 'baz',
        ),
    ),
    'Business::Fixflo::Issue'
);

can_ok(
    $Issue,
    qw/
		url
		get
		to_hash
		to_json
		report

		CallbackId
		FaultTitle
		TermsAccepted
		TenantNotes
		Address
		Id
		Firstname
		EmailAddress
		DirectEmailAddress
		DirectMobileNumber
		TenantId
		TenantPresenceRequested
		TenantAcceptComplete
		Salutation
		Surname
		Title
		Status
		FaultCategory
		Media
		FaultPriority
		Created
		FaultNotes
		ContactNumber
		StatusChanged
        Property
    /,
);

is( $Issue->url,'https://baz.fixflo.com/api/v2/Issue/1','url' );

no warnings 'redefine';
*Business::Fixflo::Client::api_get = sub { 'report_data' };

is( $Issue->report,'report_data','report' );

*Business::Fixflo::Client::api_get = sub { {
    Property => {
        'Address' => {
            'AddressLine1' => 'test2',
            'AddressLine2' => 'bar',
            'Country' => undef,
            'County' => undef,
            'PostCode' => '12 345',
            'Town' => 'qux'
        },
        'ExternalPropertyRef' => 'PP43052',
        'Id' => 12840,
        'PropertyAddressId' => 11753
    },
} };
isa_ok( $Issue->property,'Business::Fixflo::Property' );

done_testing();

# vim: ts=4:sw=4:et
