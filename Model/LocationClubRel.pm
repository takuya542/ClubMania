package Model::LocationClubRel;

use strict;
use warnings;
use base qw(Class::Accessor::Fast Class::Data::Inheritable);

use lib '/home/onda/ClubMania';
use base 'Model::Base';

__PACKAGE__->mk_accessors( @{columns()} );
__PACKAGE__->columns     ( columns() );

__PACKAGE__->db('ClubMania');
__PACKAGE__->table('location_club_rel');
__PACKAGE__->seq_key(undef);   # if it isn`t nessesary,set undef
__PACKAGE__->seq_table(undef); # if it isn`t nessesary,set undef

__PACKAGE__->index(+{
    pk    => ['location_id','club_id'],
    uk    => undef,
    i1    => 'club_id',
});

sub columns { [ qw/ location_id club_id reg_date /] };

sub new {
    my ($class, $args) = @_;
    my $self = $class->SUPER::new(+{
        location_id   => $args->{location_id},
        club_id       => $args->{club_id},
        reg_date      => $args->{reg_date},
    });
    $self;
}

1;
