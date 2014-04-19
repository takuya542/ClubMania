package Logic::Paging;

use strict;
use warnings;
use Data::Dumper;

use base qw(Class::Accessor::Fast Class::Data::Inheritable);
__PACKAGE__->mk_accessors( qw/ current_url next_url previous_url data_num_per_page offset user_agent bread param is_sp count/ );

sub DATA_PER_PAGE_FOR_PC { 20 }
sub DATA_PER_PAGE_FOR_SP { 5 }


sub build_paging {
    my ($class,$args) = @_;
    my $ua   = $args->{request}->headers->user_agent;
    my ($path,$param) = _get_valid_param( $args->{request}->url->path->{path}, $args->{param} || 1 );

    my $self = $class->new(+{
        current_url       => $path,
        next_url          => _get_next_url($path,$param),
        previous_url      => _get_previous_url($path,$param),
        data_num_per_page => _get_data_num_per_page($ua),
        offset            => _get_offset($ua,$param),
        user_agent        => $ua,
        bread             => _get_bread($path,$param),
        param             => $param,
        is_sp             => _is_sp($ua),
        count             => 0,
    });
    $self;
}


sub _get_valid_param {
    my ($path,$param) = @_;
    my $valid_param  = ( scalar($param) <= 1 ) ? 1 : $param ;
    my @url_array = split(/\//,$path);
    if( $url_array[-1] =~ /^\-[0-9]+$/ ){
        $url_array[-1] = 1;
        $valid_param = 1;
    }
    return ( join('/',@url_array), $valid_param);
}


sub _get_next_url {
    my ($path,$param) = @_;
    my @url_array = split(/\//,$path);

    # ex: '/',
    if( scalar(@url_array) == 0 ){
        push ( @url_array,'',scalar($param)+1 );

    # ex: '/4', '/event/1', '/event/0'
    }elsif( $url_array[-1] =~ /^[0-9]+$/ ){
        $url_array[-1] = scalar ( $url_array[-1] ) +1;

    # ex: '/event', '/club'
    }else{
        push( @url_array, scalar($param)+1 );
    }
    return join('/',@url_array);
}


sub _get_previous_url {
    my ($path,$param) = @_;
    my @url_array = split(/\//,$path);

    # ex: '/',
    if( scalar(@url_array) == 0 ){  
        push ( @url_array,'',$param );

    # ex: '/4', '/event/1'
    }elsif( $url_array[-1] =~ /^[0-9]+$/ ){
        $url_array[-1] = ( $url_array[-1] <= 1 ) ? 1 : scalar ( $url_array[-1] ) -1;

    # ex: '/event', '/club'
    }else{
        $param = (scalar($param) == 1) ? $param : scalar($param)-1 ;
        push(@url_array,$param);
    }
    return join('/',@url_array);
}


sub _get_data_num_per_page {
    my $ua = shift;
    ( $ua =~/iPhone/ || $ua =~/Android/ ) ? DATA_PER_PAGE_FOR_SP() : DATA_PER_PAGE_FOR_PC();
}


sub _get_offset {
    my ($ua,$param) = @_;
    my $num_per_page = ( $ua =~/iPhone/ || $ua =~/Android/ ) ? DATA_PER_PAGE_FOR_SP() : DATA_PER_PAGE_FOR_PC();
    return $num_per_page * ( scalar($param)-1 );
}

sub _get_bread {
    my ($path,$param) = @_;
    #¹©»öÃæ
    return 1;
}

sub _is_sp {
    my $ua = shift;
    ( $ua =~/iPhone/ || $ua =~/Android/ ) ? 1 : undef ;
}

sub to_hashref{
    my ($self) = @_;
    my %hash = map { $_ => $self->{$_} } grep { /^[a-z]/ } keys %$self;
    \%hash;
}

1;
