package Model::UserSession;

use strict;
use warnings;
use base qw(Class::Accessor::Fast Class::Data::Inheritable);

use lib '../';
use base 'Model::Base';


__PACKAGE__->mk_accessors( @{columns()} );
__PACKAGE__->columns     ( columns() );

__PACKAGE__->db('ClubMania');
__PACKAGE__->table('user_session');
__PACKAGE__->seq_key('user_id');    # if it isn`t nessesary,set undef
__PACKAGE__->seq_table('seq_user'); # if it isn`t nessesary,set undef

__PACKAGE__->index(+{
    pk    => 'user_id',
    uk    => undef,
    i1    => 'session_seed',
});

sub columns { [qw/user_id session_seed reg_date /] };

sub new {
    my ($class, $args) = @_;
    my $self = $class->SUPER::new(+{
        user_id       => $args->{user_id},
        session_seed  => $args->{session_seed},
        reg_date      => $args->{reg_date}     || undef,
    });
    $self;
}

1;
