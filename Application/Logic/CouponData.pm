package Logic::CouponData;

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
sub get_single_Coupon_data {
    my ($self) = shift;
    my $coupon_data     = Model::ClubData->single     (+{ coupon_id => $self->paging->param });
    my $events_data     = Model::EventData->single     (+{ event_id => $self->paging->param });
}

# Club情報を一件取得
sub get_multi_Coupon_data {
}

1;
