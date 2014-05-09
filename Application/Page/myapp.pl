#!/usr/bin/env perl
use Mojolicious::Lite;
use Net::Twitter::Lite::WithAPIv1_1;

use Encode;
use Encode::Guess qw/shift-jis euc-jp/;
use Data::Dumper;
use lib '../';

use Config::Const;
use Logic::EventData;
use Logic::ClubData;
use Logic::OwnerData;
use Logic::LocationData;
use Logic::UserData;
use Logic::CouponData;
use Logic::Paging;
use Logic::UserSession;

#ログ吐き方
#$self->app->log->debug(Dumper($self->stash->{event_data}));

# twitter認証
our $config = Config::Const->get_twtter_key;
our $nt = Net::Twitter::Lite::WithAPIv1_1->new(
    consumer_key        => $config->{consumer_key},
    consumer_secret     => $config->{consumer_secret},
    access_token        => $config->{access_token},
    access_token_secret => $config->{access_token_secret},
    ssl                 => 1,
);

# ログイン訴求ページ
get '/login_before' => sub{
    my $self = shift;
    my $ua   = $self->req->headers->user_agent;
    ( $ua =~/iPhone/ || $ua =~/Android/ ) ? $self->render('sp/login') : $self->render('pc/login');
};

# ログイン
get '/login' => sub{
    my $self = shift;

    #ユーザ情報を生成
    my $user_data = Logic::UserSession->build_user_data(+{
        session_seed => $self->session('session_seed') || undef,
    });

    #既にログイン済みならトップにリダイレクト
    if ( $user_data->is_login_already ){
        $self->redirect_to("/");
        return;
    }

    #リクエストトークン取得
    my $request_url     = $nt->get_authorization_url(
        callback => $self->req->url->base.'/callback'
    );

    #リクエストトークンセット
    $self->session( expiration => (60 * 60 * 24 * 365 * 30) );
    $self->session( 'token'                     =>  $nt->request_token );
    $self->session( 'token_secret'              =>  $nt->request_token_secret );

    # ログイン画面へユーザをリダイレクトさせる
    $self->redirect_to($request_url);
};


get '/callback' => sub {
    my $self = shift;

    unless ( $self->req->param('denied') ) {

        #request_token取得
        $nt->request_token( $self->session('token') );
        $nt->request_token_secret( $self->session('token_secret') );

        my $verifier = $self->req->param('oauth_verifier');
        my ( $access_token, $access_token_secret, $user_id_twitter, $screen_name ) =
            $nt->request_access_token( verifier => $verifier );

        #consumer_key,consumer_secret,user_idを元にsession_seedを生成=>DB格納
        my $session_seed = Logic::UserSession->set_and_get_user_session_seed(+{
            user_id_twitter     => $user_id_twitter,
            screen_name         => $screen_name,
            access_token        => $access_token,
            access_token_secret => $access_token_secret,
        });

        # セッション発行
        $self->session( 'session_seed'         => $session_seed );

    }

    #ログイン前にいたページに戻す
    $self->redirect_to( $self->session('redirect_url_after_login') || "/");
};

# ログアウト
get '/logout' => sub {
    my $self = shift;
    $self->session( expires => 1 );
    $self->redirect_to("/");
};

under sub {
    my $self = shift;

    #ユーザ情報を生成
    my $user_data = Logic::UserSession->build_user_data(+{
        session_seed => $self->session('session_seed') || undef,
    });

    #リクエストURLを取得
    my $request_url = $self->req->url->path->{path};

    #ログイン必須画面がチェック
    if ( Logic::UserSession->is_login_nesessary($request_url) ){

        #未ログインならログイン画面へ飛ばす
        unless ( $user_data->is_login_already ){

            #ログイン後に移動するURLをセッションで保持する
            $self->session( 'redirect_url_after_login' => $request_url );
            $self->redirect_to("/login_before");
        }

    }
    $self->stash(+{ user_data => $user_data });   #参照 at template：user_data->{user_name};
    return 1;
};


# ホーム
get '/:page' => { page => undef } => sub {
    my $self   = shift;
    my $paging = Logic::Paging->build_paging(+{ 
        request => $self->req, 
        param   => $self->param('page') || 1,
    });

    my $event_data = Logic::EventData->new($paging)->get_multi_event_data;
    $self->stash($event_data);

    ( $paging->is_sp ) ? $self->render('sp/index') : $self->render('pc/index')
};


# event一覧
get '/event/:page' => { page => undef } => sub{
    my $self = shift;
    my $paging = Logic::Paging->build_paging(+{ 
        request => $self->req, 
        param   => $self->param('page') || 1,
    });
    my $event_data  = Logic::EventData->new($paging)->get_multi_event_data;
    $self->stash($event_data);
    ( $paging->is_sp ) ? $self->render('sp/event') : $self->render('pc/event')
};


