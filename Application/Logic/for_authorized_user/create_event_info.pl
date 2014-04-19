#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use lib '../../../';

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
        location_id   => 1,
        club_id       => 1,
        is_power_push => 0,
        start_date    => 2014/04/30,
        reg_date      => time(),
});

$return = Model::EventData->insert(+{
        event_name    => "great butt night",
        detail        => "festa for all who need great butt",
        image         => "test.link",
        link          => "http://cdn.mkimg.carview.co.jp/minkara/photo/000/002/409/989/2409989/p1.jpg?ct=b32c052a9855",
        genre         => "party",
        social_link   => "facebook.com",
        owner_id      => 1,
        location_id   => 1,
        club_id       => 1,
        is_power_push => 0,
        start_date    => 2014/04/30,
        reg_date      => time(),
});
