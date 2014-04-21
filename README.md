ClubMania
=========

##各種連絡先
* facebook:https://www.facebook.com/groups/559898830783667/
* Dropbox:https://www.dropbox.com/home/Partynight.com

## 参考資料
* ER図：https://cacoo.com/diagrams/ZEflSZzOJKlSYmDA#_=_
* Twitter_Developer:https://apps.twitter.com/app/6073702/keys_

## マークアップ参考情報
* それぞれテンプレート毎に内部で各種関連データを取得してテンプレートに渡している
* 共通で渡される変数は下記参照
* https://github.com/takuya542/ClubMania/wiki/%E5%85%B1%E9%80%9A%E3%81%A7%E3%83%86%E3%83%B3%E3%83%97%E3%83%AC%E3%83%BC%E3%83%88%E3%81%AB%E6%B8%A1%E3%81%95%E3%82%8C%E3%82%8B%E5%A4%89%E6%95%B0

###イベント詳細
* 関連データ(1:1対応)：主催者のDJ、クラブ情報、地理情報
* 関連データ(1:複数 )：有効期間中のクーポン,参加予定ユーザ情報

```
# URL:/event/detail/event_id
# 変数のフォーマットは以下参照
$event_data = +{

    event_id,        #イベント情報
    event_name,
    detail,
    link,
    genre,
    social_link,
    owner_id,
    club_id,
    location_id,
    start_date,
    end_date,
    is_powerpush,
    event_url('/event/detail/event_id')

    owner_id,        #DJ情報
    owner_name,
    detail,
    link,
    image,
    social_link,
    owner_url('/owner/detail/owber_id')

    location_id,     #地理情報
    location_name,
    detail,
    image,
    location_url('/location/detail/location_id')

    club_id          #クラブ情報
    club_name,
    detail,
    link,
    image,
    genre,
    max_popularity,
    open_time,
    close_time,
    entrance_price
    club_url('/club/detail/club_id')

    user_date => [      # 参加者情報
        +{
            user_id,    #参加者一人目
            user_name,
            detail,
            image,
            link,
            user_url('/user/detail/user_id')
        },
        +{
            user_id,    #参加者二人目
            user_name,
            detail,
            image,
            link,
            user_url('/user/detail/user_id')
        }
        ・
        ・
        ・
    ],

    coupon_data => [         #クーポン情報
        +{
            coupon_id,       #このイベントに対して有効なクーポン1件目
            coupon_name,
            detail,
            image,
            max_distributed,
            start_date,
            expire_date,
            coupon_url('/coupon/detail/coupon_id')
        },
        +{
            coupon_id,       #このイベントに対して有効なクーポン2件目
            coupon_name,
            detail,
            image,
            max_distributed,
            start_date,
            expire_date,
            coupon_url('/coupon/detail/coupon_id')
        },
        ・
        ・
        ・
    ]
}

```


###クラブ詳細
* 関連データ(1:1対応)：地理情報
* 関連データ(1:複数 )：そのクラブで開催されるイベント => Max:最新5件

```
# URL:/club/detail/club_id
# 変数のフォーマットは以下参照
$club_data = +{

    club_id          #クラブ情報
    club_name,
    detail,
    link,
    image,
    genre,
    max_popularity,
    open_time,
    close_time,
    entrance_price
    club_url('/club/detail/club_id')

    location_id,     #地理情報
    location_name,
    detail,
    image,
    location_url('/location/detail/location_id')

    event_date => [      # イベント情報
        +{
            event_id,        #イベント一件目
            event_name,
            detail,
            link,
            genre,
            social_link,
            owner_id,
            club_id,
            location_id,
            start_date,
            end_date,
            is_powerpush,
            event_url('/event/detail/event_id')
        },
        +{
            event_id,        #イベント2件目
            event_name,
            detail,
            link,
            genre,
            social_link,
            owner_id,
            club_id,
            location_id,
            start_date,
            end_date,
            is_powerpush,
            event_url('/event/detail/event_id')
        },
        ・
        ・
        ・
    ]
};


###クーポン詳細
* 関連データ(1:1対応)：イベント情報,イベントの開催されるクラブ情報、イベントの開催者(DJ)情報
* 関連データ(1:複数 )：このクーポンを取得しているユーザ情報

```
# URL:/club/detail/club_id
# 変数のフォーマットは以下参照
$club_data = +{

    club_id          #クラブ情報
