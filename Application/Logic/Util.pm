package Logic::Util;

use strict;
use warnings;
use Data::Dumper;

sub merge_data {
    my ( $class, $base_data, $add_data ) = @_;

    my $keys = keys %$add_data;
    my $key = $keys->[0];
    $base_data->{$key} = $add_data->{$key};
    return $base_data;
}


1;
