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
use POSIX qw/strftime/;

our (  $Header,  $footer, $IMAGE_DIR , $META_TAGS      
);

my $cgi = CGI::new;
$cgi->autoEscape(undef);
$cgi->charset('utf-8');

$| = 1;

my %page_function_hash = (
   
          'Index' => {
                        pFunction => \&F_Index,
                        pHeader =>  $Header,
                        pContent => 'home1.html',
                        pFooter => $footer,
                        pBcum =>  '[HOME]',
                     },
          
        'Main' => {
                        pFunction => \&F_Main,
                        pHeader =>  $Header,
                        pContent => 'home1.html',
                        pFooter => $footer,
                        pBcum =>  '[HOME]',
                     },
        'itemShow' => {
                        pFunction => \&F_itemShow,
                        pHeader =>  $Header,
                        pContent => 'item_show.html',
                        pFooter => $footer,
                        pBcum =>  '',
                     },
         'itemDShow' => {
                        pFunction => \&F_itemDShow,
                        pHeader =>  $Header,
                        pContent => 'item_show.html',
                        pFooter => $footer,
                        pBcum =>  '',
                     },
         'ShowOrder' =>{
                        pFunction => \&F_ShowOrder,
                        pHeader =>  $Header,
                        pContent => 'order_sheet.html',
                        pFooter => $footer,
                        pBcum =>  '',
                     },
         'DelOrder' =>{
                        pFunction => \&F_DelOrder,
                        pHeader =>  $Header,
                        pContent => 'order_continue_sheet.html',
                        pFooter => $footer,
                        pBcum =>  '',
                     },
         'Setting' =>{
                        pFunction => \&F_Main,
                        pHeader =>  $Header,
                        pContent => 'settings.html',
                        pFooter => $footer,
                        pBcum =>  '[ Settings ]',
                     },
         'Contact' =>{
                        pFunction => \&F_Main,
                        pHeader =>  $Header,
                        pContent => 'contact.html',
                        pFooter => $footer,
                        pBcum =>  '[ Contact ]',
                     },
         'DelOrder' =>{
                        pFunction => \&F_DelOrder,
                        pHeader =>  $Header,
                        pContent => 'order_continue_sheet.html',
                        pFooter => $footer,
                        pBcum =>  '',
                     },
         'DelAllOrder'  =>{
                        pFunction => \&F_DelOrder,
                        pHeader =>  $Header,
                        pContent => 'order_continue_sheet.html',
                        pFooter => $footer,
                        pBcum =>  '',
                     },
         'OrderPlace' =>{
                        pFunction => \&F_DelOrder,
                        pHeader =>  $Header,
                        pContent => 'place_order_sheet.html',
                        pFooter => $footer,
                        pBcum =>  '',
                     },
          'ProcessOrder' =>{
                        pFunction => \&F_ProcessOrder,
                        pHeader =>  $Header,
                        pContent => 'order_confirmed.html',
                        pFooter => $footer,
                        pBcum =>  '',
                     },
          'OrderList' => {
                        pFunction => \&F_OrderList,
                        pHeader =>  $Header,
                        pContent => 'order_list.html',
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


sub F_Index {
     my ($cgi) = @_;
    
    header_Dprint ( $cgi);
    my $param = $cgi->{'pg'};
    my $out = ''; 
    undef $out;
    my %page_content;
    my @categories = GetProductTreeFromDb ();
    my $tt = Template->new;
        $tt->process($page_function_hash{$param}->{'pContent'},undef , \$out)
        || die $tt->error;
    $page_content{footer} = $page_function_hash{$param}->{'pFooter'};
    $page_content{Bcum} = $page_function_hash{$param}->{'pBcum'};
    $page_content{content} = $out; undef $out;
    $page_content{categories} = \@categories;
     $tt = Template->new;
        $tt->process('index.html', \%page_content , \$out)
        || die $tt->error;
    print $out;
   
    print "<pre>" , Dumper \@categories , "</pre>";
    print $cgi->end_html();
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

sub header_Dprint {
    my ($cgi) = @_;
    my $param = $cgi->{'pg'};
    my $PageHeader = $page_function_hash{$param}->{'pHeader'};
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
        $tt->process($page_function_hash{$param}->{'pContent'},undef , \$out)
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
   my $Ocount = OrderCount ( $cgi);
   if ($Ocount >= 1 ){
        $page_content{ORDERS} = $Ocount;
    }   
     $tt = Template->new;
        $tt->process('main_page.html', \%page_content , \$out)
        || die $tt->error;
    print $out;
    #my %menu_hash = GetProductTreeFromDb ();
    print $cgi->end_html();
}

sub F_itemDShow {
    my ($cgi) = @_;
    header_Dprint ( $cgi);
    my $param1 = $cgi->param('nm');
    my $param = $cgi->param('pg');
    my $out = ''; 
    undef $out;
    my %page_content;
    my @categories = GetProductTreeFromDb ();
    $page_content{categories} = \@categories;  
    my @products =  getProductsOfSubCategoryFromDb ( $param1 );
    my $data;
    $data->{CATEGORY} = $param1;
    $data->{products} = \@products;
    $data->{LDIR} = $IMAGE_DIR;
    my @imagesAndSubCategory = getProductImageAndSubCategory ();
    $data->{IMAGES} = \@imagesAndSubCategory;
       my $tt = Template->new;
        $tt->process($page_function_hash{$param}->{'pContent'}, $data , \$out)
        || die $tt->error;      
    $page_content{footer} = $page_function_hash{$param}->{'pFooter'};
    $page_content{Bcum} = $page_function_hash{$param}->{'pBcum'};
    $page_content{content} = $out; undef $out;   
    $tt = Template->new;
        $tt->process('index.html', \%page_content , \$out)
        || die $tt->error;
    print $out;
    print $cgi->end_html();   
}

sub F_itemShow {
    my ($cgi) = @_;
    if ( $cgi->param('e') eq 'd' ){
       F_itemDShow ($cgi);return ;
    }
    header_print ( $cgi);
    my $param = $cgi->param('pg');
    my $subCategory = $cgi->param('nm');
    my ($user_name,$role) = is_valid_user($cgi);
    my $sid = $cgi->cookie('CGISESSID');
    my $session = CGI::Session->new( $sid );
    my $name = $session->param("usr_name");
    my $uid = $session->param("uid");
    my %page_content;
    my @categories = GetProductTreeFromDb ();
    $page_content{categories} = \@categories;
   
    my $out = ''; 
    undef $out;
    my @products =  getProductsOfSubCategoryFromDb ( $subCategory );
    my $data;
    $data->{CATEGORY} = $param;
    $data->{products} = \@products;
    $data->{LDIR} = $IMAGE_DIR;
    $data->{USER} = $name;
    my @imagesAndSubCategory = getProductImageAndSubCategory ();
    $data->{IMAGES} = \@imagesAndSubCategory;
    my $tt = Template->new;
        $tt->process($page_function_hash{$param}->{'pContent'}, $data , \$out)
        || die $tt->error;
 
   if ( $name =~ /\@/  ){
        $page_content{USR} = $name;
   }
    $page_content{footer} = $page_function_hash{$param}->{'pFooter'};
    $page_content{Bcum} = $page_function_hash{$param}->{'pBcum'};
    $page_content{content} = $out; undef $out;
    $page_content{SID} = $sid;
    my ($fname, $lname) = getFullNameOfUserFromDb ( $name ); 
    $page_content{FNAME} = $fname;
    $page_content{LNAME} = $lname;
    
   my $Ocount = OrderCount ( $cgi);
   if ($Ocount >= 1 ){
        $page_content{ORDERS} = $Ocount;
    }   
    $tt = Template->new;
        $tt->process('main_page.html', \%page_content , \$out)
        || die $tt->error;
    print $out;
    print $cgi->end_html();   
}

sub F_OrderList {
    my ($cgi) = @_;
    header_print ( $cgi);
    my $param = $cgi->param('pg');
    my ($user_name,$role) = is_valid_user($cgi);
    my $sid = $cgi->cookie('CGISESSID');
    my $session = CGI::Session->new( $sid );
    my $name = $session->param("usr_name");
    my $uid = $session->param("uid");
    my (%page_content,$data,$out); 
   
    
    $data->{LDIR} = $IMAGE_DIR;
    my @imagesAndSubCategory = getProductImageAndSubCategory ();
    $data->{IMAGES} = \@imagesAndSubCategory;
    my @orderList = getOrderListFromDb ( $name, $sid);
    $data->{orders} = \@orderList;
      my $tt = Template->new;
        $tt->process($page_function_hash{$param}->{'pContent'}, $data , \$out)
        || die $tt->error;
    
    ###Page Data Filling in order
    
    my ($fname, $lname) = getFullNameOfUserFromDb ( $name ); 
    $page_content{FNAME} = $fname;
    $page_content{LNAME} = $lname;
    $page_content{SID} = $sid;
    my $Ocount = OrderCount ( $cgi);
    if ($Ocount >= 1 ){
        $page_content{ORDERS} = $Ocount;
    }   
    
    my @categories = GetProductTreeFromDb ();
    $page_content{categories} = \@categories;
    $page_content{Bcum} = $page_function_hash{$param}->{'pBcum'};
    $page_content{content} = $out; undef $out;
    $page_content{footer} = $page_function_hash{$param}->{'pFooter'};
    $tt = Template->new;
        $tt->process('main_page.html', \%page_content , \$out)
        || die $tt->error;
    print $out;
    print $cgi->end_html();   
}

sub OrderCount{
    my ($cgi) = @_;  
    my $sid = $cgi->cookie('CGISESSID');
    my $session = CGI::Session->new( $sid );
    my $sessionOrders = getSessionOrderFromDb ( $sid );
    if ( $sessionOrders eq 'NULL'){
      return 0; 
    }else{
        my @arrayOrders = split /;/, $sessionOrders;
        my $ret = @arrayOrders;
        return $ret;
    }
}



sub delOrder {
   my ($cgi) = @_;
   my $sid = $cgi->cookie('CGISESSID');
   my %order_hash = getSessionOrderHash ($cgi);
   my $prodId = $cgi->param("ProdId");
   my @arrayOrders ;
   delete ( $order_hash{ $prodId });
   foreach my $ProdId ( keys ( %order_hash )){
      my $pair = "$ProdId:$order_hash{$ProdId}";
      push ( @arrayOrders , $pair )
   }  
   my $orders  = join ';' , @arrayOrders;
   registerUpdatedOrderInToDb ($sid,$orders);
   
}

sub dellAllOrder {
    my ($cgi) = @_;
   my $sid = $cgi->cookie('CGISESSID');
   my %order_hash = getSessionOrderHash ($cgi);
   registerUpdatedOrderInToDb ($sid,'');
}

sub getSessionOrderHash {
    my ($cgi) = @_;  
    my $sid = $cgi->cookie('CGISESSID');
    my $session = CGI::Session->new( $sid ); 
    my $sessionOrders = getSessionOrderFromDb ( $sid );
    my @arrayOrders = split /;/, $sessionOrders;
    my %order_hash;
    foreach my $order ( @arrayOrders ){
       my @arrayOrders = split /:/, $order;
       if ( !defined ($order_hash{$arrayOrders[0]} ) ){  
            $order_hash{$arrayOrders[0]} = $arrayOrders[1]; 
       }else{
             $order_hash{$arrayOrders[0]} = $order_hash{$arrayOrders[0]} +  $arrayOrders[1];  
       } 
    }
    return %order_hash;
}


sub F_ShowOrder{
    my ($cgi) = @_;
    header_print ( $cgi);
    my $param = $cgi->{'pg'};
    my ($user_name,$role) = is_valid_user($cgi);
    my $sid = $cgi->cookie('CGISESSID');
    my $session = CGI::Session->new( $sid );
    my $name = $session->param("usr_name");
    my $uid = $session->param("uid");
    my %page_content;
    my @categories = GetProductTreeFromDb ();
    $page_content{categories} = \@categories;
   
    my $out = ''; 
    undef $out;
    my %order_hash = getSessionOrderHash ($cgi);
    my $data;
    my @order_report;
    my @prices;
    foreach my $productId (keys (%order_hash)){
         my %product = getProductDetailFromDb ($productId);
         my %hash;
         $hash{productName} = $product{'productName'};
         $hash{'image'} = $product{'image'} ;
         $hash{'price'} = $product{'price'} ;
         $hash{'productId'} = $product{'productId'} ;
         $hash{'productUnit'} = $product{'productUnit'} ;
         $hash{'productQty'} = $order_hash{$productId};
         $hash{'productPrice'} = sprintf("%.2f", $hash{'productQty'} * $hash{'price'});
         push (@prices, $hash{'productPrice'} );
         push (@order_report,\%hash);
    }
    my $f_price = 0.0;
    foreach my $price ( @prices){
      $f_price = sprintf("%.2f", $f_price + $price);  
    }  
    $data->{TOTAL} = $f_price;
    $data->{orders} = \@order_report;
    $data->{LDIR} = $IMAGE_DIR;
    my $tt = Template->new;
        $tt->process($page_function_hash{$param}->{'pContent'}, $data , \$out)
        || die $tt->error;
 
    if ( $name =~ /\@/  ){
        $page_content{USR} = $name;
   }
    $page_content{footer} = $page_function_hash{$param}->{'pFooter'};
    $page_content{Bcum} = $page_function_hash{$param}->{'pBcum'};
    $page_content{content} = $out; undef $out;
    $page_content{SID} = $sid;
    my ($fname, $lname) = getFullNameOfUserFromDb ( $name ); 
    $page_content{FNAME} = $fname;
    $page_content{LNAME} = $lname;
    my $Ocount = OrderCount ( $cgi);
    if ($Ocount >= 1 ){
        $page_content{ORDERS} = $Ocount;
    }   
    
    $tt = Template->new;
        $tt->process('main_page.html', \%page_content , \$out)
        || die $tt->error;
    print $out;
    print $cgi->end_html();
}

sub F_DelOrder {
    my ($cgi) = @_;
    header_print ( $cgi);
    my $param = $cgi->{'pg'};
    my ($user_name,$role) = is_valid_user($cgi);
    my $sid = $cgi->cookie('CGISESSID');
    my $session = CGI::Session->new( $sid );
    if ( $cgi->param('pg') eq 'DelAllOrder'){
         dellAllOrder ($cgi);
    }
    my $name = $session->param("usr_name");
    my $uid = $session->param("uid");
 
    my %page_content;
    my @categories = GetProductTreeFromDb ();
     $page_content{categories} = \@categories;
    
    my $out = ''; 
    undef $out;
    my @arrayOrders ;
    delOrder ( $cgi ); 
    my %order_hash = getSessionOrderHash ($cgi);
    my $data;

    my @order_report;
    my @prices;
    foreach my $productId (keys (%order_hash)){
         my %product = getProductDetailFromDb ($productId);
         my %hash;
         $hash{productName} = $product{'productName'};
         $hash{'image'} = $product{'image'} ;
         $hash{'price'} = $product{'price'} ;
         $hash{'productId'} = $product{'productId'} ;
         $hash{'productUnit'} = $product{'productUnit'} ;
         $hash{'productQty'} = $order_hash{$productId};
         $hash{'productPrice'} = sprintf("%.2f", $hash{'productQty'} * $hash{'price'});
         push (@prices, $hash{'productPrice'} );
         push (@order_report,\%hash);
    }
    my $f_price = 0.0;
    foreach my $price ( @prices){
      $f_price = sprintf("%.2f", $f_price + $price);  
    }
  
    my $Ocount = OrderCount ( $cgi);
    if ($Ocount >= 1 ){
        $page_content{ORDERS} = $Ocount;
    }    
    my $price = int ($f_price);
    if ( !$price){
      $data->{NO_ORDERS} = 1;
    }
    $data->{TOTAL} = $f_price;
    $data->{orders} = \@order_report;
    $data->{LDIR} = $IMAGE_DIR;
    my @imagesAndSubCategory = getProductImageAndSubCategory ();
    $data->{IMAGES} = \@imagesAndSubCategory;
    my %user_info = getUserDetailsFromDb ($name);
    $data->{firstname} = $user_info{firstname};
    $data->{lastname} = $user_info{lastname};
    $data->{email} = $user_info{email};
    $data->{adress} = $user_info{adress};
    $data->{phone} = $user_info{phone};
    $data->{Zip} = $user_info{Zip};
    my @otherAdress = getOtherUserAdressFromDb($name);
    $data->{OTHER_ADRESS} = \@otherAdress; 
    
    my $tt = Template->new;
        $tt->process($page_function_hash{$param}->{'pContent'}, $data , \$out)
        || die $tt->error;
    if ( $name =~ /\@/  ){
        $page_content{USR} = $name;
   }
    $page_content{footer} = $page_function_hash{$param}->{'pFooter'};
    $page_content{Bcum} = $page_function_hash{$param}->{'pBcum'};
    $page_content{content} = $out; undef $out;
    $page_content{SID} = $sid;
    my ($fname, $lname) = getFullNameOfUserFromDb ( $name ); 
    $page_content{FNAME} = $fname;
    $page_content{LNAME} = $lname;
    
    
    $tt = Template->new;
        $tt->process('main_page.html', \%page_content , \$out)
        || die $tt->error;
    print $out;
    print $cgi->end_html();
}


sub F_ProcessOrder {
    my ($cgi) = @_;
    my $adressId = $cgi->param('AdrsId');
    header_print ( $cgi);
    my $param = $cgi->{'pg'};
    my ($user_name,$role) = is_valid_user($cgi);
    my $sid = $cgi->cookie('CGISESSID');
    my $session = CGI::Session->new( $sid );
    my $name = $session->param("usr_name");
    my $uid = $session->param("uid");
 
   #### Data for Menu Show 
    my %page_content;
    my @categories = GetProductTreeFromDb ();
     $page_content{categories} = \@categories;
    my $out = ''; 
    undef $out;
   
   #### Collecting and ordering the orders from cache    
    my @arrayOrders ;
    my %order_hash = getSessionOrderHash ($cgi);
    my $data;
    my @order_report;
    my @prices;
    foreach my $productId (keys (%order_hash)){
         my %product = getProductDetailFromDb ($productId);
         my %hash;
         $hash{productName} = $product{'productName'};
         $hash{'image'} = $product{'image'} ;
         $hash{'price'} = $product{'price'} ;
         $hash{'productId'} = $product{'productId'} ;
         $hash{'productUnit'} = $product{'productUnit'} ;
         $hash{'productQty'} = $order_hash{$productId};
         $hash{'productPrice'} = sprintf("%.2f", $hash{'productQty'} * $hash{'price'});
         push (@prices, $hash{'productPrice'} );
         push (@order_report,\%hash);
    }
    my $f_price = 0.0;
    foreach my $price ( @prices){
      $f_price = sprintf("%.2f", $f_price + $price);  
    }
   
    ############ Registering the Order  in 3 steps  
    
    ##### Step -1 create Order Into Db
    my $order_time = strftime('%Y-%m-%d %H:%M:%S',localtime);
    my $orderCode = myrandFromDb ();
    my %ohash ;
    @ohash {'orderCode','userId','orderDate','email','sid','addressId','orderCost','Active'}
         = ($orderCode,$uid,$order_time,$name,$sid,$adressId,$f_price,'1');
    
    my $ret = createOrderIntoDb( %ohash );
    if ($ret != 1 ){
      print $ret; 
    }
    
   ####### Step -2 register all Product Ordered into Db
    my $orderId = getOrderIdFronDb ($orderCode);
    foreach my $productOrder (@order_report){
         my %hash = %{$productOrder};
         $hash{orderId} = $orderId;
         my $ret = registerProductOrder (%hash);
          if ($ret != 1 ){
             print $ret; 
         }
    }
   
   ###### Step -3 set Order State to Placed
   my %hash;
   $hash{orderId} = $orderId;
   $hash{orderStatus} = 'PLACED';
   $hash{changeDate} = $order_time;
   $ret = setOrderState (%hash);
   if ($ret != 1 ){
      print $ret; 
    }
   ##### Step- 4 Clear all the cashed the order.
   dellAllOrder ($cgi);

    my $Ocount = OrderCount ( $cgi);
    if ($Ocount >= 1 ){
        $page_content{ORDERS} = $Ocount;
    }    
    my $price = int ($f_price);
    if ( !$price){
      $data->{NO_ORDERS} = 1;
    }
    $data->{LDIR} = $IMAGE_DIR;
    my @imagesAndSubCategory = getProductImageAndSubCategory ();
    $data->{IMAGES} = \@imagesAndSubCategory;   
    my $tt = Template->new;
        $tt->process($page_function_hash{$param}->{'pContent'}, $data , \$out)
        || die $tt->error;
    if ( $name =~ /\@/  ){
        $page_content{USR} = $name;
   }
    $page_content{footer} = $page_function_hash{$param}->{'pFooter'};
    $page_content{Bcum} = $page_function_hash{$param}->{'pBcum'};
    $page_content{content} = $out; undef $out;
    $page_content{SID} = $sid;
    my ($fname, $lname) = getFullNameOfUserFromDb ( $name ); 
    $page_content{FNAME} = $fname;
    $page_content{LNAME} = $lname;
    
    $tt = Template->new;
        $tt->process('main_page.html', \%page_content , \$out)
        || die $tt->error;
    print $out;
    print $cgi->end_html();
      
}
