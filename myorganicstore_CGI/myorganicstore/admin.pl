#!perl
BEGIN {
   binmode(STDIN);                       # Form data
   binmode(STDOUT, ':encoding(UTF-8)');  # HTML
   binmode(STDERR, ':encoding(UTF-8)');  # Error messages
}

use CGI;
use CGI::Carp qw(fatalsToBrowser);
require CGI::Session;
require 'Mylibs.pl';
use Template;
use strict;
use warnings;
use Data::Dumper;
use Header;
use MyVars;
use DBLibs;
use utf8;
use Time::Local;

our (  $Header,  $footer, $IMAGE_DIR , $META_TAGS      
);

my $cgi = CGI::new;
$cgi->autoEscape(undef);
$cgi->charset('utf-8');

$| = 1;

my %page_function_hash = (
    
                 
        'Main' => {
                        pFunction => \&F_Main,
                        pHeader =>  $Header,
                        pContent => 'home1.html',
                        pFooter => $footer,
                        pBcum =>  '[HOME]',
                     }, 
   
         'Category' =>{
                        pFunction => \&F_Category,
                        pHeader =>  $Header,
                        pContent => 'CategoryOpts.html',
                        pFooter => $footer,
                        pBcum =>  '',
                     },
           'sCategory' =>{
                        pFunction => \&F_sCategory,
                        pHeader =>  $Header,
                        pContent => 'subCategoryOpts.html',
                        pFooter => $footer,
                        pBcum =>  '',
                     },
           'Product' =>{
                        pFunction => \&F_Product,
                        pHeader =>  $Header,
                        pContent => 'getCategorySelectList.html',
                        pFooter => $footer,
                        pBcum =>  '',
                     },
);
&AppInit( $cgi ); 


sub AppInit {
    my ($cgi) = @_;
    my $param = $cgi->param('pg');
    if (!$param){
        $param = 'Main';
    }elsif ($param =~ /\?/){
        my @params = split '\?' , $param;
        $cgi->{code} = $params[1];
        $param = $params[0];
    }
    $cgi->{'cgi'} = $cgi  ;
    $cgi->{'pg'} = $param  ;
    my $function_ref = $page_function_hash{$param}->{'pFunction'};
    $function_ref->($cgi);
}

sub header_print {
    my ($cgi) = @_;
    my $param = $cgi->{'pg'};
    my $PageHeader = $page_function_hash{$param}->{'pHeader'};
    my $sid = $cgi->cookie('CGISESSID');
    my $session = CGI::Session->new( $sid );
    print $cgi->header( );  
    print $META_TAGS;
    print $cgi->start_html($PageHeader);
   
}


sub F_Main {
    my ($cgi) = @_;
    my ($user_name,$role) = is_valid_user($cgi);
    my $sid = $cgi->cookie('CGISESSID');
    my $session = CGI::Session->new( $sid );
    my $name = $session->param("usr_name");
    my $uid = $session->param("uid");
   
    my %page_content;
    my @categories = GetProductTreeFromDb ();
     $page_content{categories} = \@categories;
   
    header_print ( $cgi);
    my $param = $cgi->{'pg'};
    my $out = ''; 
    undef $out;   
  
    my $tt = Template->new;
        $tt->process($page_function_hash{$param}->{'pContent'},\%page_content  , \$out)
        || die $tt->error;
    $page_content{footer} = $page_function_hash{$param}->{'pFooter'};
    $page_content{Bcum} = $page_function_hash{$param}->{'pBcum'};
    $page_content{content} = $out; undef $out;
   
   if ( defined ($name)  ){
        $page_content{USR} = $name;
   }
   my ($fname, $lname) = getFullNameOfUserFromDb ( $name ); 
   $page_content{FNAME} = $fname;
   $page_content{LNAME} = $lname;
   $page_content{SID} = $sid;
   $tt = Template->new;
        $tt->process('admin_main_page.html', \%page_content , \$out)
        || die $tt->error;
    print $out;
    #my %menu_hash = GetProductTreeFromDb ();
    print $cgi->end_html();
}

