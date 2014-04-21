package Model::OwnerData;

use strict;
use warnings;
use base qw(Class::Accessor::Fast Class::Data::Inheritable);

use lib '../';
use base 'Model::Base';

__PACKAGE__->mk_accessors( @{columns()} );
__PACKAGE__->columns     ( columns() );

__PACKAGE__->db('ClubMania');
__PACKAGE__->table('owner_data');
__PACKAGE__->seq_key('owner_id');    # if it isn`t nessesary,set undef
__PACKAGE__->seq_table('seq_owner'); # if it isn`t nessesary,set undef

__PACKAGE__->index(+{
    pk    => 'owner_id',
    uk    => undef,
    i1    => 'owner_name',
});

sub columns { [ qw/ owner_id  owner_name detail link image social_link reg_date /] };

sub new {
    my ($class, $args) = @_;
    my $self = $class->SUPER::new(+{
        owner_id      => $args->{owner_id},
        owner_name    => $args->{owner_name}    || undef,
        detail        => $args->{detail}        || undef,
        link          => $args->{link}          || undef,
        image         => $args->{image}         || undef,
        social_link   => $args->{social_link}   || undef,
        reg_date      => $args->{reg_date}      || undef,
        url           => "/owner/detail/$args->{owner_id}",
    });
    $self;
}

1;
