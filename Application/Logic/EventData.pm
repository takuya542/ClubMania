package Logic::EventData;

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

# イベント情報を一件取得
sub get_single_event_data {
    my ($self) = shift;

    #イベントに紐づく各種データ取得 
    my $event_data    = Model::EventData->single    (+{ event_id     => $self->paging->param      });
    my $owner_data    = Model::OwnerData->single    (+{ owner_id     => $event_data->owner_id     });
    my $club_data     = Model::ClubData->single     (+{ club_id      => $event_data->club_id      });
    my $location_data = Model::LocationData->single (+{ location_id  => $event_data->location_id  });
    my $coupon_data   = Model::CouponData->search   (+{ event_id     => $event_data->event_id },+{ 
        limit    => COUPON_LIST_NUM,
        order_by => 'expire desc',
    });

    #オブジェクトにセット
    $self->event_data($event_data);          # object
    $self->owner_data($owner_data);          # object
    $self->club_data($club_data);            # object
    $self->location_data($location_data);    # object
    $self->coupon_data($coupon_data);        # array_ref

    return $self;
}

# イベント情報をリスト表示用に複数取得
sub get_multi_event_data {
    my ($self) = shift;

    #イベント情報を取得
    my $events_data = Model::EventData->search(+{},+{
        limit    => $self->paging->data_num_per_page,
        offset   => $self->paging->offset,
        order_by => 'start_date desc',
    });

    $self->event_data($events_data);
    return $self;
}

1;
