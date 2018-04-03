#!perl

BEGIN {
   binmode(STDIN);                       # Form data
   binmode(STDOUT, ':encoding(UTF-8)');  # HTML
   binmode(STDERR, ':encoding(UTF-8)');  # Error messages
}


use DBI;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use warnings;
use CGI::Session;
use strict;
use Template;
use Header;
use MyVars;

our ( $META_TAGS, $Header);



my $cgi = new CGI;
use CGI qw(:all -utf8);
my $session = new CGI::Session(undef, $cgi, undef);
my $sid = $session->id;

$cgi->autoEscape(undef);
print $cgi->header( );
print $META_TAGS;
print $cgi->start_html($Header); 

if ($cgi->param('status') eq 'error'){
    print '<p style="position:relative;top:10px;left:14%;background-color:red;border-radius: 10px; width:400px;margin:2px;padding:2px" border="1"><font size="2">Authontication ..ERROR:</font></p>';
}elsif ($cgi->param('status') eq 'logout'){
    
    print '<p style="position:relative;top:10px;left:14%;background-color:yellow;border-radius: 10px; width:400px;margin:2px;padding:2px" border="1"><font size="2">Logout Successfully</font></p>';
}elsif ($cgi->param('status') eq 'Alogout'){
    print '<p style="position:relative;top:10px;left:14%;background-color:orange;border-radius: 10px; width:400px;margin:2px;padding:2px" border="1"><font size="2">You have Logout Previously</font></p>';
}elsif ($cgi->param('status') eq 'no_such_userexist'){
    print '<p style="position:relative;top:10px;left:14%;background-color:red;border-radius: 10px; width:400px;margin:2px;padding:2px" border="1"><font size="2">No such user exist ..ERROR:</font></p>';
}elsif ($cgi->param('status') eq 'accnt_lockd'){
    print '<p style="position:relative;top:10px;left:14%;background-color:pink;border-radius: 10px; width:400px;margin:2px;padding:2px" border="1"><font size="2">Your account Locked ..</font></p>';
}elsif ($cgi->param('status') eq 'accnt_deleted'){
    print '<p style="position:relative;top:10px;left:14%;background-color:pink;border-radius: 10px; width:400px;margin:2px;padding:2px" border="1"><font size="2">Your account Deleted ..</font></p>';
}elsif ($cgi->param('status') eq 'not_admin'){
    print '<p style="position:relative;top:10px;left:14%;background-color:pink;border-radius: 10px; width:400px;margin:2px;padding:2px" border="1"><font size="2">Not Admin User ..</font></p>';
}elsif ($cgi->param('status') eq 'jslogout'){
    my $cookie = $cgi->cookie(
                            -name=>'CGISESSID',
                            -value=>$cgi->param('sid'),
                            -expires=>'-1d',
                        );
    
 
   $cgi->redirect(-cookie=>$cookie, -url =>"login.pl?status=HAHAH"); 
}

my $out;
     my $tt = Template->new;
     $tt->process('login.html', undef, \$out)
        || die $tt->error; 

print $out;

   
print $cgi->end_html;