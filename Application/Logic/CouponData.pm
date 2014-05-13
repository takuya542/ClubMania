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

# �����ݥ����������
sub get_single_coupon_data {
    my ($self) = shift;

    #�����ݥ�������
    my $coupon_data     = Model::ClubData->single(+{ 
        coupon_id => $self->paging->param,
    });

    #���٥�Ⱦ������
    $coupon_data->{event_data} = Model::EventData->single(+{
        event_id => $self->paging->param,
    });

    #����־������
    $coupon_data->{club_data} = Model::EventData->single(+{
        club_id => $coupon_data->{event_data}->club_id,
    });

    #DJ����
    $coupon_data->{owner_data} = Model::OwnerData->single(+{
        owner_id => $coupon_data->{event_data}->owner_id,
    });

    #location����
    $coupon_data->{location_data} = Model::OwnerData->single(+{
        location_id => $coupon_data->{event_data}->location_id,
    });

    #���üԾ���μ���
    $coupon_data->{user_data} = Logic::UserCouponRel->get_participants_via_coupon_id(+{
        coupon_id => $coupon_data->coupon_id,
        limit     => COUPON_PARTICIPANT_NUM(),
    });

    return $coupon_data;

}


# �����ݥ��������
sub get_multi_coupon_data {
    my ($self) = shift;

    #���٥�Ⱦ�������
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
