package Model::UserCouponRel;

use strict;
use warnings;
use base qw(Class::Accessor::Fast Class::Data::Inheritable);

use lib '../';
use base 'Model::Base';

__PACKAGE__->mk_accessors( @{columns()} );
__PACKAGE__->columns     ( columns() );

__PACKAGE__->db('ClubMania');
__PACKAGE__->table('user_coupon_rel');
__PACKAGE__->seq_key(undef);   # if it isn`t nessesary,set undef
__PACKAGE__->seq_table(undef); # if it isn`t nessesary,set undef

__PACKAGE__->index(+{
    pk    => ['user_id','event_id','coupon_id'],
    uk    => undef,
    i1    => 'user_id',
    i2    => 'event_id',
    i3    => 'coupon_id',
});

sub columns { [ qw/ user_id event_id coupon_id reg_date /] };

sub new {
    my ($class, $args) = @_;
    my $self = $class->SUPER::new(+{
        event_id      => $args->{event_id},
        user_id       => $args->{user_id},
        coupon_id     => $args->{coupon_id},
        reg_date      => $args->{reg_date},
    });
    $self;
}

1;
