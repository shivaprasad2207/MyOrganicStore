#!perl

use warnings;
use strict;
use POSIX qw/strftime/;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
require CGI::Session;
use Data::Dumper;
use DBLibs;
use Template;
use MyVars;
use Header;
use Digest::MD5 qw(md5 md5_hex md5_base64);
require 'MyLibs.pl';
our (  $Header    
);
my $cgi = CGI->new;
 
print $cgi->header( );  
print $META_TAGS;
print $cgi->start_html($Header);
my $out;
my $tt = Template->new;
        $tt->process('user_registration.html', undef , \$out)
        || die $tt->error;
print $out;
print $cgi->end_html();