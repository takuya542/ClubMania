# ---------------------------------------
# DB作成

drop   database if exists ClubMania;
create database           ClubMania;
use                       ClubMania;

# ---------------------------------------
# イベント情報

create table event_data(
  event_id      int           unsigned not null,
  event_name    varchar(1000)          not null,
  detail        varchar(1000)          not null,
  image         varchar(255)           not null,
  link          varchar(255)           not null,
  genre         varchar(255)           not null,
  social_link   varchar(255)           not null,
  owner_id      int           unsigned not null,
  club_id       int           unsigned not null,
  location_id   int           unsigned not null,
  start_date    int           unsigned not null,
  end_date      int           unsigned not null,
  is_powerpush  int           unsigned not null,
  reg_date      int           unsigned not null
) type=InnoDB;

alter table event_data 
 add primary key      (event_id),
 add         index i1 (owner_id),
 add         index i2 (club_id),
 add         index i3 (location_id),
 add         index i4 (start_date);


# ---------------------------------------
# 主催者情報

create table owner_data(
  owner_id      int           unsigned not null,
  owner_name    varchar(1000)          not null,
  detail        varchar(1000)          not null,
  link          varchar(255)           not null,
  image         varchar(255)           not null,
  social_link   varchar(255)           not null,
  reg_date      int           unsigned not null
) type=InnoDB;

alter table owner_data 
 add primary key      (owner_id),
 add         index i1 (owner_name);


# ---------------------------------------
# イベント参加者情報

create table event_user_rel(
  event_id      int           unsigned not null,
  user_id       int           unsigned not null,
  reg_date      int           unsigned not null
) type=InnoDB;

alter table event_user_rel
 add primary key      (event_id,user_id),
 add         index i1 (user_id);


# ---------------------------------------
# クーポン付与状況管理

create table user_coupon_rel(
  user_id       int           unsigned not null,
  event_id      int           unsigned not null,
  coupon_id     int           unsigned not null,
  reg_date      int           unsigned not null
) type=InnoDB;

alter table user_coupon_rel
 add primary key      (user_id,event_id,coupon_id),
 add         index i1 (user_id),
 add         index i2 (event_id),
 add         index i3 (coupon_id);


# ---------------------------------------
# ユーザ情報

create table user_data(
  user_id       int           unsigned not null,
  user_name     varchar(1000)          not null,
  detail        varchar(1000)          not null,
  image         varchar(255)           not null,
  link          varchar(255)           not null,
  reg_date      int           unsigned not null
) type=InnoDB;


alter table user_data
 add primary key      (user_id),
 add         index i1 (user_name),
 add         index i2 (reg_date);


# ---------------------------------------
# クーポン情報

create table coupon_data(
  coupon_id       int           unsigned not null,
  coupon_name     varchar(1000)          not null,
  detail          varchar(1000)          not null,
  image           varchar(255)           not null,
  event_id        int           unsigned not null,
  max_distribute  int           unsigned not null,
  start_date      int           unsigned not null,
  expire_date     int           unsigned not null,
  reg_date        int           unsigned not null
) type=InnoDB;

alter table coupon_data
 add primary key      (coupon_id),
 add         index i1 (event_id),
 add         index i2 (start_date);

# ---------------------------------------
# 地域情報

create table location_data(
  location_id       int         unsigned not null,
  location_name   varchar(255)           not null,
  detail          varchar(1000)          not null,
  image           varchar(255)           not null,
  reg_date        int           unsigned not null
) type=InnoDB;

alter table location_data
 add primary key      (location_id),
 add         index i1 (location_name);


# ---------------------------------------
# ユーザ嗜好管理(基本batchから更新される前提)

create table user_pref(
  user_id       int         unsigned not null,
  club_id       int         unsigned not null,
  location_id   int         unsigned not null,
  genre         varchar(255)         not null,
  updated_at    int         unsigned not null
) type=InnoDB;

alter table user_pref
 add primary key      (user_id),
 add         index i1 (club_id),
 add         index i2 (location_id),
 add         index i3 (genre);


# ---------------------------------------
# Twitterログインで取得するユーザ情報管理テーブル

create table user_twitter_data(
  user_id       int           unsigned not null,
  screen_id     int           unsigned not null,
  screen_name   varchar(1000)          not null,
  profile       varchar(1000)          not null,
  image         varchar(255)           not null,
  reg_date      int           unsigned not null
) type=InnoDB;


alter table user_twitter_data
 add primary key      (user_id),
 add         index i1 (screen_id),
 add         index i2 (screen_name);

# ---------------------------------------
# クーポン付与件数管理

create table coupon_count(
  coupon_id       int         unsigned not null,
  distributed_num int         unsigned not null,
  updated_at      int         unsigned not null
) type=InnoDB;


alter table coupon_count 
 add primary key      (coupon_id);


# ---------------------------------------
# 各クラブとlocation情報の関係テーブル

create table location_club_rel(
  location_id   int           unsigned not null,
  club_id       int           unsigned not null,
  reg_date      int           unsigned not null
) type=InnoDB;


alter table location_club_rel
 add primary key      (location_id,club_id),
 add         index i1 (club_id);


# ---------------------------------------
# クラブ情報管理テーブル

create table club_data(
  club_id         int           unsigned not null,
  club_name       varchar(1000)          not null,
  detail          varchar(1000)          not null,
  link            varchar(255)           not null,
  image           varchar(255)           not null,
  genre           varchar(255)           not null,
  max_popularity  int           unsigned not null,
  open_time       varchar(255)           not null,
  close_time      varchar(255)           not null,
  entrance_price  int                    not null,
  reg_date        int           unsigned not null
) type=InnoDB;


alter table club_data
 add primary key      (club_id),
 add         index i1 (club_name);



# ---------------------------------------
# シーケンステーブル(event_data)

create table seq_event (
  id        int               unsigned not null
) type=Myisam;

alter table seq_event
 add primary key (id);

insert into seq_event values(1);


# ---------------------------------------
# シーケンステーブル(owner_data)

create table seq_owner (
  id        int               unsigned not null
) type=Myisam;

alter table seq_owner
 add primary key (id);

insert into seq_owner values(1);


# ---------------------------------------
# シーケンステーブル(user_data)
create table seq_user (
  id        int               unsigned not null
) type=Myisam;

alter table seq_user
 add primary key (id);

insert into seq_user values(1);


# ---------------------------------------
# シーケンステーブル(coupon_data)
create table seq_coupon (
  id        int               unsigned not null
) type=Myisam;

alter table seq_coupon
 add primary key (id);

insert into seq_coupon values(1);


# ---------------------------------------
# シーケンステーブル(location_data)
create table seq_location (
  id        int               unsigned not null
) type=Myisam;

alter table seq_location
 add primary key (id);

insert into seq_location values(1);


# ---------------------------------------
# シーケンステーブル(club_data)
create table seq_club (
  id        int               unsigned not null
) type=Myisam;

alter table seq_club
 add primary key (id);

insert into seq_club values(1);


