package Model::ClubData;

use strict;
use warnings;
use base qw(Class::Accessor::Fast Class::Data::Inheritable);

use lib '../';
use base 'Model::Base';

__PACKAGE__->mk_accessors( @{columns()} );
__PACKAGE__->columns     ( columns() );

__PACKAGE__->db('ClubMania');
__PACKAGE__->table('club_data');
__PACKAGE__->seq_key('club_id'); # if it isn`t nessesary,set undef
__PACKAGE__->seq_table('seq_club'); # if it isn`t nessesary,set undef

__PACKAGE__->index(+{
    pk    => 'club_id',
    uk    => undef,
    i1    => 'club_name',
});

sub columns { [ qw/ club_id club_name detail link image genre max_popularity open_time close_time entrance_price reg_date /] };

sub new {
    my ($class, $args) = @_;
    my $self = $class->SUPER::new(+{
        club_id        => $args->{club_id},
        club_name      => $args->{club_name}     || undef,
        detail         => $args->{detail}        || undef,
        link           => $args->{link}          || undef,
        image          => $args->{image}         || undef,
        genre          => $args->{genre}         || undef,
        max_popularity => $args->{max_popularity}|| undef,
        open_time      => $args->{open_time}     || undef,
        close_time     => $args->{close_time}    || undef,
        entrance_price => $args->{entrance_price}|| undef,
        reg_date       => $args->{reg_date}      || undef,
        url            => "/club/detail/$args->{club_id}",
    });
    $self;
}

1;
