package Logic::EventData;

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
use Model::UserData;
use Model::LocationData;
use Model::CouponData;

use lib '/home/onda/dotfiles';
use Utility::Common;

use base qw(Class::Accessor::Fast Class::Data::Inheritable);
__PACKAGE__->mk_accessors( qw/ paging event_data/ );

sub EVENT_PARTICIPANT_NUM     { 100 };

sub new{
    my ($class,$paging) = @_;
    my $self = bless +{ 
        paging => $paging,
    },$class;
}

# ���٥�Ⱦ���������
sub get_single_event_data {
    my ($self) = shift;

    my $event_id = $self->paging->param;

    #���٥�Ⱦ������
    my $event_data = Model::EventData->single(+{
        event_id => $event_id,
    });

    #DJ�������
    $event_data->{owner_data} = Model::OwnerData->single(+{
        owner_id => $event_data->owner_id,
    });

    #����־������
    $event_data->{club_data} = Model::ClubData->single(+{
        club_id      => $event_data->club_id,
    });

    #�����������
    $event_data->{location_data}= Model::LocationData->single(+{
        location_id  => $event_data->location_id,
    });

    #�����ݥ�������
    $event_data->{coupon_data} = Model::CouponData->single(+{
        event_id => $event_id,
    });

    #���٥�Ȼ��ü�(�����ݥ�ȯ�Ԥ�����)�����
    $event_data->{user_data} = Logic::UserCouponRel->get_participants_via_event_id(+{
        event_id => $event_id,
        limit    => EVENT_PARTICIPANT_NUM(),
    });

    return $event_data;
}



# ���٥�Ⱦ����ꥹ��ɽ���Ѥ�ʣ������
sub get_multi_event_data {
    my ($self) = shift;

    #���٥�Ⱦ�������
    my $events_data = Model::EventData->search(+{},+{
        limit    => $self->paging->data_num_per_page,
        offset   => $self->paging->offset,
        order_by => 'start_date desc',
    });

    #����־������
    for my $event_data(@$events_data){
        $event_data->{club_data} = Model::ClubData->single(+{
            club_id => $event_data->{club_id},
        });
    }
    return $events_data;
}

1;
