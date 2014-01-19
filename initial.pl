#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: initial.pl
#
#        USAGE: ./initial.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 2014/01/18 20时43分04秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use DBI;
use LWP::UserAgent;
use HTTP::Cookies;
use HTTP::Headers;
use JSON;
use Data::Dumper;
use Encode;


my $dbh = DBI->connect("dbi:SQLite:dbname=./s.db",'','',{
        RaiseError => 1,
        AutoCommit => 0
        }   
    );  

my $sql;

#create share
$sql = qq !CREATE TABLE
	IF NOT EXISTS 
	share
(
	code	varchar(8),
    name    varchar(30) 
)
!;
$dbh->do($sql);

#create to_update
$sql = qq !CREATE TABLE
	IF NOT EXISTS 
	to_update
(
	code	varchar(8),
    name    varchar(30) 
)
!;
$dbh->do($sql);

#create his
$sql	=	qq! create table
	if not exists
	his
	(
		date	varchar(8),
		code	varchar(8),
		name	varchar(30),
		close	float,
		high	float,
		low		float,
		open	float,
		yesclose	float,
		updownvalue	float,
		updown	float,
		volume	float,
		trunover	float
	)
!;
$dbh->do($sql);

#create his2
$sql	=	qq! create table
	if not exists
	his2
	(
		date	varchar(8),
		code	varchar(8),
		name	varchar(30),
		close	float,
		high	float,
		low		float,
		open	float,
		yesclose	float,
		updownvalue	float,
		updown	float,
		volume	float,
		trunover	float
	)
!;
$dbh->do($sql);

#	create hl
$sql	=	qq ! create table 
	if not exists
	hl
	(
		date	varchar(8),
		code	varcahr(8),
		name	varchar(30),
		days	int,
		h	float,
		l	float
	)
!;
$dbh->do($sql);

# gz
$sql	=	qq!	create table
	if not exists
	gz
	(
		date	varchar(8),
		code	varchar(8),
		name	varchar(30),
		price	float
	)
!;
$dbh->do($sql);


#tmp table
$sql	=	qq! create table
	if not exists
	today
	(
		code	varchar(8),
		name	varchar(30),
		price	float,
		updown	float,
		pe	float,
		mfsum	float,
		mfradio2	float,
		mfradio10	float,
		tcap	float,
		mcap	float,
		turnover	float,
		volume	flaot,
		lb	float,
		hs	float,
		five	float,
		high	float,
		low	float,
		open	float,
		yesclose	flaot
	)
!;
$dbh->do($sql);

#today2
$sql	=	qq! create table
	if not exists
	today2
	(
		code	varchar(8),
		name	varchar(30),
		price	float,
		updown	float,
		pe	float,
		mfsum	float,
		mfradio2	float,
		mfradio10	float,
		tcap	float,
		mcap	float,
		turnover	float,
		volume	flaot,
		lb	float,
		hs	float,
		five	float,
		high	float,
		low	float,
		open	float,
		yesclose	flaot
	)
!;
$dbh->do($sql);

$dbh->commit();





#our $file = "c: \\ookie.txt";
#our $cookie =  HTTP::Cookies->new(file=>$file,autosave=>1);
our $browser = LWP::UserAgent->new(keep_alive => 1);
#$browser->cookie_jar($cookie);
#our $proxy = $browser->proxy(http=>'http://cmproxy.XXXX.net:8081');
my $count=3000;
my  $url ="http://quotes.money.163.com/hs/service/diyrank.php?host=http%3A%2F%2Fquotes.money.163.com%2Fhs%2Fservice%2Fdiyrank.php&page=0&query=STYPE%3AEQA&fields=SYMBOL%2CNAME%2CPRICE%2CPERCENT%2CUPDOWN%2CFIVE_MINUTE%2COPEN%2CYESTCLOSE%2CHIGH%2CLOW%2CVOLUME%2CTURNOVER%2CHS%2CLB%2CPE%2CMCAP%2CTCAP%2CMFSUM%2CMFRATIO.MFRATIO2%2CMFRATIO.MFRATIO10%2CSNAME%2CCODE%2CANNOUNMT%2CUVSNEWS&sort=SYMBOL&order=asc&count=$count&type=query";

my $response = $browser->get($url);
#print $response->is_success;
my $json = new JSON;
my $obj = $json->decode($response->content);
#print "The structure of obj: ".Dumper($obj);

$dbh->do("delete from share");

foreach my $i (0.. scalar(@{$obj->{list}})-1) #
{
    my $sql = "insert into share values('";
    $sql .= $obj->{list}[$i]->{'SYMBOL'} ."','"; #代码
    $sql .= encode("utf8",$obj->{list}[$i]->{'NAME'}) ."')";
    
    print "$i\n"; 
    #print $sql;
    #exit(0);
    $dbh->do( $sql);
    
    if ($dbh->err()) {
        die "$DBI::errstr\n";
    }
   
}
$dbh->commit();

$dbh->disconnect();
