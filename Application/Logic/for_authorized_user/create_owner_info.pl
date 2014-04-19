#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use lib '../../../';

use Model::EventData;
use Model::UserData;
use Model::CouponData;
use Model::ClubData;
use Model::OwnerData;

my $return;
$return = Model::OwnerData->insert(+{
    owner_name     => "DJ nobu",
    detail         => "A guy of boobs",
    image          => "http://www.nagmag.jp/wp-content/uploads/2014/04/dj-copia.jpg",
    link           => "http://www.ownercamelot.jp/",
    social_link    => "facebook.com",
    reg_date       => time(),
});

$return = Model::OwnerData->insert(+{
    owner_name     => "DJ akagi",
    detail         => "Art freak,just let him do anything free and you will see sth good",
    image          => "http://www.nagmag.jp/wp-content/uploads/2014/04/dj-copia.jpg",
    link           => "http://www.ownercamelot.jp/",
    social_link    => "facebook.com",
    reg_date       => time(),
});

$return = Model::OwnerData->insert(+{
    owner_name     => "DJ aoki",
    detail         => "Greate geek.a man who cat make impossible possible",
    image          => "http://www.nagmag.jp/wp-content/uploads/2014/04/dj-copia.jpg",
    link           => "http://www.ownercamelot.jp/",
    social_link    => "facebook.com",
    reg_date       => time(),
});
