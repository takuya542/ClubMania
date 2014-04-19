#!/usr/bin/perl
use strict;
use warnings;

use lib '../';
use Logic::Common;
use Logic::EventData;
use Logic::Paging;
use Data::Dumper;

my $event_data = Logic::EventData->new(+{});
print Dumper($event_data);
