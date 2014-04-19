package Logic::ClubData;

use strict;
use warnings;
use Data::Dumper;

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

sub EVENT_LIST_NUM { 5 };
sub COUPON_LIST_NUM     { 3 };

sub new{
    my ($class,$paging) = @_;
    my $self = bless +{ 
        paging => $paging,
    },$class;
}

# Club情報を一件取得
sub get_single_club_data {
    my ($self) = shift;
    my $coupons_data_array = [];

    #Club一件に紐づく各種データ取得 
    my $club_data     = Model::ClubData->single     (+{ club_id      => $self->paging->param      });
    my $events_data   = Model::EventData->search(+{ club_id => $club_data->club_id },+{
        limit    => EVENT_LIST_NUM(),
        order_by => 'start_date desc',
    });

    #各イベントから一件ずつクーポン取得
    for my $event_data ( @$events_data ){
        my $coupons_data   = Model::CouponData->search   (+{ event_id     => $event_data->event_id },+{ 
            limit    => COUPON_LIST_NUM,
            order_by => 'expire desc',
        });
        map { push ( @$coupons_data_array, $_ ) }@$coupons_data;
    }

    #オブジェクトにセット
    $self->club_data($club_data);            # object
    $self->event_data($events_data);         # array_ref
    $self->coupon_data($coupons_data_array); # array_ref
    return $self;
}

# Club情報をリスト表示用に複数取得
sub get_multi_club_data {
    my ($self) = shift;

    #Club情報を取得
    my $clubs_data = Model::ClubData->search(+{},+{
        limit    => $self->paging->data_num_per_page,
        offset   => $self->paging->offset,
        order_by => 'club_id desc',
    });

    $self->club_data($clubs_data);
    return $self;
}


1;
