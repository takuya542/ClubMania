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

###イベント詳細
* イベント一件の詳細+
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
    owner_id,        #DJ情報
    owner_name,
    detail,
    link,
    image,
    social_link,
    location_id,     #地理情報
    location_name,
    detail,
    image,
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
    user_date => [
        +{
            user_id,    #参加者一人目
            user_name,
            detail,
            image,
            link,
        },
        +{
            user_id,    #参加者二人目
            user_name,
            detail,
            image,
            link,
        }
        ・
        ・
        ・
    ],
    coupon_data => [
        +{
            coupon_id,       #このイベントに対して有効なクーポン1件目
            coupon_name,
            detail,
            image,
            max_distributed,
            start_date,
            expire_date,
        },
        +{
            coupon_id,       #このイベントに対して有効なクーポン2件目
            coupon_name,
            detail,
            image,
            max_distributed,
            start_date,
            expire_date,
        }
        ・
        ・
        ・
    ]
}

```

