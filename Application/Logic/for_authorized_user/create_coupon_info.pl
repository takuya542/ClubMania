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
$return = Model::CouponData->insert(+{
    coupon_name      => "booty call night",
    detail           => "just get fucked up and make things crazy",
    image            => "http://www.tequila.ac/common/images/people_no003_04.jpg",
    link             => "http://www.clubcamelot.jp/",
    genre            => "party",
    max_distribute   => "300",
    event_id         => 1,
    expire           => 10000,
    reg_date         => time(),
});

$return = Model::CouponData->insert(+{
    coupon_name      => "kick slut`s ass",
    detail           => "greate time for all sluts and guy who want to meet them",
    image            => "http://www.tequila.ac/common/images/people_no003_04.jpg",
    link             => "http://www.clubcamelot.jp/",
    genre            => "party",
    max_distribute   => "300",
    event_id         => 1,
    expire           => 10000,
    reg_date         => time(),
});

$return = Model::CouponData->insert(+{
    coupon_name      => "freak instrumental",
    detail           => "music and dance for all",
    image            => "http://www.tequila.ac/common/images/people_no003_04.jpg",
    link             => "http://www.clubcamelot.jp/",
    genre            => "party",
    max_distribute   => "300",
    event_id         => 1,
    expire           => 10000,
    reg_date         => time(),
});

