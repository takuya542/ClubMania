#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use lib '../../';

use Model::EventData;
use Model::UserData;
use Model::CouponData;
use Model::ClubData;
use Model::LocationData;

my $return;
$return = Model::LocationData->insert(+{
    location_name  => "SHIBUYA",
    detail         => "city where it never sleeps. city where Anything could be happeging",
    image          => "http://media-cdn.tripadvisor.com/media/photo-s/03/ec/07/79/shibuya-center-town.jpg",
});

$return = Model::LocationData->insert(+{
    location_name  => "ROPPONGI",
    detail         => "Like a G6",
    image          => "http://media-cdn.tripadvisor.com/media/photo-s/03/ec/07/79/shibuya-center-town.jpg",
});

$return = Model::LocationData->insert(+{
    location_name  => "SHINJUKU",
    detail         => "city that you never possibly get out. The skyscraper will get you hold back",
    image          => "http://media-cdn.tripadvisor.com/media/photo-s/03/ec/07/79/shibuya-center-town.jpg",
});

