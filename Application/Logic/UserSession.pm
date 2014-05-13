package Logic::UserSession;

use strict;
use warnings;
use Data::Dumper;
use MIME::Base64;
use Digest::SHA;

use lib '../';
use Config::Login;
use Config::Const;

use lib '../../';
use Model::UserSession;
use Model::UserData;
use Model::UserTwitterData;

use lib '/home/onda/dotfiles';
use Utility::Common;

use base qw(Class::Accessor::Fast Class::Data::Inheritable);
__PACKAGE__->mk_accessors( qw/ session_seed user_id user_name is_first_landing my_user_url/ );


#���ڡ������̽������桼�����󥹥��󥹤���������
sub build_user_data {
    my ($class,$args) = @_;
    my $session_seed = $args->{session_seed} || undef;

    #�桼�������å������ݻ����Ƥ��ʤ���硢�ǥե���ȥ桼���Υ��󥹥��󥹤��֤�
    return $class->_get_guest_user() unless($session_seed);

    #user_id�򸡺�
    my $user_data = Model::UserSession->single(+{
        session_seed => $session_seed,
    });

    #user_id�����Ĥ���ʤ���硢�ǥե���ȥ桼���Υ��󥹥��󥹤��֤�
    return $class->_get_guest_user() unless($user_data);

    #�桼���ܺپ�������
    my $user_detail = Model::UserTwitterData->single(+{
        user_id => $user_data->user_id,
    });

    #user�ܺپ��󤬸��Ĥ���ʤ���硢�ǥե���ȥ桼���Υ��󥹥��󥹤��֤�
    return $class->_get_guest_user() unless($user_detail);
    
    #���󥹥�������.�Ƽ�ѥ�᡼���Ϥ��Τޤޥƥ�ץ졼�Ȥ��Ϥ����
    my $user_data_instance = bless +{
        session_seed        => $session_seed,
        user_id             => $user_data->user_id,
        user_name           => $user_detail->screen_name,
        is_first_landing    => undef,
        my_user_url         => "/user/detai/".$user_data->user_id,
    },$class;
}

#������ɬ�ܥڡ�����Ƚ��
sub is_login_nesessary {
    my ($class,$request_url) = @_;
    my $login_nesessary_pages = Config::Login->get_login_nesessary_page;  # array_ref

    for my $page ( @$login_nesessary_pages ){
        return 1 if( $request_url =~ /$page/ );
    }
    return;
}


#̤������: return 1
sub is_login_already {
    my ($self) = shift;
    return ($self->user_id) ? 1 : undef;
}


#twitter_user_id����session_seedȯ��=>DB��Ǽ
sub set_and_get_user_session_seed {
    my ($class,$args) = @_;

    my $user_id_twitter     = $args->{user_id_twitter};
    my $access_token        = $args->{access_token};
    my $access_token_secret = $args->{access_token_secret};
    my $screen_name         = $args->{screen_name};

    #session_seed����
    my $session_seed = _create_session_seed(+{
        user_id             => $user_id_twitter,
        access_token        => $access_token,
        access_token_secret => $access_token_secret,
    });

    unless ( _is_login_before($session_seed) ){

        #DB��Ǽ&��������IDȯ��
        my $user_id = Model::UserSession->insert(+{
            session_seed => $session_seed
        });

        my $row = Model::UserTwitterData->insert(+{
            user_id     => $user_id,
            screen_id   => $user_id_twitter,
            screen_name => $screen_name,
            profile     => "test profile",
            image       => "hoge.png",
        });

    }

    return $session_seed;
}

sub _is_login_before {
    my $session_seed = shift;
    my $row = Model::UserSession->single(+{
        session_seed => $session_seed
    });
    return ($row) ? 1 : undef;
}

#�桼�����ݻ�������session_seed������
sub _create_session_seed {
    my $args = shift;
    my $user_id             = $args->{user_id};
    my $access_token        = $args->{access_token};
    my $access_token_secret = $args->{access_token_secret};

    my $base_string  = join '&' , $user_id, $access_token, $access_token_secret;
    my $config = Config::Const->get_twtter_key;
    my $session_seed = MIME::Base64::encode_base64(Digest::SHA::hmac_sha1($base_string,$config->{consumer_secret}));

    return $session_seed;
}


#̤��������Υ桼���ǡ��������
sub _get_guest_user {
    my $class = shift;
    my $user_data = bless +{
        session_seed        => undef,
        user_id             => undef,
        user_name           => "Guest User",
        is_first_landing    => undef,
        my_user_url         => "/login",
    },$class;
}


1;