# event詳細
get '/event/detail/:id' => sub{
    my $self = shift;
    my $paging = Logic::Paging->build_paging(+{ 
        request => $self->req, 
        param   => $self->param('id'),
    });
    my $event_data = Logic::EventData->new($paging)->get_single_event_data;
    $self->stash($event_data);
    ( $paging->is_sp ) ? $self->render('sp/event_detail') : $self->render('pc/event_detail')
};


# クラブ一覧
get 'club/:page' => { page => undef  } => sub{
    my $self = shift;
    my $paging = Logic::Paging->build_paging(+{ 
        request => $self->req, 
        param   => $self->param('page') || 1,
    });
    my $club_data  = Logic::ClubData->new($paging)->get_multi_club_data;
    $self->stash($club_data);
    ( $paging->is_sp ) ? $self->render('sp/club') : $self->render('pc/club')
};


# クラブ詳細
get 'club/detail/:id' => sub{
    my $self = shift;
    my $paging = Logic::Paging->build_paging(+{ 
        request => $self->req, 
        param   => $self->param('id'),
    });
    my $club_data = Logic::ClubData->new($paging)->get_single_club_data;
    $self->stash($club_data);
    ( $paging->is_sp ) ? $self->render('sp/club_detail') : $self->render('pc/club_detail')
};


# クーポン一覧
get 'coupon/:page' => { page => undef  } => sub{
    my $self = shift;
    my $paging = Logic::Paging->build_paging(+{ 
        request => $self->req, 
        param   => $self->param('page') || 1,
    });
    my $coupon_data = Logic::CouponData->new($paging)->get_multi_coupon_data;
    $self->stash($coupon_data);
    ( $paging->is_sp ) ? $self->render('sp/coupon') : $self->render('pc/coupon')
};


# クーポン詳細
get 'coupon/detail/:id' => sub{
    my $self = shift;
    my $paging = Logic::Paging->build_paging(+{ 
        request => $self->req, 
        param   => $self->param('id'),
    });
    my $coupon_data = Logic::CouponData->new($paging)->get_single_coupon_data;
    $self->stash($coupon_data);
    ( $paging->is_sp ) ? $self->render('sp/coupon_detail') : $self->render('pc/coupon_detail')
};


# マップ一覧
get 'location/:page' => { page => undef  } => sub{
    my $self = shift;
    my $paging = Logic::Paging->build_paging(+{ 
        request => $self->req, 
        param   => $self->param('page') || 1,
    });
    my $location_data = Logic::LocationData->new($paging)->get_multi_location_data;
    $self->stash($location_data);
    ( $paging->is_sp ) ? $self->render('sp/location') : $self->render('pc/location')
};


# マップ詳細(六本木とか渋谷とか)
get 'location/detail/:id' => sub{
    my $self = shift;
    my $paging = Logic::Paging->build_paging(+{ 
        request => $self->req, 
        param   => $self->param('id'),
    });
    my $location_data = Logic::LocationData->new($paging)->get_sngle_location_data;
    $self->stash($location_data);
    ( $paging->is_sp ) ? $self->render('sp/location_detail') : $self->render('pc/location_detail')
};


# 主催者一覧(DJ)
get 'owner/:page' => { page => undef  } => sub{
    my $self = shift;
    my $paging = Logic::Paging->build_paging(+{ 
        request => $self->req, 
        param   => $self->param('page') || 1,
    });
    my $owner_data = Logic::OwnerData->new($paging)->get_multi_owner_data;
    $self->stash($owner_data);
    ( $paging->is_sp ) ? $self->render('sp/owner') : $self->render('pc/owner')
};


# 主催者詳細
get 'owner/detail/:id' => sub{
    my $self = shift;
    my $paging = Logic::Paging->build_paging(+{ 
        request => $self->req, 
        param   => $self->param('id'),
    });
    my $owner_data = Logic::OwnerData->new($paging)->get_single_owner_data;
    $self->stash($owner_data);
    ( $paging->is_sp ) ? $self->render('sp/owner_detail') : $self->render('pc/owner_detail')
};


# ユーザ一覧
get 'user/:page' => { page => undef  } => sub{
    my $self = shift;
    my $paging = Logic::Paging->build_paging(+{ 
        request => $self->req, 
        param   => $self->param('page') || 1,
    });
    my $user_data = Logic::UserData->new($paging)->get_multi_user_data;
    $self->stash($user_data);
    ( $paging->is_sp ) ? $self->render('sp/user') : $self->render('pc/user')
};


# ユーザ詳細
get 'user/detail/:id' => sub{
    my $self = shift;
    my $paging = Logic::Paging->build_paging(+{ 
        request => $self->req, 
        param   => $self->param('id'),
    });
    my $user_data = Logic::UserData->new($paging)->get_single_user_data;
    $self->stash($user_data);
    ( $paging->is_sp ) ? $self->render('sp/user_detail') : $self->render('pc/user_detail')
};

app->start;
