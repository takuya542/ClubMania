package Model::UserPref;

use strict;
use warnings;
use base qw(Class::Accessor::Fast Class::Data::Inheritable);

use lib '../';
use base 'Model::Base';


__PACKAGE__->mk_accessors( @{columns()} );
__PACKAGE__->columns     ( columns() );

__PACKAGE__->db('ClubMania');
__PACKAGE__->table('user_pref');
__PACKAGE__->seq_key(undef);    # if it isn`t nessesary,set undef
__PACKAGE__->seq_table(undef);  # if it isn`t nessesary,set undef

__PACKAGE__->index(+{
    pk    => 'user_id',
    uk    => undef,
    i1    => 'club_id',
    i2    => 'location_id',
    i3    => 'genre',
});

sub columns { [ qw/ user_id club_id location_id genre updated_at /] };

sub new {
    my ($class, $args) = @_;
    my $self = $class->SUPER::new(+{
        user_id      => $args->{user_id},
        club_id      => $args->{club_id},
        location_id  => $args->{location_id},
        genre        => $args->{genre},
        updated_at   => $args->{updated_at},
    });
    $self;
}

1;
