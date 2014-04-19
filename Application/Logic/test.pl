#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use lib '../../';
use Model::EventData;
use Model::UserData;
use Model::CouponData;
use Model::ClubData;
use Model::OwnerData;
use Model::LocationData;

my $return;

$return = Model::EventData->search(+{ event_id => 1 });
print "return:".Dumper($return)."\n";

$return = Model::UserData->search(+{ user_id => 1 });
print "return:".Dumper($return)."\n";

$return = Model::OwnerData->search(+{ owner_id => 1 });
print "return:".Dumper($return)."\n";

$return = Model::ClubData->search(+{ club_id => 1 });
print "return:".Dumper($return)."\n";

$return = Model::CouponData->search(+{ coupon_id => 1 });
print "return:".Dumper($return)."\n";

$return = Model::LocationData->search(+{ location_id => 1 });
print "return:".Dumper($return)."\n";
