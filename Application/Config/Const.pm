package Config::Const;

use strict;
use warnings;

sub CONSUMER_KEY    {'DCzHXGtnEuQZM5aVBCoJtBYS3'}
sub CONSUMER_SECRET {'vcxblDEa4h4IapJRP05LBsBRa7dJOYb0aofFvEaGUl2p17MpTk'}
sub ACCESS_TOKEN        {'2457619003-BY3zdKpRuHWxNr50ZfSa2RCZJaCeZtdwgTwVgqz'}
sub ACCESS_TOKEN_SECRET {'dNze0yxuItKZV4SzmIu1q5knkqIXllMERty3FMLQWE39J'}

sub get_twtter_key {
    return +{
        consumer_key        => CONSUMER_KEY(),
        consumer_secret     => CONSUMER_SECRET(),
        access_token        => ACCESS_TOKEN(),
        access_token_secret => ACCESS_TOKEN_SECRET(),
    };
}

1;
