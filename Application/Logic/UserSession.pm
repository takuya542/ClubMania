package Logic::UserSession;

use strict;
use warnings;
use Data::Dumper;

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

#全ページ共通処理。ユーザインスタンスを生成する
sub build_user_data {
    my ($class,$args) = @_;
    my $session_seed = $args->{session_seed} || undef;

    #ユーザがセッションを保持していない場合、デフォルトユーザのインスタンスを返す
    #return $class->_get_guest_user() unless($session_seed);
    die "session not found" unless($session_seed);

    #user_idを検索
    my $user_data = Model::UserSession->single(+{
        session_seed => $session_seed,
    });

    #user_idが見つからない場合、デフォルトユーザのインスタンスを返す
    return $class->_get_guest_user() unless($user_data);

    #ユーザ詳細情報を取得
    my $user_detail = Model::UserTwitterData->single(+{
        user_id => $user_data->user_id,
    });

    #for debug
    Utility::Common->dump($user_data);
    Utility::Common->dump($user_detail);

    #user詳細情報が見つからない場合、デフォルトユーザのインスタンスを返す
    return $class->_get_guest_user() unless($user_detail);
    
    #インスタンス生成.各種パラメータはそのままテンプレートに渡される
    my $user_data_instance = bless +{
        session_seed        => $session_seed,
        user_id             => $user_data->user_id,
        user_name           => $user_detail->screen_name,
        is_first_landing    => undef,
        my_user_url         => "/user/detai/$user_data->user_id",
    },$class;
}

#ログイン必須ページか判定
sub is_login_nesessary {
    my ($class,$request_url) = @_;
    my $login_nesessary_pages = Config::Login->get_login_nesessary_page;  # array_ref

    for my $page ( @$login_nesessary_pages ){
        return 1 if( $request_url =~ /$page/ );
    }
    return 1;
}

#未ログイン: return 1
sub is_login_already {
    my ($self) = shift;
    return ($self->user_id) ? 1 : undef;
}

#twitter_user_idからsession_seed発行=>DB格納
sub set_and_get_user_session_seed {
    my ($class,$args) = @_;

    my $user_id_twitter     = $args->{user_id_twitter};
    my $access_token        = $args->{access_token};
    my $access_token_secret = $args->{access_token_secret};
    my $screen_name         = $args->{screen_name};

    #session_seed生成
    my $session_seed = _create_session_seed($user_id_twitter);

    #DB格納&シーケンスID発行
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
    die if($row == 0);

    return $session_seed;

}


sub _create_session_seed {
    my $user_id = shift;

    #工事中

    return "123";
}

sub _get_guest_user {
    my $class = shift;
    my $user_data = bless +{
        session_seed        => undef,
        user_id             => undef,
        user_name           => "Guest",
        is_first_landing    => undef,
        my_user_url         => "/login",
    },$class;
}


1;
