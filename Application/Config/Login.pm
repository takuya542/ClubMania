package Config::Login;

use strict;

sub LOGIN_NESESSARY {
    [qw/
    coupon
    event
    /]
}

sub get_login_nesessary_page {
    return LOGIN_NESESSARY();
}

1;
