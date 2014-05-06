#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

use lib '../';
use Logic::ClubData;

use base qw(Class::Accessor::Fast Class::Data::Inheritable);
__PACKAGE__->mk_accessors( qw/ paging / );

sub param  { my $self = shift; return $self->{param};}
sub limit  { my $self = shift; return $self->{limit};}
sub offset { my $self = shift; return $self->{offset};}

my $paging = bless +{
    param  => 1,
    limit  => 30,
    offset => 0,
},__PACKAGE__;


my $club_single = Logic::ClubData->new($paging)->get_single_club_data;
Dumper($club_single);
