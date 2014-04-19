package Model::CouponData;

use strict;
use warnings;
use base qw(Class::Accessor::Fast Class::Data::Inheritable);

use lib '/home/onda/ClubMania';
use base 'Model::Base';

__PACKAGE__->mk_accessors( @{columns()} );
__PACKAGE__->columns     ( columns() );

__PACKAGE__->db('ClubMania');
__PACKAGE__->table('coupon_data');
__PACKAGE__->seq_key('coupon_id'); # if it isn`t nessesary,set undef
__PACKAGE__->seq_table('seq_coupon'); # if it isn`t nessesary,set undef

__PACKAGE__->index(+{
    pk    => 'coupon_id',
    uk    => undef,
    i1    => 'event_id',
    i2    => 'genre',
});

sub columns { [ qw/ coupon_id coupon_name detail image genre link max_distribute event_id expire reg_date /] };

sub new {
    my ($class, $args) = @_;
    my $self = $class->SUPER::new(+{
        coupon_id      => $args->{coupon_id},
        coupon_name    => $args->{coupon_name}    || undef,
        detail         => $args->{detail}         || undef,
        image          => $args->{image}          || undef,
        link           => $args->{link}           || undef,
        genre          => $args->{genre}          || undef,
        max_distribute => $args->{max_distribute} || undef,
        event_id       => $args->{event_id}       || undef,
        expire         => $args->{expire}         || undef,
        reg_date       => $args->{reg_date}       || time(),
        url            => "/coupon/detail/$args->{coupon_id}",
    });
    $self;
}

1;
