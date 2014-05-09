package Logic::Authorized;

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

#use lib '/home/onda/dotfiles';
#use Utility::Common;
#Utility::Common::dump("Logic insert",$args->param("club_id"));

use base qw(Class::Accessor::Fast Class::Data::Inheritable);
__PACKAGE__->mk_accessors( qw/ club_id limit offset / );


sub insert {
    my ($class,$args) = @_;
    my $type = $args->param("type") || die "type no set\n";

    _insert_event_data($args) if ($type =~ /event_data/);
    _insert_club_data($args) if ($type =~ /club_data/);
    _insert_location_data($args) if ($type =~ /location_data/);

}

sub _insert_event_data {
    my $args = shift;

    my $row = Model::EventData->insert(+{
        event_name    => $args->param("event_name"),
        detail        => $args->param("detail"),
        image         => $args->param("image"),
        link          => $args->param("link"),
        genre         => $args->param("genre"),
        social_link   => $args->param("social_link"),
        owner_id      => $args->param("owner_id"),
        club_id       => $args->param("club_id"),
        location_id   => $args->param("location_id"),
        start_date    => $args->param("start_date"),
        end_date      => $args->param("end_date"),
        is_powerpush  => $args->param("is_powerpush"),
    });
    die "insert fail\n" unless($row);
}

sub _insert_club_data {
    my $args = shift;
    my $row = Model::ClubData->insert(+{
        club_name       => $args->param("club_name"),
        detail          => $args->param("detail"),
        link            => $args->param("link"),
        image           => $args->param("image"),
        genre           => $args->param("genre"),
        max_popularity  => $args->param("max_popularity"),
        open_time       => $args->param("open_time"),
        close_time      => $args->param("close_time"),
        entrance_price  => $args->param("entrance_price"),
    });
    die "insert fail\n" unless($row);
}

sub _insert_location_data {
    my $args = shift;
    my $row = Model::LocationData->insert(+{
        location_name => $args->param("location_name"),
        detail        => $args->param("detail"),
        image         => $args->param("image"),
    });
    die "insert fail\n" unless($row);
}

1;
