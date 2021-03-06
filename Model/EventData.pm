package Model::EventData;

use strict;
use warnings;
use base qw(Class::Accessor::Fast Class::Data::Inheritable);

use lib '../';
use base 'Model::Base';

__PACKAGE__->mk_accessors( @{columns()} );
__PACKAGE__->columns     ( columns() );

__PACKAGE__->db('ClubMania');
__PACKAGE__->table('event_data');
__PACKAGE__->seq_key('event_id'); # if it isn`t nessesary,set undef
__PACKAGE__->seq_table('seq_event'); # if it isn`t nessesary,set undef

__PACKAGE__->index(+{
    pk    => 'event_id',
    uk    => undef,
    i1    => 'owner_id',
    i2    => 'club_id',
    i3    => 'location_id',
    i4    => 'start_date',
});

sub columns { [ qw/ event_id event_name detail image link genre social_link owner_id club_id location_id start_date end_date is_powerpush reg_date /] };

sub new {
    my ($class, $args) = @_;
    my $self = $class->SUPER::new(+{
        event_id      => $args->{event_id},
        event_name    => $args->{event_name}    || undef,
        detail        => $args->{detail}        || undef,
        image         => $args->{image}         || undef,
        link          => $args->{link}          || undef,
        genre         => $args->{genre}         || undef,
        social_link   => $args->{social_link}   || undef,
        owner_id      => $args->{owner_id}      || undef,
        club_id       => $args->{club_id}       || undef,
        location_id   => $args->{location_id}   || undef,
        start_date    => $args->{start_date}    || undef,
        end_date      => $args->{end_date}      || undef,
        is_powerpush  => $args->{is_powerpush}  || undef,
        reg_date      => $args->{reg_date}      || undef,
        url           => "/event/detail/$args->{event_id}",
    });
    $self;
}

1;
