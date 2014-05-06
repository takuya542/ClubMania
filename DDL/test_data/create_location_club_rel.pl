#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use lib '../../';
use Model::LocationClubRel;

my $return;
$return = Model::LocationClubRel->insert(+{
    location_id  => 1,
    club_id      => 1,
});

$return = Model::LocationClubRel->insert(+{
    location_id  => 1,
    club_id      => 2,
});

$return = Model::LocationClubRel->insert(+{
    location_id  => 2,
    club_id      => 3,
});

$return = Model::LocationClubRel->insert(+{
    location_id  => 2,
    club_id      => 4,
});
