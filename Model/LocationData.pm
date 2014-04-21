package Model::LocationData;

use strict;
use warnings;
use base qw(Class::Accessor::Fast Class::Data::Inheritable);

use lib '../';
use base 'Model::Base';

__PACKAGE__->mk_accessors( @{columns()} );
__PACKAGE__->columns     ( columns() );

__PACKAGE__->db('ClubMania');
__PACKAGE__->table('location_data');
__PACKAGE__->seq_key('location_id');    # if it isn`t nessesary,set undef
__PACKAGE__->seq_table('seq_location'); # if it isn`t nessesary,set undef

__PACKAGE__->index(+{
    pk    => 'location_id',
    uk    => undef,
    i1    => 'location_name',
});

sub columns { [ qw/ location_id location_name detail image reg_date /] };

sub new {
    my ($class, $args) = @_;
    my $self = $class->SUPER::new(+{
        location_id      => $args->{location_id},
        location_name    => $args->{location_name} || undef,
        detail           => $args->{detail}        || undef,
        image            => $args->{image}         || undef,
        reg_date         => $args->{reg_date}      || undef,
        url              => "/location/detail/$args->{location_id}",
    });
    $self;
}

1;
