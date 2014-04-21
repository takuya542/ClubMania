package Model::EventUserRel;

use strict;
use warnings;
use base qw(Class::Accessor::Fast Class::Data::Inheritable);

use lib '../';
use base 'Model::Base';

__PACKAGE__->mk_accessors(qw/ event_id user_id reg_date /);
__PACKAGE__->db('ClubMania');
__PACKAGE__->table('event_user_rel');
__PACKAGE__->seq_key(undef);   # if it isn`t nessesary,set undef
__PACKAGE__->seq_table(undef); # if it isn`t nessesary,set undef

__PACKAGE__->index(+{
    pk    => ['event_id','user_id'],
    uk    => undef,
    i1    => 'user_id',
});
__PACKAGE__->columns(
    [ qw/ event_id user_id reg_date /]
);

sub new {
    my ($class, $args) = @_;
    my $self = $class->SUPER::new(+{
        event_id      => $args->{event_id},
        user_id       => $args->{user_id},
        reg_date      => $args->{reg_date},
    });
    $self;
}

1;
