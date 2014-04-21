package Model::UserTwitterData;

use strict;
use warnings;
use base qw(Class::Accessor::Fast Class::Data::Inheritable);

use lib '../';
use base 'Model::Base';

__PACKAGE__->mk_accessors( @{columns()} );
__PACKAGE__->columns     ( columns() );

__PACKAGE__->db('ClubMania');
__PACKAGE__->table('user_twitter_data');
__PACKAGE__->seq_key(undef);   # if it isn`t nessesary,set undef
__PACKAGE__->seq_table(undef); # if it isn`t nessesary,set undef

__PACKAGE__->index(+{
    pk    => 'user_id',
    uk    => undef,
    i1    => 'screen_id',
    i2    => 'screen_name',
});

sub columns { [ qw/ user_id screen_id screen_name profile image reg_date /] };

sub new {
    my ($class, $args) = @_;
    my $self = $class->SUPER::new(+{
        user_id          => $args->{user_id},
        screen_id   => $args->{user_social_id}   || undef,
        screen_name => $args->{user_social_name} || undef,
        profile          => $args->{detail}      || undef,
        image            => $args->{image}       || undef,
        reg_date         => $args->{reg_date}    || undef,
    });-
    $self;
}

1;
