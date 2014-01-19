#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: GetHis.pl
#
#        USAGE: ./GetHis.pl  
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
#      CREATED: 2014/01/18 19时07分30秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use DBI;
use AnyEvent;
use AnyEvent::HTTP;


my($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time());
my $today=sprintf("%4d%02d%02d",$year+1990,$mon+1,$mday);

my $firstday = shift || '20130101';
my $secday	=	shift || $today;
my $path = "./his";

print "$firstday	=> $secday\n";

my $dbh = DBI->connect("dbi:SQLite:dbname=./info.db",'','',{
        RaiseError => 1,
        AutoCommit => 1
        }   
    );  
$dbh->do("PRAGMA cache_size = 800000");




Get();

sub Get
{
	my $cv	=	AnyEvent->condvar;

	while(<DATA>)
	{
		chomp;
		my $code	=	$_;
		my $pre;
		my $url;
		if(/^6/)
		{
			$pre="0";
		}
		else
		{
			$pre = "1";
		}	
		print "$pre$code\n";
       $url	=	"http://quotes.money.163.com/service/chddata.html?code=$pre$code&start=$firstday&end=$secday";

	   $cv->begin;
	   http_get($url,sub{
						my ($content,$hdr) = @_;
						$cv->end();
						open my $fh, " > $path/$code.txt" or die"erroe";
						print $fh $content;
						close $fh;
						print "$code",$hdr->{Status};
			   }
			);
	}

	$cv->recv();
}

=cut
sub done
{
	my ($code, $content,$hdr) = @_;
	$cv->end();
	print "$code",$hdr->{Status};
}
=cut

__DATA__
000001
601166
