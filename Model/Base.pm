package Model::Base;

use strict;
use warnings;

use SQL::Abstract;
use SQL::Abstract::Limit;
use SQL::Abstract::Plugin::InsertMulti;
use DBI;
use SQL::Maker;

use DBI;
use Data::Lock qw(dlock);
use List::MoreUtils qw(all);
use Hash::Merge qw(merge);
use Carp;
use Data::Dumper;
use parent qw(Class::Accessor::Fast Class::Data::Inheritable);

__PACKAGE__->mk_classdata('db');
__PACKAGE__->mk_classdata('table');
__PACKAGE__->mk_classdata('seq_key');
__PACKAGE__->mk_classdata('seq_table');
__PACKAGE__->mk_classdata('columns');
__PACKAGE__->mk_classdata('index');


dlock  my $DS   ="dbi:mysql:nukippo:localhost";
dlock  my $USER ="root";
dlock  my $PASS ="";
dlock  my $OPT  ={};

 my $sql = SQL::Maker->new( driver =>'mysql' );


# ------------- 共通処理 --------------
# 内部的に呼ばれるので、外からは使用しない。

sub dbh {
    my ($class) = @_;
    my $db = $class->db;
    my $DS   ="dbi:mysql:$db:localhost";
    return  DBI->connect($DS,$USER,$PASS)or die;
}


sub disconnect{
    my ($class,$dbh) = @_;
    $dbh->disconnect();
}


sub execute {
    my ($class, $sql, $binds, $options) = @_;
    my $sth = $class->dbh->prepare($sql);
    $sth->execute(@$binds);
    return $sth;
}


#------------------------------------------#
#------------ public method ---------------#
#------------------------------------------#

# 外部から各テーブルと1:1対応するクラスを通じて呼ばれる


# 一件レコード取得
# my $record = Mode::EventData->single($where); # return : single object
# $where   = +{ id => 1 };                      # where args is nessesary

sub single {
    my ($class,$where) = @_;
    my $fields = $class->columns || die "no fields set for class $class\n";
    my $table  = $class->table   || die "no table set for class $class\n";
    die unless ($where);
    my ($stmt, @binds) = $sql->select($table,$fields,$where,+{limit => 1});
    my $sth = $class->execute($stmt, \@binds, +{});

    return undef if $sth->rows() == 0;
    my $row = $sth->fetchrow_hashref;
    return $class->new($row);
}


# 複数レコード取得(where区指定内場合、全件走査になるので注意)
# my $records = Mode::EventData->search($where,$options); # return = array_ref
# $where   = +{ id => 1 };
# $options = +{ limit => 10, offset => 10, order_by => 'reg_date desc' }

sub search {
    my ($class,$where,$options) = @_;
    my $fields = $options->{fields} || $class->columns || die "no fields set for class $class\n";
    my $table  = $class->table                         || die "no table set for class $class\n";
    $where   = +{} unless ($where);
    $options = +{} unless ($options);

    my ($stmt, @binds) = $sql->select($table,$fields,$where,$options);
    my $sth = $class->execute($stmt, \@binds, $options);
    return undef if $sth->rows() == 0;
    my @array = ();
    while (my $hashref = $sth->fetchrow_hashref()) {
        push(@array, $class->new ( $hashref ) );
    }
    return \@array;
}


# 一件レコード挿入
# my $result = Mode::EventData->insert($fieldvals);  # return : 発行したseq_id / undef
# $fieldvals = +{ name => "hoge" }                   # fieldvals args is nessesary

sub insert {
    my ($class,$values) = @_;
    die "fieldvals are not given" unless ($values);
    die "fieldvals are invalid  " unless ( $class->_is_value_valid($values) );
    die "insert values are not fully set " unless ( $class->_is_enough_valus_for_insert($values) );
    my $table  = $class->table || die "no table selected for class $class\n";
    my ( $insert_values, $seq_id ) = $class->_get_insert_values($values);
    my ($stmt, @binds) = $sql->insert ($table,$insert_values);
    my $rows = $class->execute($stmt,\@binds, +{ access_to => 'master' })->rows;
    ($rows == 1) ? $seq_id : undef;
}


# 一件レコード更新
# my $result = Mode::EventData->update($where,$fieldvals,$options);  # return : updated row num(undef / 1)
# $where     = +{ id => 1 };                                # where args is nessesary
# $fieldvals = +{ name => "hoge" }                          # values for update

sub update{
    my($class,$where,$fieldvals,$options) = @_;
    die "fieldvals are not given" unless ($fieldvals);
    die "fieldvals are invalid  " unless ( $class->_is_value_valid($fieldvals) );
    my $table  = $class->table || die "no table selected for class $class\n";

    my $row = $class->single($where);
    return undef unless ($row);

    my ($stmt, @binds) = $sql->update($table,$fieldvals,$where);
    my $rows = $class->execute($stmt, \@binds, +{ access_to => 'master' })->rows();
    ($rows == 0) ? undef : $rows;
}


