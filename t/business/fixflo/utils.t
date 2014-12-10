#!perl

use strict;
use warnings;

package Utils::Tester;

use Moo;
with 'Business::Fixflo::Utils';

package main;

use Test::Most;
use Test::Deep;
use Test::Exception;
use MIME::Base64 qw/ decode_base64 /;

use Business::Fixflo::Utils;

my $Utils = Utils::Tester->new;

can_ok(
	$Utils,
	qw/
		foo
	/
);

done_testing();
