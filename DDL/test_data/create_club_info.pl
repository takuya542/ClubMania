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
$return = Model::ClubData->insert(+{
    club_name      => "Camelot",
    detail         => "camelot is the club for all assholes",
    link           => "http://www.clubcamelot.jp/",
    image          => "http://ozz.hatenablog.com/entry/2013/11/12/205149",
    genre          => "ALL",
    max_popularity => "300",
    open_time      => "21:00",
    close_time     => "05:00",
    entrance_price => "3000",
});

$return = Model::ClubData->insert(+{
    club_name      => "Atom",
    detail         => "Atom is the club for pick up artist",
    link           => "http://www.clubcamelot.jp/",
    image          => "http://ozz.hatenablog.com/entry/2013/11/12/205149",
    genre          => "ALL",
    max_popularity => "300",
    open_time      => "21:00",
    close_time     => "05:00",
    entrance_price => "3000",
    reg_date       => time(),
});

$return = Model::ClubData->insert(+{
    club_name      => "V2",
    detail         => "V2 is the club for those who desperately wanna get rich",
    link           => "http://www.clubcamelot.jp/",
    image          => "http://ozz.hatenablog.com/entry/2013/11/12/205149",
    genre          => "ALL",
    max_popularity => "300",
    open_time      => "21:00",
    close_time     => "05:00",
    entrance_price => "3000",
    reg_date       => time(),
});

$return = Model::ClubData->insert(+{
    club_name      => "Muse",
    detail         => "Muse is the club for those who just wanna have fun",
    link           => "http://www.clubcamelot.jp/",
    image          => "http://ozz.hatenablog.com/entry/2013/11/12/205149",
    genre          => "ALL",
    max_popularity => "300",
    open_time      => "21:00",
    close_time     => "05:00",
    entrance_price => "3000",
    reg_date       => time(),
});

$return = Model::ClubData->insert(+{
    club_name      => "elfe",
    detail         => "elfe is the club where there is no feature at all",
    link           => "http://www.clubcamelot.jp/",
    image          => "http://ozz.hatenablog.com/entry/2013/11/12/205149",
    genre          => "ALL",
    max_popularity => "300",
    open_time      => "21:00",
    close_time     => "05:00",
    entrance_price => "3000",
    reg_date       => time(),
});

$return = Model::ClubData->insert(+{
    club_name      => "womb",
    detail         => "womb is the club for those who wanna dance to blast",
    link           => "http://www.clubcamelot.jp/",
    image          => "http://ozz.hatenablog.com/entry/2013/11/12/205149",
    genre          => "ALL",
    max_popularity => "300",
    open_time      => "21:00",
    close_time     => "05:00",
    entrance_price => "3000",
    reg_date       => time(),
});
