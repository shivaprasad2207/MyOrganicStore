#!perl
use warnings;
use strict;
use CGI;
require CGI::Session;
use CGI::Carp qw(fatalsToBrowser);
my $cgi = CGI->new();
my $flag = $cgi->param('flag');

my $sid = $cgi->param('sid');
my $session = CGI::Session->new( $sid );
$session->delete();
$session->flush();
my $cookie = $cgi->cookie(
                            -name=>'CGISESSID',
                            -value=>$sid,
                            -expires=>'-1d',
                        );
print $cgi->redirect(-cookie=>$cookie,-location=>"login.pl?status=jslogout"); 