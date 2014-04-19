package Model::CouponCount;

use strict;
use warnings;
use base qw(Class::Accessor::Fast Class::Data::Inheritable);

use lib '/home/onda/ClubMania';
use base 'Model::Base';

__PACKAGE__->mk_accessors( @{columns()} );
__PACKAGE__->columns     ( columns() );

__PACKAGE__->db('ClubMania');
__PACKAGE__->table('coupon_count');
__PACKAGE__->seq_key(undef);   # if it isn`t nessesary,set undef
__PACKAGE__->seq_table(undef); # if it isn`t nessesary,set undef

__PACKAGE__->index(+{
    pk    => 'coupon_id',
    uk    => undef,
    i1    => undef,
});

sub columns { [ qw/ coupon_id distributed_num /] };

sub new {
    my ($class, $args) = @_;
    my $self = $class->SUPER::new(+{
        coupon_id       => $args->{coupon_id},
        distributed_num => $args->{distributed_num},
    });
    $self;
}

1;
