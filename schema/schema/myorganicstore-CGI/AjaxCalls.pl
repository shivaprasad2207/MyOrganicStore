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
our (  $Header,   $IMAGE_DIR , $NEW_PASSWD  , $APP_CGI_BIN     
);
my $cgi = CGI->new;

my $flag = $cgi->param ( 'FLAG');

if ($flag eq 'GET_QTY_ORDER_DIALOG'){
    my ($user_name,$role) = is_valid_user ($cgi);
    my %productDetail = getProductDetailFromDb($cgi->param ( 'productId'));
    $productDetail{LDIR} = $IMAGE_DIR;
    $productDetail{USR} = $cgi->param ( 'usr');
    my $out;
    my $tt = Template->new;
        $tt->process('get_quantity_order_dialog.html',\%productDetail , \$out)
        || die $tt->error;
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
    print $out;
         
    
}elsif ($flag eq 'ADD_CATEGORY'){
     my $ret = addCategoryToDb($cgi->param( 'category'));
     print "Content-type: text/plain; charset=iso-8859-1\n\n";
    if ( $ret == 1 ){
           print '1';
    }else{            
            print  "<br><br><font color=\"red\"> <b> ERROR   ". $ret . "  While Adding Category name</b></font>";
    }
    
}elsif ( $flag eq 'ADD_SUB_CATEGORY'){
    my $ret = addSubCategoryToDb($cgi->param('subcategory'),$cgi->param( 'categoryId'));
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
    if ( $ret == 1 ){
           print '1';
    }else{            
            print  "<br><br><font color=\"red\"> <b> ERROR   ". $ret . "   While Adding subcategory name</b></font>";
    }
    
}elsif($flag eq 'MOD_CATEGORY'){
    my %p_hash = $cgi->Vars;
    my %hash;
    foreach my $key (keys(%p_hash)){
        if ( $key ne 'FLAG'){
                my $t = $key;
                $t =~ s/id_//g;
                $hash{$t} = $p_hash{$key};
        }
    }
    my $ret = updateCategoryNameToDb ( %hash );
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
     if ( $ret == 1 ){
           print '1';
    }else{
            print  "<br><br><font color=\"red\"> <b> ERROR   ". $ret . "  Added</b></font>";
    }      
}elsif ($flag eq 'MOD_SUB_CATEGORY'){
    my %p_hash = $cgi->Vars;
    my %hash;
    foreach my $key (keys(%p_hash)){
        if ( $key ne 'FLAG'){
                my $t = $key;
                $t =~ s/id_//g;
                $hash{$t} = $p_hash{$key};
        }
    }
    my $ret = updateSubCategoryNameToDb ( %hash );
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
     if ( $ret == 1 ){
           print '1';
    }else{
            print  "<br><br><font color=\"red\"> <b> ERROR   ". $ret . "  Added</b></font>";
    }      
    
}elsif($flag eq 'DEL_CATEGORY'){
    my %p_hash = $cgi->Vars;
    my %hash;
    foreach my $key (keys(%p_hash)){
        if ( $key ne 'FLAG'){
                my $t = $key;
                $t =~ s/id_//g;
                $hash{$t} = $p_hash{$key};
        }
    }
    my $ret = inActiveCategoryNameFromDb ( %hash );
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
     if ( $ret == 1 ){
           print '1';
    }else{
            print  "<br><br><font color=\"red\"> <b> ERROR   ". $ret . "  Deleting</b></font>";
    }    
}elsif ( $flag eq 'DEL_SUB_CATEGORY'){
     my %p_hash = $cgi->Vars;
    my %hash;
    foreach my $key (keys(%p_hash)){
        if ( $key ne 'FLAG'){
                my $t = $key;
                $t =~ s/id_//g;
                $hash{$t} = $p_hash{$key};
        }
    }
    my $ret = inActiveSubCategoryNameFromDb ( %hash );
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
     if ( $ret == 1 ){
           print '1';
    }else{
            print  "<br><br><font color=\"red\"> <b> ERROR   ". $ret . "  Deleting</b></font>";
    }    
}elsif ( $flag eq 'deleteProduct'){
    my %p_hash = $cgi->Vars;
    my %hash;
    foreach my $key (keys(%p_hash)){
        if ( $key ne 'FLAG'){
                my $t = $key;
                $t =~ s/id_//g;
                $hash{$t} = $p_hash{$key};
        }
    }
    my $ret = inActiveProductFromDb ( %hash );
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
     if ( $ret == 1 ){
           print '1';
    }else{
            print  "<br><br><font color=\"red\"> <b> ERROR   ". $ret . "  Deleting</b></font>";
    }    
}elsif ($flag eq 'GET_SUB_CATEGORY'){
    my ($categoryId,$categoryName) = split '__', $cgi->param('categoryId') ;
    my @subCategories = getSubCategoriesOfCategoryFromDb($categoryId);
    my %data ;
    $data{categoryId} = $categoryId;
    $data{categoryName} = $categoryName;
    $data{subCategories} = \@subCategories;
    $data{OPT} = $cgi->param('opt');
    my $out;
    my $tt = Template->new;
        $tt->process('subCategoryOptsSpecific.html', \%data, \$out)
        || die $tt->error;
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
    print $out;
    
}elsif( $flag eq   'cancelPlacedOrder'){
      my $ret =  cancelPlacedOrderFromDb ( $cgi->param('orderCode') );
      print "Content-type: text/plain; charset=iso-8859-1\n\n";
     if ( $ret == 1 ){
           print '1';
    }else{
            print  "<br><br><font color=\"red\"> <b> ERROR   ". $ret . "  Cancelling</b></font>";
    }    
      
}elsif ($flag eq  'getSubCategorySelectList'){
    my ($categoryId,$categoryName) = split '__', $cgi->param('categoryId') ;
    my @subCategories = getSubCategoriesOfCategoryFromDb($categoryId);
    my %data ;
    $data{categoryId} = $categoryId;
    $data{categoryName} = $categoryName;
    $data{subCategories} = \@subCategories;
    $data{OPT} = $cgi->param('opt');
    my $out;
    my $tt = Template->new;
        $tt->process('getSubCategorySelectList.html', \%data, \$out)
        || die $tt->error;
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
    print $out;
}elsif ($flag  eq 'getProductList'){
    my ($subCategoryId,$subCategoryName) = split '__', $cgi->param('subCategoryId') ;
    my ($categoryId) = $cgi->param('categoryId') ;
    my %data;
    $data{subCategoryId} = $subCategoryId;
    $data{subCategoryName} = $subCategoryName;
    $data{OPT} = $cgi->param('opt');
    my @products = getProductsOfSubCategoryFromDb($subCategoryName);
    $data{products} =  \@products;
    my $out;
    my $tt = Template->new;
        $tt->process('productSpecific.html', \%data, \$out)
        || die $tt->error;
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
    print $out;    
}elsif ($flag  eq 'getImageUploadForm'){
    my ($productId,$productName) = split '__', $cgi->param('product') ;
    my %data ;
    @data {'productId','productName'} = ($productId,$productName); 
    my $out;
    my $tt = Template->new;
        $tt->process('showImageUploadForm.html', \%data, \$out)
        || die $tt->error;
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
    print $out;    
}elsif($flag  eq 'addProductOfSubCategory'){
     my %hash;
     $hash{subCategoryId} = $cgi->param('subCategoryId') ;
     $hash{productName} = $cgi->param('productName') ;
     $hash{productUnit} = $cgi->param('productUnit') ;
     $hash{productPrice} = $cgi->param('productPrice') ;
     my $ret = addProductOfSubCategoryToDb (%hash);
     if( $ret == 1 ){
        print "Content-type: text/plain; charset=iso-8859-1\n\n";
        print $ret;
    }else{
        print "Content-type: text/plain; charset=iso-8859-1\n\n";
        print  "<br><br><font color=\"red\"> <b> ERROR $ret  Unable to  Add product</b></font>";
    }
    
}elsif($flag eq 'CHK_UID' ){
    my $ret = isEmailIdExistInDb ($cgi->param ( 'UID'));
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
    if ( $ret >= 1 ){
        print 1;    
    }else{
        print 0;
    }
}elsif ( $flag eq 'REG_USR' ){
    
   my %hash =  (
                         'firstname' =>  $cgi->param ( 'fname'),
                         'lastname' =>  $cgi->param ( 'lname'),
                         'email' => $cgi->param ( 'email'),                         
                         'adress' => $cgi->param ( 'adrs'),
                         'phone'  => $cgi->param ( 'phone'),
                         'role' => '1',
                         'Active' => '1',
                         'Zip' => $cgi->param ( 'zip'),                              
            );
   my $out;
   my $ret = addNewUserToDb ( %hash );
   if( $ret == 1 ){
        my $tt = Template->new;
        $tt->process('user_add_confirm.html', \%hash, \$out)
        || die $tt->error;
        print "Content-type: text/plain; charset=iso-8859-1\n\n";
        print $out;
   }else{
        print "Content-type: text/plain; charset=iso-8859-1\n\n";
        print  "<br><br><font color=\"red\"> <b> ERROR $ret  Unable to  New user  Added</b></font>";
   }
}elsif ( $flag eq 'updateProduct'){
    my %hash =  (                        
                    'productId' =>  $cgi->param ( 'productId'),                       
                    'productPrice' => $cgi->param ( 'productPrice'),
                    'productName'  => $cgi->param ( 'productName'),
                    'productUnit' => $cgi->param ( 'productUnit'),                    
         );    
     my $ret = modifyProductInToDb ( %hash );
      if( $ret == 1 ){
        print "Content-type: text/plain; charset=iso-8859-1\n\n";
        print $ret;
    }else{
        print "Content-type: text/plain; charset=iso-8859-1\n\n";
        print  "<br><br><font color=\"red\"> <b> ERROR $ret  Unable toModify  product</b></font>";
    }
    
}elsif( $flag eq 'MOD_USER_INFO'){
    my $sid = $cgi->cookie('CGISESSID');
    my $session = CGI::Session->new( $sid );
    my $uid = $session->param("uid");
    my $name = $session->param("usr_name");
    my %hash =  (
                         'firstname' =>  $cgi->param ( 'fname'),
                         'lastname' =>  $cgi->param ( 'lname'),                       
                         'adress' => $cgi->param ( 'adrs'),
                         'phone'  => $cgi->param ( 'phone'),
                         'Zip' => $cgi->param ( 'zip'),                              
                         'email' => $name,
         );
    my $ret = updateUserInfoToDb ( %hash );
    if( $ret == 1 ){
        print "Content-type: text/plain; charset=iso-8859-1\n\n";
        print $ret;
   }else{
        print "Content-type: text/plain; charset=iso-8859-1\n\n";
        print  "<br><br><font color=\"red\"> <b> ERROR $ret  Unable to  Update user Details</b></font>";
   }
    
}elsif ($flag eq 'GET_ORDER'){
    my $sid = $cgi->cookie('CGISESSID');
    my $session = CGI::Session->new( $sid );
    my $uid = $session->param("uid");
    my $name = $session->param("usr_name");
    my $qty =  $cgi->param("qty"); 
    my $productId =  $cgi->param("productId");
    my $orders = $productId.':'.$qty;
    registerOrderInToDb ($sid, $orders );
    my $subCategoryName = getSubCategoryNameByProdcutId( $productId );
  #  my $url = $APP_CGI_BIN."index.pl?pg=itemShow&nm="."$subCategoryName";
    my $url = $APP_CGI_BIN."index.pl?pg=DelOrder&productId=";
    $url = $url . $productId; 
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
    print $url;
    
}elsif($flag eq 'GET_TERMS'){
     my $out;
    my $tt = Template->new;
        $tt->process('term.html', undef, \$out)
        || die $tt->error;
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
    print $out; 
}elsif( $flag eq  'delAdrsForm'){
    my $sid = $cgi->cookie('CGISESSID');
    my $session = CGI::Session->new( $sid );
    my $uid = $session->param("uid");
    my $name = $session->param("usr_name");
    my %userProfile;
    my @otherAdress = getOtherUserAdressFromDb($name);
    $userProfile{OTHER_ADRESS} = \@otherAdress; 
    my $out;
    my $tt = Template->new;
        $tt->process('show_adress.html', \%userProfile, \$out)
        || die $tt->error;
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
    print $out;
}elsif( $flag eq 'getOrderDetail'){
     my $orderId = $cgi->param("orderId");        
     my @orderProducts = getOrderProductsFromDb ( $orderId );
     my ($data,$out);
     $data->{orderCode} = $cgi->param("orderCode");
     $data->{orders} = \@orderProducts;
     $data->{LDIR} = $IMAGE_DIR;
     my %hash = getOrderMetadataFromDb ( $orderId );
     $data->{adress} = $hash{adress};
     $data->{orderCost} = $hash{orderCost};
     $data->{orderDate} = $hash{orderDate};
     $data->{orderStatus} = $hash{orderStatus};
      my $tt = Template->new;
        $tt->process('order_product_list.html', $data, \$out)
        || die $tt->error;
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
    print $out;
}elsif( $flag eq 'delAdress'){
    delAdressFromDb($cgi->param('adressId'));
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
    print 1;
    
}elsif( $flag eq 'GET_USER_PROFILE'){
    my $sid = $cgi->cookie('CGISESSID');
    my $session = CGI::Session->new( $sid );
    my $uid = $session->param("uid");
    my $name = $session->param("usr_name");
    my %userProfile = getUserProfileByEmailFromDb($name);
    my @otherAdress = getOtherUserAdressFromDb($name);
    $userProfile{OTHER_ADRESS} = \@otherAdress; 
    my $out;
    my $tt = Template->new;
        $tt->process('show_user_profiel.html', \%userProfile, \$out)
        || die $tt->error;
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
    print $out;
}elsif ($flag eq 'GET_PASSWD_CHG_FORM'){
    my $out;
    my $tt = Template->new;
        $tt->process('passwd_change_form.html', undef, \$out)
        || die $tt->error;
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
    print $out; 
}elsif( $flag eq  'S_PWD'){
    my $sid = $cgi->cookie('CGISESSID');
    my $session = CGI::Session->new( $sid );
    my $name = $session->param("usr_name");
    my $cr = $cgi->param('cr');
    my $ret = setCrtoDb($name, $cr);
    if ( $ret == 1 ){
            print "Content-type: text/plain; charset=iso-8859-1\n\n";
            print  "<br><br><font color=\"green\"> <b> password changed successfully. </b></font>";
    }else{
            print "Content-type: text/plain; charset=iso-8859-1\n\n";
            print  "<br><br><font color=\"red\"> <b> Password Change ERROR   ". $ret . "</b></font>";
    }    
}elsif($flag eq 'SHOW_ADD_NEW_ADRS'){
    my $sid = $cgi->cookie('CGISESSID');
    my $session = CGI::Session->new( $sid );
    my $name = $session->param("usr_name");
    my $out;
    my $tt = Template->new;
        $tt->process('add_new_adress.html', undef, \$out)
        || die $tt->error;
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
    print $out; 
}elsif($flag eq  'getModifyProductForm'){
    my $out;
    my ($productId,$productName) = split '__', $cgi->param('product') ;
    my %hash = getProductDetailFromDb ($productId);
    $hash {LDIR} = $IMAGE_DIR;
    my $tt = Template->new;
        $tt->process('modify_product_details_form.html', \%hash, \$out)
        || die $tt->error;
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
    print $out; 
    
}elsif ($flag eq 'GET_USER_PROFILE_CHANGE_FORM'){
    my $sid = $cgi->cookie('CGISESSID');
    my $session = CGI::Session->new( $sid );
    my $uid = $session->param("uid");
    my $name = $session->param("usr_name");
    my %userProfile = getUserProfileByEmailFromDb($name);
    my @otherAdress = getOtherUserAdressFromDb($name);
    $userProfile{OTHER_ADRESS} = \@otherAdress; 
    my $out;
    my $tt = Template->new;
        $tt->process('modify_user_details_form.html', \%userProfile, \$out)
        || die $tt->error;
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
    print $out; 
    
}elsif( $flag eq 'ADD_NEW_ADRS'){
    my $sid = $cgi->cookie('CGISESSID');
    my $session = CGI::Session->new( $sid );
    my $name = $session->param("usr_name");
    my $adrs = $cgi->param('adrs');
    my $ret = addNewDeliveryAddress ($name, $adrs );
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
    print  '/cgi-bin/myorganicstore/index.pl?pg=Setting';
    
    
}elsif ($flag eq 'ADD_PROD'){
    my $sid = $cgi->cookie('CGISESSID');
    my $session = CGI::Session->new( $sid );
    my $uid = $session->param("uid");
   
    my $ret =  AddProductGroup (
                      $cgi->param ( 'ProductGrpName'),
                      $cgi->param ( 'ProductManufacturer'),
                      $cgi->param ( 'ProductShortDesc'),
                      $cgi->param ( 'ProductDesc'),
                      $cgi->param ( 'ProductLongDesc'),
                      $cgi->param ( 'uname'),
                      $cgi->param ( 'CategoryId'),
                      $cgi->param ( 'SubCategoryId'),
                      $cgi->param ( 'LogDescription')
    );
    
        if ( $ret == 1 ){
            print "Content-type: text/plain; charset=iso-8859-1\n\n";
            print  "<br><br><font color=\"green\"> <b> New Product   ". $cgi->param( 'ProductGrpName') . "  Added</b></font>";
        }else{
            print "Content-type: text/plain; charset=iso-8859-1\n\n";
            print  "<br><br><font color=\"red\"> <b> ERROR   ". $ret . "  Added</b></font>";
        }
        
}elsif( $flag eq 'MOD_PROD'){
    my $sid = $cgi->cookie('CGISESSID');
    my $session = CGI::Session->new( $sid );
    my $uid = $session->param("uid");
    my $ret =  ModifyProductGroup (
                      $cgi->param ( 'ProdId'),
                      $cgi->param ( 'ProductGrpName'),
                      $cgi->param ( 'ProductManufacturer'),
                      $cgi->param ( 'ProductShortDesc'),
                      $cgi->param ( 'ProductDesc'),
                      $cgi->param ( 'ProductLongDesc'),
                      $cgi->param ( 'uname'),
                      $cgi->param ( 'CategoryId'),
                      $cgi->param ( 'SubCategoryId'),
                      $cgi->param ( 'LogDescription')
    );
     if ( $ret == 1 ){
            print "Content-type: text/plain; charset=iso-8859-1\n\n";
            print  "<br><br><font color=\"green\"> <b> Product   ". $cgi->param( 'ProductGrpName') . "  Modified</b></font>";
        }else{
            print "Content-type: text/plain; charset=iso-8859-1\n\n";
            print  "<br><br><font color=\"red\"> <b> ERROR   ". $ret . "  Not able to Modify</b></font>";
        }
    
}elsif ( $flag eq  'DEL_PROD') {
    my $sid = $cgi->cookie('CGISESSID');
    my $session = CGI::Session->new( $sid );
    my $uid = $session->param("uid");
    my $ret =  DeleteProductGroup ( $cgi->param('ProdId'), $cgi->param('uname') , $cgi->param('ProductName'));
    if ( $ret == 1 ){
            print "Content-type: text/plain; charset=iso-8859-1\n\n";
            print  "<br><br><font color=\"green\"> <b> Product   ". $cgi->param( 'ProductGrpName') . "  Deleted</b></font>";
    }else{
            print "Content-type: text/plain; charset=iso-8859-1\n\n";
            print  "<br><br><font color=\"red\"> <b> ERROR   ". $ret . "  Not able to Delete</b></font>";
    }
    
}elsif( $flag eq 'GET_PROD_LIST' ){

      my @GetProductList = GetProductListFromDb ( $cgi->param ( 'ProdName') );
      my $out = '';
      my $data;
      $data->{ProdName} = $cgi->param ( 'ProdName') ;
      $data->{ProductList} = \@GetProductList;
      my $tt = Template->new;
        $tt->process('ProductSearchList.html', $data, \$out)
        || die $tt->error;
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print $out;
   
}elsif( $flag eq 'GET_PROD_DETAIL'){
    my $out;
    my %data = GetProductDetailsFromDb ( $cgi->param('ProdId'));
    my $tt = Template->new;
        $tt->process('ShowProductDetailsInDialog.html', \%data, \$out)
        || die $tt->error;
    print "Content-type: text/plain; charset=iso-8859-1\n\n";    
    print $out;    undef  $out;

}elsif ($flag eq 'REG_NEW_DIR_NODE'){
    my $node_name = $cgi->param ( 'node_name');
    my $uid = $cgi->param ( 'uid');
    my $ptid = $cgi->param ( 'ptid');
    my $iid = $cgi->param ( 'iid');
    my $nlevel = $cgi->param ( 'nlevel');
    my $is_active = $cgi->param ( 'is_active');
    my $is_enode = $cgi->param ( 'is_enode');
    $node_name =~ s/ /_/g;
    my $sql = " insert into tree_index
                        (
                            uid,    ptid,   iid,    nlevel, name,   is_active,  is_enode
                        )
                        values
                                (
                                  \'$uid\',  \'$ptid\',  \'$iid\',  \'$nlevel\',  \'$node_name\',  \'$is_active\',  \'$is_enode\'
                        );
    ";
    my $ret = reg_new_dir_node ( $sql );
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
    print 1;
    
}elsif ($flag eq 'CREATE_FILE_FORM'){
    my $sid = $cgi->cookie('CGISESSID');
    my $session = CGI::Session->new( $sid );
    my $uid = $session->param("uid");
    my $ptid = $cgi->param ( 'tid');
    my $iid = 1;
    my $pnlevel = get_nlevel_by_tid ( $ptid );
    my $nlevel = $pnlevel + 1;
    my $is_active = 1;
    my $is_enode = 1;
    
    if ( $pnlevel < 0 ) {
        print "Content-type: text/plain; charset=iso-8859-1\n\n";
        print  "<br><br><font color=\"red\"> <b> Not able to Get Parent node level</b></font>";
    }else{
        my %data = (
            uid => $uid,
            ptid => $ptid,
            iid => $iid,
            nlevel => $nlevel,
            is_active => $is_active,
            is_enode => $is_enode,
            clean => 'cont',
        );
        my $out = '';
        my $tt = Template->new;
        $tt->process('create_file_node_form.html', \%data, \$out)
             || die $tt->error;
        print "Content-type: text/plain; charset=iso-8859-1\n\n";
        print $out;
    }
}elsif ($flag eq 'REG_NEW_FILE_NODE'){
    my $node_name = $cgi->param ( 'node_name');
    $node_name =~ s/ /_/g;
    my $sid = $cgi->cookie('CGISESSID');
    my $session = CGI::Session->new( $sid );
    my $uid = $session->param("uid");
    my $ptid = $cgi->param ( 'ptid');
    my $iid = $cgi->param ( 'iid');
    my $nlevel = $cgi->param ( 'nlevel');
    my $is_active = $cgi->param ( 'is_active');
    my $is_enode = $cgi->param ( 'is_enode');
    my $text_content = $cgi->param ( 'text_content');            
    my $sql = " insert into tree_index
                        (
                            uid,    ptid,   iid,    nlevel, name,   is_active,   is_enode
                        )
                        values
                                (
                                  \'$uid\',  \'$ptid\',  \'$iid\',  \'$nlevel\',  \'$node_name\',  \'$is_active\',  \'$is_enode\'
                        );
    ";
    my $ret = insert_new_fnode_in_tree_t ( $sql );
    $sql = " select tid from tree_index
                                        where
                                                uid=\'$uid\'        and  ptid=\'$ptid\'         and
                                                nlevel=\'$nlevel\'  and  name=\'$node_name\'    and
                                                is_active=\'$is_active\' and  is_enode=\'$is_enode\' and iid=\'$iid\' ;
    ";
    my $file_nid = get_fnode_id_from_tree_t ( $sql ); 
    
    $sql = " insert into info_index (info,tid) values (\'$text_content\',\'$file_nid\') ;";
    
    $ret = insert_new_fnode_in_info_t ( $sql );
    
    $sql = " select iid from info_index where tid=\'$file_nid\';";
    
    my $file_iid = get_fnode_iid_from_info_t ( $sql );
    
    $sql = "update tree_index set iid=\'$file_iid\' where tid=\'$file_nid\';";
    
    $ret = update_new_fnode_in_tree_t ( $sql );
    
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
    print 1;  
}elsif ($flag eq 'SHOW_FNODE_INFO'){
    my $tid = $cgi->param ( 'tid');
    my $id = $cgi->param ( 'id');
    my $n_name = $cgi->param ( 'n_name');
    my %data = (
               id =>  $id,
               nid       => $tid,
               n_name => $n_name,
               clean => 'cont',
               
   );
   my $fnode_content = get_fnode_content_by_tid ( $tid );
   $data{ file_content } = $fnode_content;
   my $out = '';
   my $tt = Template->new;
        $tt->process('show_file_node_info.html', \%data, \$out)
        || die $tt->error;
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print $out;   
}elsif ($flag eq 'SHOW_NODE_RENAME_FORM'){
    my $tid = $cgi->param ( 'tid');
    my $node_name = get_node_name_by_tid ( $tid);
    my %data = (
               nid       => $tid,
               n_name => $node_name,
               clean => 'cont', 
   );
   
   my $out = '';
   my $tt = Template->new;
        $tt->process('node_rename_form.html', \%data, \$out)
        || die $tt->error;
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print $out;   
}elsif ($flag eq 'NODE_RENAME_SUBMIT'){
    my $tid = $cgi->param ( 'nid');
    my $o_node_name = $cgi->param ( 'o_node_name');
    my $n_node_name = $cgi->param ( 'n_node_name');
    $n_node_name =~ s/ /_/g;
    my $sql = " update tree_index set name=\'$n_node_name\' where tid=\'$tid\';";
    my $ret = rename_node_name ( $sql ) ; 
    my $out = '<font size="5" color="green"> <b>Node name '. "$o_node_name is Changed to $n_node_name". '</b></font>';
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
    print $out;   
}elsif ($flag eq 'SHOW_NODE_DEL_FORM'){
    my $tid = $cgi->param ( 'tid');
    my $node_name = get_node_name_by_tid ( $tid);
    my %data = (
               tid       => $tid,
               n_name => $node_name,
               clean => 'cont', 
   );
   
   my $out = '';
   my $tt = Template->new;
        $tt->process('node_del_form.html', \%data, \$out)
        || die $tt->error;
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print $out;   
}elsif ($flag eq 'NODE_DEL_CNFRM'){
    my $tid = $cgi->param ( 'tid');
    my $n_name = $cgi->param ( 'n_name');
    my $sql = "update tree_index set is_active=\'0\' where tid=\'$tid\';";
    my $ret = delete_node( $sql ) ; 
    my $out = '<font size="5" color="red"> <b>Node '. "$n_name is Deleted". '</b></font>';
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
    print $out;   
}elsif ($flag eq 'RENAME_FILE_NODE'){
    my $tid = $cgi->param ( 'tid');
    my $n_name = $cgi->param ( 'node_name'); $n_name =~ s/ /_/g;
    my $sql = "update tree_index set name=\'$n_name\' where tid=\'$tid\';";
    my $ret = rename_file_node( $sql ) ; 
    my $out = '<font size="5" color="red"> <b>Node '. "$n_name is renamed". '</b></font>';
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
    print $out;   
}elsif ($flag eq 'DEL_FILE_NODE'){
    my $tid = $cgi->param ( 'tid');
    my $sql = "update tree_index set is_active=\'0\' where tid=\'$tid\';";
    my $ret = delete_node( $sql ) ; 
    my $out = '<font size="5" color="red"> <b>Node '. "is Deleted". '</b></font>';
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
    print $out;   
}elsif ($flag eq 'UPDATE_FILE_NODE_DATA'){
    my $tid = $cgi->param ( 'tid');
    my $data = $cgi->param ( 'data');
    my $sql = "update info_index set info=\'$data\' where tid=\'$tid\';";
    my $ret = update_file_node_data( $sql ) ; 
    my $out = '<font size="5" color="red"> <b>Node '. "is data updated ". '</b></font>';
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
    print $out;   
}elsif ($flag eq 'ADD_NEW_USER'){
    my $uname = $cgi->param ( 'uname');
    my $passwd = md5_hex ('welcome');
    my $sql = "insert into login_info ( user_email, user_passwd, user_role, is_active) values ( \'$uname\',\'$passwd\',\'0\',\'1\');";
    my $ret = register_new_user ( $sql ) ;
    my $uid = get_uid_by_email($uname );
    my $root_name = 'Root_'.  $uid;  
    $sql = "
            insert into tree_index
                            ( uid ,     iid ,   nlevel, is_active,  is_enode,   is_root,    name )
                    values  ( \'$uid\' ,\'1\',  \'0\',  \'0\',      \'0\',      \'1\',      \'$root_name\' );
            ";
    $ret = register_new_root_id ( $sql );
    
    $sql = "select tid from  tree_index where  uid=\'$uid\' and name=\'$root_name\' and is_root=\'1\';";
    my $root_id = get_registered_new_root_id ( $sql );
    
    $sql = "update tree_index set ptid=\'$root_id\' where uid=\'$uid\' and is_root=\'1\' and name=\'$root_name\';";
    $ret = update_ptid_for_new_root_id ( $sql );
    
    $sql = "insert into tree_index
                            ( uid ,     ptid,        iid ,  nlevel, is_active,  is_enode, is_root,  name )
                    values  (\'$uid\', \'$root_id\', \'1\', \'1\',  \'1\',      \'0\',     \'0\' , \'Sample_dir_node1\' );";
    $ret = register_new_node ( $sql ) ;
    $sql = "insert into tree_index
                            ( uid ,     ptid,        iid ,  nlevel, is_active,  is_enode, is_root,  name )
                    values  (\'$uid\', \'$root_id\', \'1\', \'1\',  \'1\',      \'0\',     \'0\' , \'Sample_dir_node2\' );";
    
    $ret = register_new_node ( $sql ) ;
    
    my $out = '<br><br> <font size="5" color="green">
                    <b>User id  ' .
               '</b></font>' .
               '<font size="5" color="blue">' .
                    $uname  .
                '</b></font>' .
                '<font size="5" color="green"> <b>' .
                    "is registered with Password ".
                '</b></font>' .
            
                '<font size="5" color="blue">
                    welcome  ' .
               '</b></font>' .
               ' <br><br> <font size="5" color="red"> '.
                    ' Change password once you login '.
               '</b></font>'.
               
               '<br><br><a href="http://localhost/cgi-bin/MyTree/login.pl"> <font size="5" color="blue"> Login </b></font> </a>'
                ;
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
    print $out;   
}elsif ( $flag eq 'CHPASSWD' ){
    my $passwd  = $cgi->param ( 'p');
    $passwd = md5_hex ($passwd);
    my $uid = $cgi->param ( 'u');
    my $sql = "update login_info set user_passwd=\'$passwd\' where uid=\'$uid\';";
    my $ret = change_my_passwd ( $sql);
    my $out= '<font color="green" size="4"> Password Changed </font>';
    print "Content-type: text/plain; charset=iso-8859-1\n\n";
    print $out; 
}elsif ( $flag eq 'SHOW_FILE_IN_POPUP' ){
    my $tid  = $cgi->param ( 'tid');
    my $node_name = get_node_name_by_tid ( $tid);
    my %data = (
               n_name => $node_name,
   );
   my $fnode_content = get_fnode_content_by_tid ( $tid );
   $data{ file_content } = $fnode_content;
   my $out = '';
   my $out1 = '';
   my $tt = Template->new;
        $tt->process('show_file_node_info_popup.html', \%data, \$out)
        || die $tt->error;
   $tt = Template->new;
        $tt->process('script.html', \%data, \$out1)
        || die $tt->error;
   print "Content-type: text/html; charset=iso-8859-1\n\n";
   print $out1, $out;    
  
}