sub F_Category {
    my ($cgi) = @_;
    my ($user_name,$role) = is_valid_user($cgi);
    my $sid = $cgi->cookie('CGISESSID');
    my $session = CGI::Session->new( $sid );
    my $name = $session->param("usr_name");
    my $uid = $session->param("uid");
   
    my %page_content;
    my @categories = GetProductTreeFromDb ();
     $page_content{categories} = \@categories;
     if ( $cgi->param('Op') eq 'Add'){
         $page_content{ADD_OPT} = 1;
     }elsif ( $cgi->param('Op') eq 'Mod'){
         $page_content{MOD_OPT} = 1;
     }elsif ( $cgi->param('Op') eq 'Del'){
         $page_content{DEL_OPT} = 1;
     }elsif ( $cgi->param('Op') eq 'View'){
         $page_content{VIEW_OPT} = 1;
     }elsif ( $cgi->param('Op') eq 'Addp'){
         $page_content{ADD_PHOTO} = 1;
     }
   
    header_print ( $cgi);
    my $param = $cgi->{'pg'};
    my $out = ''; 
    undef $out;   
  
    my $tt = Template->new;
        $tt->process($page_function_hash{$param}->{'pContent'},\%page_content  , \$out)
        || die $tt->error;
    $page_content{footer} = $page_function_hash{$param}->{'pFooter'};
    $page_content{Bcum} = $page_function_hash{$param}->{'pBcum'};
    $page_content{content} = $out; undef $out;
   
   if ( defined ($name)  ){
        $page_content{USR} = $name;
   }
   my ($fname, $lname) = getFullNameOfUserFromDb ( $name ); 
   $page_content{FNAME} = $fname;
   $page_content{LNAME} = $lname;
   $page_content{SID} = $sid;
   $tt = Template->new;
        $tt->process('admin_main_page.html', \%page_content , \$out)
        || die $tt->error;
    print $out;
    #my %menu_hash = GetProductTreeFromDb ();
    print $cgi->end_html();
}


sub F_sCategory{
    my ($cgi) = @_;
    my ($user_name,$role) = is_valid_user($cgi);
    my $sid = $cgi->cookie('CGISESSID');
    my $session = CGI::Session->new( $sid );
    my $name = $session->param("usr_name");
    my $uid = $session->param("uid");
   
    my %page_content;
    my @categories = GetProductTreeFromDb ();
     $page_content{categories} = \@categories;
     if ( $cgi->param('Op') eq 'Add'){
         $page_content{OPT} = 'ADD';
     }elsif ( $cgi->param('Op') eq 'Mod'){
         $page_content{OPT} = 'MOD';
     }elsif ( $cgi->param('Op') eq 'Del'){
         $page_content{OPT} = 'DEL';
     }elsif ( $cgi->param('Op') eq 'View'){
         $page_content{OPT} = 'VIEW';
     }elsif ( $cgi->param('Op') eq 'Addp'){
         $page_content{OPT} = 'ADD_PHOTO';
     }
   
    header_print ( $cgi);
    my $param = $cgi->{'pg'};
    my $out = ''; 
    undef $out;   
  
    my $tt = Template->new;
        $tt->process($page_function_hash{$param}->{'pContent'},\%page_content  , \$out)
        || die $tt->error;
    $page_content{footer} = $page_function_hash{$param}->{'pFooter'};
    $page_content{Bcum} = $page_function_hash{$param}->{'pBcum'};
    $page_content{content} = $out; undef $out;
   
   if ( defined ($name)  ){
        $page_content{USR} = $name;
   }
   my ($fname, $lname) = getFullNameOfUserFromDb ( $name ); 
   $page_content{FNAME} = $fname;
   $page_content{LNAME} = $lname;
   $page_content{SID} = $sid;
   $tt = Template->new;
        $tt->process('admin_main_page.html', \%page_content , \$out)
        || die $tt->error;
    print $out;
    #my %menu_hash = GetProductTreeFromDb ();
    print $cgi->end_html();
}

sub F_Product {
    my ($cgi) = @_;
    my ($user_name,$role) = is_valid_user($cgi);
    my $sid = $cgi->cookie('CGISESSID');
    my $session = CGI::Session->new( $sid );
    my $name = $session->param("usr_name");
    my $uid = $session->param("uid");
   
    my %page_content;
    my @categories = GetProductTreeFromDb ();
     $page_content{categories} = \@categories;
     if ( $cgi->param('Op') eq 'Add'){
         $page_content{OPT} = 'ADD';
     }elsif ( $cgi->param('Op') eq 'Mod'){
         $page_content{OPT} = 'MOD';
     }elsif ( $cgi->param('Op') eq 'Del'){
         $page_content{OPT} = 'DEL';
     }elsif ( $cgi->param('Op') eq 'View'){
         $page_content{OPT} = 'VIEW';
     }elsif ( $cgi->param('Op') eq 'Addp'){
         $page_content{OPT} = 'ADD_PHOTO';
     }
   
    header_print ( $cgi);
    my $param = $cgi->{'pg'};
    my $out = ''; 
    undef $out;   
  
    my $tt = Template->new;
        $tt->process($page_function_hash{$param}->{'pContent'},\%page_content  , \$out)
        || die $tt->error;
    $page_content{footer} = $page_function_hash{$param}->{'pFooter'};
    $page_content{Bcum} = $page_function_hash{$param}->{'pBcum'};
    $page_content{content} = $out; undef $out;
   
   if ( defined ($name)  ){
        $page_content{USR} = $name;
   }
   my ($fname, $lname) = getFullNameOfUserFromDb ( $name ); 
   $page_content{FNAME} = $fname;
   $page_content{LNAME} = $lname;
   $page_content{SID} = $sid;
   $tt = Template->new;
        $tt->process('admin_main_page.html', \%page_content , \$out)
        || die $tt->error;
    print $out;
    #my %menu_hash = GetProductTreeFromDb ();
    print $cgi->end_html();
   
   
}


