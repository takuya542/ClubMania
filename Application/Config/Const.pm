package Config::Const;

use strict;
use warnings;

sub CONSUMER_KEY {'O6HuVarYF1SHsRWJcRAOw'}
sub CONSUMER_SECRET {'sTLMUpLbXzSjQem4AdMETma09APLhZpaFflUa5YG1kk'}
sub ACCESS_TOKEN {'2303902369-JyO4IhHC0wephm7L3Zhs68tAsrzxUrakA0TWfuI'}
sub ACCESS_TOKEN_SECRET {'JGyGVMyDR0shqADZcaef6yIfMPdXpaz3I4Wi7c9dCbBRU'}

sub get_twtter_key {
    return +{
        consumer_key        => CONSUMER_KEY(),
        consumer_secret     => CONSUMER_SECRET(),
        access_token        => ACCESS_TOKEN(),
        access_token_secret => ACCESS_TOKEN_SECRET(),
    };
}

1;
