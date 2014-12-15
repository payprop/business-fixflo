#!perl

use strict;
use warnings;

use Test::Most;
use Test::Deep;
use Test::Exception;

use lib 'lib';
use Business::Fixflo;
use Business::Fixflo::Agency;

plan skip_all => "FIXFLO_ENDTOEND required"
    if ! $ENV{FIXFLO_ENDTOEND};

$ENV{FIXFLO_DEV_TESTING} = 1;

# this is an "end to end" test - it will call the fixflo API
# using the details defined in the ENV variables below. you
# will need at least one issue (with a photo uploaded) and
# one agency for this test to pass
my ( $username,$password,$domain ) = @ENV{qw/
	FIXFLO_USERNAME
	FIXFLO_PASSWORD
	FIXFLO_CUSTOM_DOMAIN
	FIXFLO_3RD_PARTY_USERNAME
	FIXFLO_3RD_PARTY_PASSWORD
/};

my $ff = Business::Fixflo->new(
	username      => $username,
	password      => $password,
	custom_domain => $domain,
);

isa_ok(
	my $issues = $ff->issues,
	'Business::Fixflo::Paginator',
	'->issues'
);

cmp_deeply(
	$issues,
	bless({
		'class'  => 'Business::Fixflo::Issue',
		'client' => ignore(),
		'links' => {
			'next'     => ignore(),
			'previous' => ignore(),
		},
		'objects' => ignore(),
	},'Business::Fixflo::Paginator' ),
	'->issues'
);

cmp_deeply(
	$issues->objects->[0],
	methods(
		'client' => ignore(),
		'url'    => re( "https://$domain.fixflo.com/api/v2/issue/[^/]+" ),
	),
	' ... ->objects'
);

isa_ok(
	my $issue = $issues->objects->[0]->get,
	'Business::Fixflo::Issue',
	' ... ->get'
);

cmp_deeply(
	$issue,
	bless( {
		'Address' => {
			'AddressLine1' => ignore(),
			'AddressLine2' => ignore(),
			'Country'      => ignore(),
			'County'       => ignore(),
			'PostCode'     => ignore(),
			'Town'         => ignore(),
		},
		( map { $_ => ignore() } qw/
			CallbackId
			ContactNumber
			Created
			DirectEmailAddress
			DirectMobileNumber
			EmailAddress
			FaultCategory
			FaultNotes
			FaultPriority
			FaultTitle
			Firstname
			Id
			Salutation
			Status
			StatusChanged
			Surname
			TenantAcceptComplete
			TenantId
			TenantNotes
			TenantPresenceRequested
			TermsAccepted
			Title
			client
			url
		/ ),
	   'Media' => supersetof( {
			'ContentType' => ignore(),
			'URL'         => ignore(),
		} ),
		},'Business::Fixflo::Issue'
	),
	'->issue'
);

ok( $issue->report,' ... ->report' );

isa_ok(
	$ff->issue( $issue->Id ),
	'Business::Fixflo::Issue',
	'->issue'
);

# to create/update/delete agencies we need to use the third party api
$ff = Business::Fixflo->new(
	username      => $username,
	password      => $password,
);

isa_ok(
	my $agencies = $ff->agencies,
	'Business::Fixflo::Paginator',
	'->agencies'
);

note explain $agencies;

cmp_deeply(
	$agencies,
	bless( {
		'class' => 'Business::Fixflo::Agency',
		'client' => ignore(),
		'links' => {
			'next'     => ignore(),
			'previous' => ignore(),
		},
		'objects' => ignore(),
	},'Business::Fixflo::Paginator' ),
	'->agencies'
);

cmp_deeply(
	$agencies->objects->[0],
	methods(
		'client' => ignore(),
		'url'    => re( "https://api.fixflo.com/api/v2/agency/[^/]+" ),
	),
	' ... ->objects'
);

isa_ok(
	my $agency = $agencies->objects->[0]->get,
	'Business::Fixflo::Agency',
	' ... ->get'
);

cmp_deeply(
	$agency,
	bless( {
		( map { $_ => ignore() } qw/
			AgencyName
			Created
			CustomDomain
			EmailAddress
			FeatureType
			Id
			IsDeleted
			IssueTreeRoot
			SiteBaseUrl
			client
			url
		/ ),
	},'Business::Fixflo::Agency' ),
	'->agency',
);

isa_ok(
	my $NewAgency = Business::Fixflo::Agency->new(
		client       => $ff->client,
		Id           => undef,
		AgencyName   => 'bff_end_to_end',
		EmailAddress => 'leejo@cpan.org',
	),
	'Business::Fixflo::Agency'
);

note explain $NewAgency->create;
note explain $NewAgency->delete;
