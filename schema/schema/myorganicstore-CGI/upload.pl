#!perl

BEGIN {
   binmode(STDIN , ':encoding(UTF-8)');  # Form data
   binmode(STDOUT, ':encoding(UTF-8)');  # HTML
   binmode(STDERR, ':encoding(UTF-8)');  # Error messages
}
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
our (  $Header,   $IMAGE_DIR , $NEW_PASSWD  , $APP_CGI_BIN     
);

my $cgi = CGI->new;
my %hash = $cgi->Vars;
my $file = $cgi->upload('file');
my $nBytes = 0;
my $totBytes = 0;
my $buffer;
my $image = $cgi->param('label');
my $o;
my $f = "$ENV{DOCUMENT_ROOT}" . $IMAGE_DIR . $image . ".jpg" ;
open($o, ">" , $f) or die $!;
binmode($o);
my $sfile = '';
undef $sfile;
while (my $bytesread=read($file,$buffer,1024)) {
       $sfile = $sfile. $buffer;
}
print $o $sfile;
close($o);
$f = $image . ".jpg";
my $ret = uploadImageNametoDb( $f , $image );
print "Content-type: text/plain; charset=iso-8859-1\n\n";
if( $ret == 1 ){       
       print $ret;
}else{
   
        print  "<br><br><font color=\"red\"> <b> ERROR $ret  Unable to  Upload Image</b></font>";
}


