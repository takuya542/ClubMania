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
use Model::LocationClubRel;
use Model::CouponData;

use base qw(Class::Accessor::Fast Class::Data::Inheritable);
__PACKAGE__->mk_accessors( qw/ club_id limit offset / );

sub EVENT_LIST_NUM { 5 };
sub COUPON_LIST_NUM     { 3 };

sub new{
    my ($class,$paging) = @_;
    my $self = bless +{ 
        club_id => $paging->param  || undef,
        limit   => $paging->limit  || undef,
        offset  => $paging->offset || undef,
    },$class;
}

# Club情報を一件取得
sub get_single_club_data {
    my ($self) = shift;
    my $coupons_data_array = [];

    # Club情報取得 
    my $club_data = Model::ClubData->single(+{ club_id => $self->club_id });
    return unless ( $club_data );

    # 地理情報取得
    my $club_location_rel  = Model::LocationClubRel->single({ club_id => $club_data->club_id });
    my $location_data      = Model::LocationData->single({ location_id => $club_location_rel->location_id });

    # イベント情報取得
    my $events_data  = Model::EventData->search({ club_id => $club_data->club_id });

    #クーポン取得
    my @event_ids = map{ $_->event_id }@$events_data;
=pop
    my $coupons_data = Model::CouponData->search(+{ event_id => \@event_ids },+{ 
        limit    => COUPON_LIST_NUM,
        order_by => 'expire desc',
    });
=cut

    # テンプレート出力用データ生成
    my $rhData = +{};
    $rhData->{club_data} = $club_data;                      # object
    $rhData->{club_data}->{location_data} = $location_data; # object
    $rhData->{club_data}->{event_data}    = $events_data;   # array_ref
#    $rhData->{club_data}->{coupon_data}   = $coupons_data;  # array_ref
    return $rhData;
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