# 複数件レコード更新(思いクエリ投げる可能性あるのでなるべく使わない事)
# my $result = Mode::EventData->update_multi($where,$fieldvals);  # return : updated row num(undef,1,2,3)
# $where     = +{ id => 1 };
# $fieldvals = +{ name => "hoge" }

sub update_multi{
    my($class,$where,$fieldvals) = @_;
    die "fieldvals are not given" unless ($fieldvals);
    die "fieldvals are invalid  " unless ( $class->_is_value_valid($fieldvals) );
    my $row = $class->search($where);
    return undef unless ($row);

    my $table  = $class->table || die "no table selected for class $class\n";
    my ($stmt, @binds) = $sql->update($table,$fieldvals,$where);
    my $rows = $class->execute($stmt, \@binds, +{ access_to => 'master' })->rows();
    ($rows == 0) ? undef : $rows;
}


# 一件レコード削除
# my $result = Mode::EventData->delete($where);  # return : deleted row num(undef /1,2,3)
# $where     = +{ id => 1 };

sub delete {
    my ($class,$where) = @_;
    my $row = $class->search($where);
    return undef unless ($row);
    my $table  = $class->table || die "no table selected for class $class\n";

    my ($stmt, @binds) = $sql->delete($table,$where);
    my $rows = $class->execute($stmt, \@binds, +{ access_to => 'master' })->rows;
    ($rows == 0) ? undef : $rows;
}


# 複数件レコード削除(思いクエリ投げる可能性あるのでなるべく使わない事)
# my $result = Mode::EventData->delete_multi($where);  # return : deleted row num(undef / 1)
# $where     = +{ id => 1 };                     # where args is nessesary

sub delete_multi {
    my ($class,$where) = @_;
    my $row = $class->search($where);
    return undef unless ($row);
    my $table  = $class->table || die "no table selected for class $class\n";

    my ($stmt, @binds) = $sql->delete($class->table, $where);
    my $rows = $class->execute($stmt, \@binds, +{ access_to => 'master' })->rows;
    ($rows == 0) ? undef : $rows;
}


# 重複レコードの有無をチェック
# usage  : MODEL_CLASS_NAMER->is_duplicate(+{app_id => 1});
# return : 1 / undef 

sub is_duplicate {
    my ( $class, $where ) = @_;
    my $obj = $class->single( $where );
    ( $obj ) ? 1 : undef; 
}


# 該当レコード件数を取得
# usage  : MODEL_CLASS_NAMER->count(+{app_id => 1});
# return : scalar(ex:0,1,3,..)

sub count {
    my ( $class, $where ) = @_;
    my $obj_array_ref = $class->search( $where );
    return 0 unless ( $obj_array_ref );
    return ( scalar @$obj_array_ref );
}


#------------------------------------------#
#------------ private method --------------#
#------------------------------------------#


# シーケンシャルIDを発行して挿入用の値を返す
sub _get_insert_values {
    my ( $class, $values ) = @_;
    my $seq_key = $class->seq_key;
    $values->{reg_date} = time();
    return ( $values, $class->_get_index_value($values) ) unless $seq_key;
    my $seq_id = $class->_get_seq_id;
    $values->{$seq_key} = $seq_id;
    return ( $values, $seq_id );
}


# insertする値が全column分指定されているかチェック
sub _is_enough_valus_for_insert {
    my ( $class, $values ) = @_;
    my $fields = $class->columns || die "no fields set for class $class\n";

    for my $key (@$fields){
        next if ( $key eq $class->seq_key || $key eq "reg_date" );
        return unless( grep{ $_ eq $key }keys %$values ); 
    }
    return 1;
}


# シーケンステーブルから現在のidを取得,idをupdate後,現在のidを返す
sub _get_seq_id {
    my ($class) = shift;
    my $seq_table  = $class->seq_table || die "no seq_table selected for class $class\n";
    my ($stmt, @binds) = $sql->select($seq_table,["id"],+{},+{});
    my $sth = $class->execute($stmt, \@binds, +{});
    my $current_id = $sth->fetchrow_hashref->{id};

    ($stmt, @binds) = $sql->update($seq_table, +{ id => scalar($current_id)+1 } ,+{});
    $class->execute($stmt, \@binds)->rows();
    return $current_id;
}


# 入力値からインデックス値を取得
sub _get_index_value {
    my ( $class, $insert_values ) = @_;
    my $index = $class->index;

    for my $key (keys %$insert_values){
        last if ref($index->{pk}) eq 'ARRAY';
        return $insert_values->{$key} if ( $key eq $index->{pk} );
    }

    for my $key (keys %$insert_values){
        last if ref($index->{uk}) eq 'ARRAY';
        return $insert_values->{$key} if ( $key eq $index->{uk} );
    }

    for my $key (keys %$insert_values){
        last if ref($index->{i1}) eq 'ARRAY';
        return $insert_values->{$key} if ( $key eq $index->{i1} );
    }
    return undef;
}


sub _is_value_valid {
    my ( $class, $values ) = @_;

    #to-do:時間出来たら実装する
    # my $validate_rule = $class->validation;
    # 各key毎のvalidate条件を各モデルクラスに記述。data::validatorとか使って処理

    return 1;
}

1;
