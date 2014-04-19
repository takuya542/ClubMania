package Model::SeqCoupon;

use strict;
use warnings;
use base qw(Class::Accessor::Fast Class::Data::Inheritable);

use lib '/home/onda/ClubMania';
use base 'Model::Base';

__PACKAGE__->mk_accessors(qw/ id /);
__PACKAGE__->db('ClubMania');
__PACKAGE__->table('seq_coupon');

__PACKAGE__->seq_key(undef);   # if it isn`t nessesary,set undef
__PACKAGE__->seq_table(undef); # if it isn`t nessesary,set undef

__PACKAGE__->columns([ qw/ id /]);
__PACKAGE__->index(+{ pk => 'id' });


1;
