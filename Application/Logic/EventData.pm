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
use Model::UserData;
use Model::LocationData;
use Model::CouponData;

use base qw(Class::Accessor::Fast Class::Data::Inheritable);
__PACKAGE__->mk_accessors( qw/ paging event_data/ );

sub COUPON_LIST_NUM { 5 };
sub USER_LIST_NUM   { 50 };

sub new{
    my ($class,$paging) = @_;
    my $self = bless +{ 
        paging => $paging,
    },$class;
}

# イベント情報を一件取得
sub get_single_event_data {
    my ($self) = shift;

    my $event_id = $self->paging->param;

    #イベントに1:1で紐づく各種データ取得 
    my $event_data    = Model::EventData->single    (+{ event_id     => $event_id                 });
    my $owner_data    = Model::OwnerData->single    (+{ owner_id     => $event_data->owner_id     });
    my $club_data     = Model::ClubData->single     (+{ club_id      => $event_data->club_id      });
    my $location_data = Model::LocationData->single (+{ location_id  => $event_data->location_id  });

    #クーポンを複数取得
    my $coupon_data   = Model::CouponData->search(+{ event_id => $event_id },+{ 
        limit    => COUPON_LIST_NUM,
        order_by => 'expire desc',
    });

    #イベント参加者(クーポン発行した人)を取得
    my $user_data_rel = Model::UserCouponRel->search(+{ event_id => $event_id },+{ 
        limit    => USER_LIST_NUM,
        order_by => 'expire desc',
    });
    my @user_ids = map { $_->user_id } @$user_data_rel;
    my $user_data = Model::UserData->search(+{ user_id => \@user_ids },+{ 
        order_by => 'user_id desc',
    });

    my $rhData = undef;
    $rhData->{paging}                      = $self->{paging};
    $rhData->{event_data}                  = $event_data;
    $rhData->{event_data}->{owner_data}    = $owner_data;
    $rhData->{event_data}->{club_data}     = $club_data;
    $rhData->{event_data}->{location_data} = $location_data;
    $rhData->{event_data}->{coupon_data}   = $coupon_data;
    return $rhData;
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
