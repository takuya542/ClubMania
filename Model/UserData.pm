package Model::UserData;

use strict;
use warnings;
use base qw(Class::Accessor::Fast Class::Data::Inheritable);

use lib '/home/onda/ClubMania';
use base 'Model::Base';


__PACKAGE__->mk_accessors( @{columns()} );
__PACKAGE__->columns     ( columns() );

__PACKAGE__->db('ClubMania');
__PACKAGE__->table('user_data');
__PACKAGE__->seq_key('user_id');    # if it isn`t nessesary,set undef
__PACKAGE__->seq_table('seq_user'); # if it isn`t nessesary,set undef

__PACKAGE__->index(+{
    pk    => 'user_id',
    uk    => undef,
    i1    => 'user_name',
});

sub columns { [qw/user_id user_name detail image link reg_date /] };

sub new {
    my ($class, $args) = @_;
    my $self = $class->SUPER::new(+{
        user_id       => $args->{user_id},
        user_name     => $args->{user_name}    || undef,
        detail        => $args->{detail}       || undef,
        image         => $args->{image}        || undef,
        link          => $args->{link}         || undef,
        reg_date      => $args->{reg_date}     || undef,
        url           => "/user/detail/$args->{user_id}",
    });
    $self;
}

1;
