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

# twitter認証
our $config = Config::Const->get_twtter_key;
our $nt = Net::Twitter::Lite::WithAPIv1_1->new(
    consumer_key        => $config->{consumer_key},
    consumer_secret     => $config->{consumer_secret},
    access_token        => $config->{access_token},
    access_token_secret => $config->{access_token_secret},
    ssl                 => 1,
);

get '/login' => sub {
    my $self = shift;


    #$self->app->log->debug(Dumper($self->session));
    #$self->app->log->debug( $self->req->url->base.'/callback' );
    #$self->app->log->debug(Dumper($config));
    #$self->app->log->debug(Dumper($nt));

    my $url     = $nt->get_authorization_url(
        callback => $self->req->url->base.'/callback'
    );
    $self->session(expiration => (60 * 60 * 24 * 365 * 30));
    $self->session( 'token'                 =>  $nt->request_token );
    $self->session( 'token_secret'          =>  $nt->request_token_secret );
    $self->session( 'redirect_after_login'  =>  '/' );
    $self->redirect_to($url);
    $self->redirect_to('/');
};


get '/callback' => sub {
    my $self = shift;

    unless ( $self->req->param('denied') ) {

        #request_token取得
        $nt->request_token( $self->session('token') );
        $nt->request_token_secret( $self->session('token_secret') );

        my $verifier = $self->req->param('oauth_verifier');
        my ( $access_token, $access_token_secret, $user_id, $screen_name ) =
            $nt->request_access_token( verifier => $verifier );

        # セッション発行
        $self->session( 'access_token'         => $access_token );
        $self->session( 'access_token_secret'  => $access_token_secret );
        $self->session( 'screen_name'          => $screen_name );

    }
    $self->redirect_to( $self->session('redirect_after_login') );
};



# ホーム
get '/:page' => { page => undef } => sub {
    my $self        = shift;
    my $paging = Logic::Paging->build_paging(+{ 
        request => $self->req, 
        param   => $self->param('page') || 1,
    });
    my $event_data = Logic::EventData->new($paging)->get_multi_event_data;
    $self->stash($event_data);
    ( $paging->is_sp ) ? $self->render('sp/index') : $self->render('pc/index')
};


# event一覧ページ
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


# event詳細ページ
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
    $self->app->log->debug("club_list:".Dumper($club_data));
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



# --------------------------------
# 以下工事中
# -------------------------------


# クーポン一覧ページ
get 'coupon/:page' => { page => undef  } => sub{
    my $self = shift;
    my $paging = Logic::Paging->build_paging(+{ 
        request => $self->req, 
        param   => $self->param('page') || 1,
    });
    $self->stash(+{ paging => $paging });
    ( $paging->is_sp ) ? $self->render('sp/coupon') : $self->render('pc/coupon')
};

# クーポン詳細ページ
get 'coupon/detail/:id' => sub{
    my $self = shift;
    my $paging = Logic::Paging->build_paging(+{ 
        request => $self->req, 
        param   => $self->param('id'),
    });
    $self->stash(+{ paging => $paging });
    ( $paging->is_sp ) ? $self->render('sp/coupon_detail') : $self->render('pc/coupon_detail')
};


# マップ一覧
get 'location/:page' => { page => undef  } => sub{
    my $self = shift;
    my $paging = Logic::Paging->build_paging(+{ 
        request => $self->req, 
        param   => $self->param('page') || 1,
    });
    $self->stash(+{ paging => $paging });
    ( $paging->is_sp ) ? $self->render('sp/location') : $self->render('pc/location')
};

# マップ詳細(六本木とか渋谷とか)
get 'location/detail/:id' => sub{
    my $self = shift;
    my $paging = Logic::Paging->build_paging(+{ 
        request => $self->req, 
        param   => $self->param('id'),
    });
    $self->stash(+{ paging => $paging });
    ( $paging->is_sp ) ? $self->render('sp/location_detail') : $self->render('pc/location_detail')
};

# 主催者一覧
get 'owner/:page' => { page => undef  } => sub{
    my $self = shift;
    my $paging = Logic::Paging->build_paging(+{ 
        request => $self->req, 
        param   => $self->param('page') || 1,
    });
    $self->stash(+{ paging => $paging });
    ( $paging->is_sp ) ? $self->render('sp/owner') : $self->render('pc/owner')
};

# 主催者詳細
get 'owner/detail/:id' => sub{
    my $self = shift;
    my $paging = Logic::Paging->build_paging(+{ 
        request => $self->req, 
        param   => $self->param('id'),
    });
    $self->stash(+{ paging => $paging });
    ( $paging->is_sp ) ? $self->render('sp/owner_detail') : $self->render('pc/owner_detail')
};

# ユーザ一覧
get 'user/:page' => { page => undef  } => sub{
    my $self = shift;
    my $paging = Logic::Paging->build_paging(+{ 
        request => $self->req, 
        param   => $self->param('page') || 1,
    });
    $self->stash(+{ paging => $paging });
    ( $paging->is_sp ) ? $self->render('sp/user') : $self->render('pc/user')
};

# ユーザ詳細
get 'user/detail/:id' => sub{
    my $self = shift;
    my $paging = Logic::Paging->build_paging(+{ 
        request => $self->req, 
        param   => $self->param('id'),
    });
    $self->stash(+{ paging => $paging });
    ( $paging->is_sp ) ? $self->render('sp/user_detail') : $self->render('pc/user_detail')
};

#------------------------------
#以下、リダイレクト処理
get 'index' => sub {
    my $self = shift;
    $self->redirect_to('/');
};


app->start;
