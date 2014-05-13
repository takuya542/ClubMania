package Logic::CouponData;

use strict;
use warnings;
use Data::Dumper;

use lib '../';
use Logic::UserCouponRel;

use lib '../../';
use Model::EventData;
use Model::EventUserRel;
use Model::UserCouponRel;
use Model::OwnerData;
use Model::ClubData;
use Model::LocationData;
use Model::CouponData;

use base qw(Class::Accessor::Fast Class::Data::Inheritable);
__PACKAGE__->mk_accessors( qw/ event_data owner_data club_data location_data coupon_data paging/ );

sub COUPON_PARTICIPANT_NUM     { 100 };

sub new{
    my ($class,$paging) = @_;
    my $self = bless +{ 
        paging => $paging,
    },$class;
}

# クーポン情報を一件取得
sub get_single_coupon_data {
    my ($self) = shift;

    #クーポン情報取得
    my $coupon_data     = Model::ClubData->single(+{ 
        coupon_id => $self->paging->param,
    });

    #イベント情報取得
    $coupon_data->{event_data} = Model::EventData->single(+{
        event_id => $self->paging->param,
    });

    #クラブ情報取得
    $coupon_data->{club_data} = Model::EventData->single(+{
        club_id => $coupon_data->{event_data}->club_id,
    });

    #DJ取得
    $coupon_data->{owner_data} = Model::OwnerData->single(+{
        owner_id => $coupon_data->{event_data}->owner_id,
    });

    #location取得
    $coupon_data->{location_data} = Model::OwnerData->single(+{
        location_id => $coupon_data->{event_data}->location_id,
    });

    #参加者情報の取得
    $coupon_data->{user_data} = Logic::UserCouponRel->get_participants_via_coupon_id(+{
        coupon_id => $coupon_data->coupon_id,
        limit     => COUPON_PARTICIPANT_NUM(),
    });

    return $coupon_data;

}


# クーポン情報を取得
sub get_multi_coupon_data {
    my ($self) = shift;

    #イベント情報を取得
    my $coupons_data = Model::CouponData->search(+{},+{
        limit    => $self->paging->data_num_per_page,
        offset   => $self->paging->offset,
        order_by => 'start_date desc',
    });

    for my $coupon_data (@$coupons_data){
        $coupon_data->{event_data} = Model::EventData->single(+{
            coupon_id => $coupon_data->coupon_id,
        });
    }
    return $coupons_data;
}

1;
