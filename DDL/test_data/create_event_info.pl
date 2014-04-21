#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use lib '../../';

use Model::EventData;
use Model::UserData;
use Model::CouponData;
use Model::ClubData;

my $return;
$return = Model::EventData->insert(+{
        event_name    => "boom boom boobs",
        detail        => "festa for all who need boobs",
        image         => "test.link",
        link          => "http://cdn.mkimg.carview.co.jp/minkara/photo/000/002/409/989/2409989/p1.jpg?ct=b32c052a9855",
        genre         => "party",
        social_link   => "facebook.com",
        owner_id      => 1,
        club_id       => 1,
        location_id   => 1,
        start_date    => 10000000,
        end_date      => 20000000,
        is_powerpush  => 0,
});

$return = Model::EventData->insert(+{
        event_name    => "great butt night",
        detail        => "festa for all who need great butt",
        image         => "test.link",
        link          => "http://cdn.mkimg.carview.co.jp/minkara/photo/000/002/409/989/2409989/p1.jpg?ct=b32c052a9855",
        genre         => "party",
        social_link   => "facebook.com",
        owner_id      => 1,
        club_id       => 1,
        location_id   => 1,
        start_date    => 10000000,
        end_date      => 20000000,
        is_powerpush  => 0,
});
