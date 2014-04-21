package Logic::OwnerData;

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

sub COUPON_LIST_NUM { 5 };

sub new{
    my ($class,$paging) = @_;
    my $self = bless +{ 
        paging => $paging,
    },$class;
}


# DJ情報を一件取得
sub get_single_owner_data {
    my ($self) = shift;

    #DJに紐づく各種データ取得 
    my $owner_data  = Model::OwnerData->single(+{ owner_id => $self->paging->param });
    my $events_data = Model::EventData->search(+{ owner_id => $self->paging->param }, +{
        limit => ,
        order_by => 'start_date desc',
    });

    #オブジェクトにセット
    $self->owner_data($owner_data);          # object
    $self->event_data($events_data);         # array_ref 
    return $self;
}


# DJ情報をリスト表示用に複数取得
sub get_multi_owner_data {
    my $self = shift;

    #DJに紐づく各種データ取得 
    my $owners_data  = Model::OwnerData->search(+{ owner_id => $self->paging->param }, +{
        limit    => $self->paging->data_num_per_page,
        offset   => $self->paging->offset,
        order_by => 'owner_id desc',
    });

    #オブジェクトにセット
    $self->owner_data($owners_data);
    return $self;
}

1;
