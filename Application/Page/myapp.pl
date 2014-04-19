#!/usr/bin/env perl
use Mojolicious::Lite;

use Encode;
use Encode::Guess qw/shift-jis euc-jp/;
use Data::Dumper;
use lib '../';

use Logic::EventData;
use Logic::ClubData;
use Logic::OwnerData;
use Logic::LocationData;
use Logic::UserData;
use Logic::CouponData;
use Logic::Paging;


# ホーム
get '/:page' => { page => undef } => sub {
    my $self        = shift;
    my $paging = Logic::Paging->build_paging(+{ 
        request => $self->req, 
        param   => $self->param('page') || 1,
    });
    $self->app->log->debug(Dumper($self->req));
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
    $self->app->log->debug("event_detail:".Dumper($self->stash));
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
