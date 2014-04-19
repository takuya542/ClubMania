#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use lib '../../../';

use Model::EventData;
use Model::UserData;
use Model::CouponData;
use Model::ClubData;
use Model::UserData;

my $return = Model::UserData->insert(+{
    user_name      => "anonymas",
    detail         => "our future customers will be touching down here",
    image          => "http://ozz.hatenablog.com/entry/2013/11/12/205149",
    link           => "http://www.clubcamelot.jp/",
    reg_date       => time(),
});
