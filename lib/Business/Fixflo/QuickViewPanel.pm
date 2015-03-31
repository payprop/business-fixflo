package Business::Fixflo::QuickViewPanel;

=head1 NAME

Business::Fixflo::Property::QuickViewPanel

=head1 DESCRIPTION

A class for a fixflo QVP, extends L<Business::Fixflo::Resource>

=cut

use Moo;
use Business::Fixflo::Exception;

extends 'Business::Fixflo::Resource';

use Carp qw/ confess /;

=head1 ATTRIBUTES

	DataTypeName
	Explanation
	QVPTypeId
	Title
	Url
    
    issue_summary
    issue_status_summary

=cut

has [ qw/
	DataTypeName
	Explanation
	QVPTypeId
	Title
	Url
/ ] => (
    is => 'rw',
);

has 'issue_summary' => (
    is  => 'ro',
    isa => sub {
        confess( "$_[0] is not an ARRAY ref" )
            if defined $_[0] && ref $_[0] ne 'ARRAY';
    },
    lazy    => 1,
    default => sub {
        my ( $self ) = @_;
        return $self->_get if $self->DataTypeName eq 'IssueSummary';
        return;
    },
);

has 'issue_status_summary' => (
    is  => 'ro',
    isa => sub {
        confess( "$_[0] is not an ARRAY ref" )
            if defined $_[0] && ref $_[0] ne 'ARRAY';
    },
    lazy    => 1,
    default => sub {
        my ( $self ) = @_;
        return $self->_get if $self->DataTypeName eq 'IssueStatusSummary';
        return;
    },
);

sub _get {
    my ( $self ) = @_;
	return $self->client->api_get( $self->Url );
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
