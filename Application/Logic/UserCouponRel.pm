package Logic::UserCouponRel;

use strict;
use warnings;

use lib '../../';
use Model::UserCouponRel;
use Model::UserData;

#coupon_idを元に、クーポン発行者リストを取得する
sub get_participants_via_coupon_id {
    my ($class,$args) = shift;
    my $user_coupon_rel = Model::UserCouponRel->search(+{ coupon_id => $args->{coupon_id} },+{
        limit    => $args->{limit},
        order_by => 'start_date desc',
    });
    return _get_user_data($user_coupon_rel);
}

#event_idを元に、イベント参加者リストを取得する
sub get_participants_via_event_id {
    my ($class,$args) = shift;
    my $user_coupon_rel = Model::UserCouponRel->search(+{ event_id => $args->{event_id} },+{
        limit    => $args->{limit},
        order_by => 'start_date desc',
    });
    return _get_user_data($user_coupon_rel);
}

sub _get_user_data {
    my $user_coupon_rel = shift;
    my @user_ids = map { $_->user_id } @$user_coupon_rel;
    my $user_data = Model::UserData->search(+{ user_id => \@user_ids },+{ 
        order_by => 'user_id desc',
    });
    return $user_data;
}

1;
