#!perl

use strict;
use warnings;

use Test::Most;
use Test::Deep;
use Test::Exception;

use Business::Fixflo::Client;

use_ok( 'Business::Fixflo::Agency' );
isa_ok(
    my $Agency = Business::Fixflo::Agency->new(
		'Id'              => 1,
        'client'          => Business::Fixflo::Client->new(
            username      => 'foo',
            password      => 'bar',
            custom_domain => 'baz',
        ),
    ),
    'Business::Fixflo::Agency'
);

can_ok(
    $Agency,
    qw/
		url
		get
		to_hash
		to_json
        create
        delete

        Id
        AgencyName
        CustomDomain
        EmailAddress
        IsDeleted
        Created
        FeatureType
        IssueTreeRoot
        SiteBaseUrl
    /,
);

is( $Agency->url,'https://baz.fixflo.com/api/v2/Agency/1','url' );

no warnings 'redefine';
*Business::Fixflo::Client::api_post   = sub { 'updated' };
*Business::Fixflo::Client::api_delete = sub { 'deleted' };

is( $Agency->create,'updated','create' );
is( $Agency->delete,'deleted','delete' );

done_testing();

# vim: ts=4:sw=4:et
