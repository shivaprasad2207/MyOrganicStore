package DBLibs;
require(Exporter);
use warnings;
use strict;
use Data::Dumper;
use MyQuaries;
use DBConn;
use MyVars;
use Digest::MD5 qw(md5 md5_hex md5_base64);
use POSIX qw/strftime/;

   our @ISA = qw(Exporter);
   our @EXPORT    = qw (
                             is_uname_exist_in_db
                             GetProductTreeFromDb
			     getProductsOfSubCategoryFromDb
                             getProductDetailFromDb
			     isEmailIdExistInDb
			     addNewUserToDb
			     getFullNameOfUserFromDb
			     getSubCategoryNameByProdcutId
			     registerOrderInToDb
			     registerUpdatedOrderInToDb
			     getSessionOrderFromDb
			     getUserProfileByEmailFromDb
			     addNewDeliveryAddress
			     addCategoryToDb
			     addSubCategoryToDb
			     addProductOfSubCategoryToDb
			     getOtherUserAdressFromDb
			     setCrtoDb
			     updateUserInfoToDb
			     updateCategoryNameToDb
			     updateSubCategoryNameToDb
			     inActiveCategoryNameFromDb
			     inActiveSubCategoryNameFromDb
			     getSubCategoriesOfCategoryFromDb
			     getProductsOfSubCategoryFromDb
			     uploadImageNametoDb
			     modifyProductInToDb
			     inActiveProductFromDb
			     getProductImageAndSubCategory
			     getUserDetailsFromDb
			     delAdressFromDb
			     myrandFromDb
			     createOrderIntoDb
			     getOrderIdFronDb
			     registerProductOrder
			     setOrderState
			     getOrderListFromDb
			     getOrderProductsFromDb
			     getOrderMetadataFromDb
			     cancelPlacedOrderFromDb
			
                   );

our $db_exec;

our (
      $GET_CATEGORY_NAME,
      $GET_SUB_CATEGORY_NAME,
      $CALL_ADD_PROD,
      $CALL_MOD_PROD,
      $CALL_DEL_PROD,
      $GET_PRODUCT_NAME,
      $GET_PRODUCT_LIST,
   
     );

our (
      $NEW_PASSWD,
      $GET_CATEGORY,
      $GET_SUB_CATEGORY,
      $GET_PRODUCT,
      $GET_SUB_CATEGORY_PRODUCTS,
      $GET_PRODUCT_DETAIL,
      $IS_EMAIL_EXIST,
      $ADD_NEW_USER,
      $GET_USER_FULL_NAME,
      $GET_SUB_CATEGORY_NAME_BY_PRODUCT_ID,
      $GET_SESSION_ORDER,
      $REGISER_NEW_ORDER,
      $GET_USER_PROFILE,
      $ADD_NEW_DELIVERY_ADDRESS,
      $GET_NEW_DELIVERY_ADDRESS,
      $SET_CR,
      $UPDATE_USER_INFO,
      $ADD_NEW_CATEGORY,
      $MODIFY_CATEGORY_NAME,
      $INACTIVE_CATEGORY_NAME,
      $ADD_NEW_SUB_CATEGORY,
      $MODIFY_SUB_CATEGORY_NAME,
      $INACTIVE_SUB_CATEGORY_NAME,
      $ADD_NEW_PRODUCT,
      $ADD_IMAGE,
      $MODIFY_PRODUCT,
      $INACTIVE_PRODUCT,
      $GET_IMAGE_CATEGORY,
      $GET_USER_DETAILS,
      $DELETE_ADRESS,
      $MYRAND,      
      $ADD_NEW_ORDER,
      $GET_ORDER_ID,
      $ADD_PRODUCT_ORDER,
      $ADD_ORDER_STATE,
      $GET_ALL_ORDER,
      $GET_ORDER_PRODUCTS,
      $GET_ORDER_META,
      $CANCEL_ORDER,
     );



my @errors;

sub createOrderIntoDb{
    my (%hash) = @_;
   
    my $qh = $db_exec->prepare ($ADD_NEW_ORDER) or die (@errors, '<br>' . "* $ADD_NEW_ORDER *" . $db_exec->errstr. '<br>' );     
    $qh->bind_param(1, $hash{orderCode});
    $qh->bind_param(2, $hash{userId});
    $qh->bind_param(3, $hash{orderDate});
    $qh->bind_param(4, $hash{email});
    $qh->bind_param(5, $hash{sid});
    $qh->bind_param(6, $hash{addressId});
    $qh->bind_param(7, $hash{orderCost});
    $qh->bind_param(8, $hash{Active});	  
    eval {
	$qh->execute()or die (@errors, '<br>' . "* $ADD_NEW_ORDER *" . $qh->errstr. '<br>' );
    };
    if($@){
	 print "<pre>" , Dumper \%hash , "</pre>";
	return $@;
    }else{
	return 1;
    }     
}

sub registerProductOrder{
    my (%hash) = @_;
    my $qh = $db_exec->prepare ($ADD_PRODUCT_ORDER) or die (@errors, '<br>' . "* $ADD_PRODUCT_ORDER *" . $db_exec->errstr. '<br>' );     
    $qh->bind_param(1, $hash{orderId});
    $qh->bind_param(2, $hash{productId});
    $qh->bind_param(3, $hash{productName});
    $qh->bind_param(4, $hash{price});
    $qh->bind_param(5, $hash{productUnit});
    $qh->bind_param(6, $hash{productPrice});
    $qh->bind_param(7, $hash{productQty});
     eval {
	$qh->execute()or die (@errors, '<br>' . "* $ADD_PRODUCT_ORDER *" . $qh->errstr. '<br>' );
    };
    if($@){
	 print "<pre>" , Dumper \%hash , "</pre>";
	return $@;
    }else{
	return 1;
    }     
}

sub setOrderState{
    my (%hash) = @_;
    my $qh = $db_exec->prepare ($ADD_ORDER_STATE) or die (@errors, '<br>' . "* $ADD_ORDER_STATE *" . $db_exec->errstr. '<br>' );     
    $qh->bind_param(1, $hash{orderId});
    $qh->bind_param(2, $hash{orderStatus});
    $qh->bind_param(3, $hash{changeDate});
     eval {
	$qh->execute()or die (@errors, '<br>' . "* $ADD_ORDER_STATE *" . $qh->errstr. '<br>' );
    };
    if($@){
	 print "<pre>" , Dumper \%hash , "</pre>";
	return $@;
    }else{
	return 1;
    }     
}
sub cancelPlacedOrderFromDb {
     my ($orderCode) = @_;
    my $qh = $db_exec->prepare ($CANCEL_ORDER) or die (@errors, '<br>' . "* $CANCEL_ORDER *" . $db_exec->errstr. '<br>' );     
    eval {
	$qh->execute($orderCode)or die (@errors, '<br>' . "* $CANCEL_ORDER *" . $qh->errstr. '<br>' );
    };
    if($@){
	return $@;
    }else{
	return 1;
    }      
}
sub getOrderIdFronDb{
    my ($orderCode) = @_;
    my $qh = $db_exec->prepare ($GET_ORDER_ID) or die (@errors, '<br>' . "* $GET_ORDER_ID *" . $db_exec->errstr. '<br>' );     
    $qh->execute($orderCode)or die (@errors, '<br>' . "* $GET_ORDER_ID *" . $qh->errstr. '<br>' );
    my ($ret) = $qh->fetchrow_array();    
    return $ret;
}

sub getOrderMetadataFromDb{
    my ($orderId) = @_;
    my $qh = $db_exec->prepare ($GET_ORDER_META) or die (@errors, '<br>' . "* $GET_ORDER_META *" . $db_exec->errstr. '<br>' );     
    $qh->execute($orderId)or die (@errors, '<br>' . "* $GET_ORDER_META *" . $qh->errstr. '<br>' );
    my %hash;
    @hash { 'adress', 'orderCost', 'orderDate','orderCode','orderStatus'} = $qh->fetchrow_array();    
    return %hash;
}


sub myrandFromDb {
      my $qh = $db_exec->prepare ($MYRAND) or die (@errors, '<br>' . "* $MYRAND *" . $db_exec->errstr. '<br>' );       
      $qh->execute()or die (@errors, '<br>' . "* $MYRAND *" . $qh->errstr. '<br>' );
      my ($rand) = $qh->fetchrow_array();
      return $rand;
}

sub GetProductTreeFromDb_OLD(){
    my $qh = $db_exec->prepare ($GET_CATEGORY) or die (@errors, '<br>' . "* $GET_CATEGORY *" . $db_exec->errstr. '<br>' );       
    $qh->execute()or die (@errors, '<br>' . "* $GET_CATEGORY *" . $qh->errstr. '<br>' );
    my %category_hash;
    while ( my ($categoryName, $categoryId) = $qh->fetchrow_array() ){
       my $qh = $db_exec->prepare ($GET_SUB_CATEGORY) or die (@errors, '<br>' . "* $GET_SUB_CATEGORY *" . $db_exec->errstr. '<br>' );     
       $qh->bind_param(1, $categoryId);
       $qh->execute()or die (@errors, '<br>' . "* $GET_SUB_CATEGORY *" . $qh->errstr. '<br>' );
       my $sub_category_hash_ref;
       while ( my ($subCategoryName, $subCategoryId) = $qh->fetchrow_array() ){
	    my $qh = $db_exec->prepare ($GET_PRODUCT) or die (@errors, '<br>' . "* $GET_PRODUCT *" . $db_exec->errstr. '<br>' );     
	    $qh->bind_param(1, $subCategoryId);
	    $qh->execute()or die (@errors, '<br>' . "* $GET_PRODUCT *" . $qh->errstr. '<br>' );
             my $product_hash_ref;
	     while ( my ($productName, $productId, $productImage,$productPrice) = $qh->fetchrow_array() ){		
		$product_hash_ref->{$productName}{'image'} = $productImage;
		$product_hash_ref->{$productName}{'price'} = $productPrice;
	     } 	
     	    $sub_category_hash_ref->{$subCategoryName} = $product_hash_ref; 
       }
	$category_hash{$categoryName} =  $sub_category_hash_ref;
    }
    return %category_hash;
}
sub getOrderListFromDb {
    my ($email,$sid) = @_;
    my $qh = $db_exec->prepare ($GET_ALL_ORDER) or die (@errors, '<br>' . "* $GET_ALL_ORDER *" . $db_exec->errstr. '<br>' );
    $qh->execute($email,$sid)or die (@errors, '<br>' . "* $GET_ALL_ORDER *" . $qh->errstr. '<br>' );
   
    my @orderList;
    while ( my ($orderId, $orderCode) = $qh->fetchrow_array() ){
	my %hash ;
	@hash {'orderId', 'orderCode' } = ($orderId, $orderCode);
        push (@orderList, \%hash);
    }	
    return @orderList;      
}


sub getOrderProductsFromDb {
    my ($orderId) = @_;
    my $qh = $db_exec->prepare ($GET_ORDER_PRODUCTS) or die (@errors, '<br>' . "* $GET_ORDER_PRODUCTS *" . $db_exec->errstr. '<br>' );
    $qh->execute($orderId)or die (@errors, '<br>' . "* $GET_ORDER_PRODUCTS *" . $qh->errstr. '<br>' );
    my @orderProducts;
    while ( my ( $orderId, $productId, $productName , $productUnitPrice , $productUnit, $productPrice, $productQty, $productImage ) = $qh->fetchrow_array() ){
	 my %hash;
	@hash{ 'orderId', 'productId', 'productName' , 'productUnitPrice' , 'productUnit', 'productPrice','productQty', 'productImage'}
			= ( $orderId, $productId, $productName , $productUnitPrice , $productUnit, $productPrice, $productQty, $productImage );
	push (@orderProducts,\%hash );		
    }	
    return @orderProducts;
}

sub getProductImageAndSubCategory{
	my $qh = $db_exec->prepare ($GET_IMAGE_CATEGORY) or die (@errors, '<br>' . "* $GET_IMAGE_CATEGORY *" . $db_exec->errstr. '<br>' );       
	$qh->execute()or die (@errors, '<br>' . "* $GET_IMAGE_CATEGORY *" . $qh->errstr. '<br>' );
	my @imagesAndSubCategory;
	while ( my ($productImage, $subCategoryName) = $qh->fetchrow_array() ){
	    my %hash ;
	    @hash{ 'productImage',  'subCategoryName' } =  ($productImage, $subCategoryName);
            push  (@imagesAndSubCategory,\%hash);	
	}
	return @imagesAndSubCategory;
}

sub getUserDetailsFromDb{
    my($email) = @_; 
    my $qh = $db_exec->prepare ($GET_USER_DETAILS) or die (@errors, '<br>' . "* $GET_USER_DETAILS *" . $db_exec->errstr. '<br>' );       
	$qh->execute($email)or die (@errors, '<br>' . "* $GET_USER_DETAILS *" . $qh->errstr. '<br>' );
	my %hash;
	@hash { 'firstname', 'lastname' , 'email', 'adress', 'phone', 'Zip' } =  $qh->fetchrow_array();
	return %hash;
}

sub GetProductTreeFromDb (){
    my $qh = $db_exec->prepare ($GET_CATEGORY) or die (@errors, '<br>' . "* $GET_CATEGORY *" . $db_exec->errstr. '<br>' );       
    $qh->execute()or die (@errors, '<br>' . "* $GET_CATEGORY *" . $qh->errstr. '<br>' );
    my @categories;
    while ( my ($categoryName, $categoryId) = $qh->fetchrow_array() ){
       my %category_hash;
       my $qh = $db_exec->prepare ($GET_SUB_CATEGORY) or die (@errors, '<br>' . "* $GET_SUB_CATEGORY *" . $db_exec->errstr. '<br>' );     
       $qh->bind_param(1, $categoryId);
       $qh->execute()or die (@errors, '<br>' . "* $GET_SUB_CATEGORY *" . $qh->errstr. '<br>' );
       my @subCategories;
       while ( my ($subCategoryName, $subCategoryId) = $qh->fetchrow_array() ){
	    my %sub_category_hash;
	    my $qh = $db_exec->prepare ($GET_PRODUCT) or die (@errors, '<br>' . "* $GET_PRODUCT *" . $db_exec->errstr. '<br>' );     
	    $qh->bind_param(1, $subCategoryId);
	    $qh->execute()or die (@errors, '<br>' . "* $GET_PRODUCT *" . $qh->errstr. '<br>' );
             my @products;
	     while ( my ($productName, $productId, $productImage,$productPrice) = $qh->fetchrow_array() ){		
		my %product_hash;
		$product_hash{productName} = $productName;
		$product_hash{productId} = $productId;
		$product_hash{productImage} = $productImage;
		$product_hash{productPrice} = $productPrice;
		push (@products , \%product_hash);
	     }	     
     	    $sub_category_hash{subCategoryName} = $subCategoryName;	    
	    $sub_category_hash{subCategoryId} = $subCategoryId;
	    $sub_category_hash{product} = \@products;
	    push ( @subCategories ,\%sub_category_hash);
       }
	$category_hash{categoryName} = $categoryName;
	$category_hash{categoryId} = $categoryId;
	$category_hash{subCategory} = \@subCategories;
	push (@categories, \%category_hash );
    }
    return @categories;
}

sub getSubCategoriesOfCategoryFromDb {
    my ($categoryId) = @_;
    my $qh = $db_exec->prepare ($GET_SUB_CATEGORY) or die (@errors, '<br>' . "* $GET_SUB_CATEGORY *" . $db_exec->errstr. '<br>' );       
    $qh->execute($categoryId)or die (@errors, '<br>' . "* $GET_SUB_CATEGORY *" . $qh->errstr. '<br>' );
    my @subCategories;
    while ( my ($subCategoryName, $subCategoryId) = $qh->fetchrow_array() ){
	my %sub_category_hash;
	$sub_category_hash{subCategoryName} = $subCategoryName;	    
	$sub_category_hash{subCategoryId} = $subCategoryId;
	push (@subCategories,\%sub_category_hash);
    }
    return @subCategories;
}


sub getFullNameOfUserFromDb {
     my ($email) = @_;
      my $qh = $db_exec->prepare ($GET_USER_FULL_NAME) or die (@errors, '<br>' . "* $GET_USER_FULL_NAME *" . $db_exec->errstr. '<br>' );
      $qh->bind_param(1, $email);
      $qh->execute()or die (@errors, '<br>' . "* $GET_USER_FULL_NAME *" . $qh->errstr. '<br>' );
      my ($fname, $lname) = $qh->fetchrow_array();
      return ($fname, $lname);
}

sub getSubCategoryNameByProdcutId {
    my ($productId) = @_;
     my $qh = $db_exec->prepare ($GET_SUB_CATEGORY_NAME_BY_PRODUCT_ID) or die (@errors, '<br>' . "* $GET_SUB_CATEGORY_NAME_BY_PRODUCT_ID *" . $db_exec->errstr. '<br>' );
      $qh->bind_param(1, $productId);
      $qh->execute()or die (@errors, '<br>' . "* $GET_SUB_CATEGORY_NAME_BY_PRODUCT_ID *" . $qh->errstr. '<br>' );
      my ($subCategoryName) = $qh->fetchrow_array();
      return $subCategoryName;
}

sub getProductsOfSubCategoryFromDb {
    my ($subCategoryName) = @_ ;
    my $qh = $db_exec->prepare ($GET_SUB_CATEGORY_PRODUCTS) or die (@errors, '<br>' . "* $GET_SUB_CATEGORY_PRODUCTS *" . $db_exec->errstr. '<br>' );     
    $qh->bind_param(1, $subCategoryName);
    $qh->execute()or die (@errors, '<br>' . "* $GET_CATEGORY *" . $qh->errstr. '<br>' );
    my @products ;
    while ( my ($productName, $productId, $productImage,$productPrice,$productUnit) = $qh->fetchrow_array() ){		
	        my %product_hash;
		$product_hash{'productName'} = $productName;
		$product_hash{'image'} = $productImage;
		$product_hash{'price'} = $productPrice;
		$product_hash{'productId'} = $productId;
		$product_hash{'productUnit'} = $productUnit;
                push (@products ,\%product_hash);	     
    
    }
    return @products;
}


sub getUserProfileByEmailFromDb {
    my ($email) = @_ ;
    my $qh = $db_exec->prepare ($GET_USER_PROFILE) or die (@errors, '<br>' . "* $GET_USER_PROFILE *" . $db_exec->errstr. '<br>' );     
    $qh->execute($email)or die (@errors, '<br>' . "* $GET_USER_PROFILE *" . $qh->errstr. '<br>' );
    my ($firstname, $lastname, $lemail,$adress,$phone,$Zip) = $qh->fetchrow_array();
    my %hash;
    @hash{ 'firstname', 'lastname', 'lemail', 'adress', 'phone', 'Zip' } = ($firstname, $lastname, $lemail,$adress,$phone,$Zip);
    return %hash;
}
sub getOtherUserAdressFromDb {
    my ($email) = @_ ;
    my $qh = $db_exec->prepare ($GET_NEW_DELIVERY_ADDRESS) or die (@errors, '<br>' . "* $GET_NEW_DELIVERY_ADDRESS *" . $db_exec->errstr. '<br>' );     
    $qh->execute($email) or die (@errors, '<br>' . "* $GET_NEW_DELIVERY_ADDRESS *" . $qh->errstr. '<br>' );
    my @address ;
    while ( my ($adress,$adressId )= $qh->fetchrow_array() ){	
       my %hash;
       $hash{'adress'} = $adress;
       $hash{'adressId'} = $adressId;
       push (@address, \%hash);
    }
    return @address;
}
sub addNewDeliveryAddress {
     my ($email, $adrs) = @_ ;
     my $qh = $db_exec->prepare ($ADD_NEW_DELIVERY_ADDRESS) or die (@errors, '<br>' . "* $ADD_NEW_DELIVERY_ADDRESS *" . $db_exec->errstr. '<br>' );
       eval {
        $qh->execute($adrs,$email )or die (@errors, '<br>' . "* $ADD_NEW_DELIVERY_ADDRESS *" . $qh->errstr. '<br>' );
    };
    if($@){
	return $@;
    }else{
	return 1;
    }  
}

sub delAdressFromDb{
    my ($adrsId) = @_;    
     my $qh = $db_exec->prepare ($DELETE_ADRESS) or die (@errors, '<br>' . "* $DELETE_ADRESS *" . $db_exec->errstr. '<br>' );
       eval {
        $qh->execute($adrsId )or die (@errors, '<br>' . "* $DELETE_ADRESS *" . $qh->errstr. '<br>' );
    };
    if($@){
	return $@;
    }else{
	return 1;
    }  
}

sub uploadImageNametoDb {
     my ($image, $ProductId) = @_ ;
      my $qh = $db_exec->prepare ($ADD_IMAGE) or die (@errors, '<br>' . "* $ADD_IMAGE *" . $db_exec->errstr. '<br>' );
       eval {
        $qh->execute($image, $ProductId)or die (@errors, '<br>' . "* $ADD_IMAGE *" . $qh->errstr. '<br>' );
    };
    if($@){
	return $@;
    }else{
	return 1;
    }  
    
}
sub addCategoryToDb {
    my ($category) = @_ ;
     my $qh = $db_exec->prepare ($ADD_NEW_CATEGORY) or die (@errors, '<br>' . "* $ADD_NEW_CATEGORY *" . $db_exec->errstr. '<br>' );
       eval {
        $qh->execute( $category )or die (@errors, '<br>' . "* $ADD_NEW_CATEGORY *" . $qh->errstr. '<br>' );
    };
    if($@){
	return $@;
    }else{
	return 1;
    }     
}

sub addSubCategoryToDb {
    my ( $subcategory , $categoryId) = @_;
      my $qh = $db_exec->prepare ($ADD_NEW_SUB_CATEGORY) or die (@errors, '<br>' . "* $ADD_NEW_SUB_CATEGORY *" . $db_exec->errstr. '<br>' );
       eval {
        $qh->execute(  $subcategory , $categoryId )or die (@errors, '<br>' . "* $ADD_NEW_SUB_CATEGORY *" . $qh->errstr. '<br>' );
    };
    if($@){
	return $@;
    }else{
	return 1;
    }     
}

sub addProductOfSubCategoryToDb {
    my (%hash) = @_;
      my $qh = $db_exec->prepare ($ADD_NEW_PRODUCT) or die (@errors, '<br>' . "* $ADD_NEW_PRODUCT *" . $db_exec->errstr. '<br>' );
       eval {
        $qh->execute( $hash{subCategoryId},$hash{productName},$hash{productPrice},$hash{productUnit})or die (@errors, '<br>' . "* $ADD_NEW_PRODUCT *" . $qh->errstr. '<br>' );
    };
    if($@){
	return $@;
    }else{
	return 1;
    }     
    
    
}

sub setCrtoDb {
    my($name, $cr) = @_;
    my $qh = $db_exec->prepare ($SET_CR) or die (@errors, '<br>' . "* $SET_CR *" . $db_exec->errstr. '<br>' );
       eval {
        $qh->execute($cr , $name)or die (@errors, '<br>' . "* $SET_CR *" . $qh->errstr. '<br>' );
    };
    if($@){
	return $@;
    }else{
	return 1;
    }
}
sub isEmailIdExistInDb {
    my ($email) = @_;
    my $qh = $db_exec->prepare ($IS_EMAIL_EXIST) or die (@errors, '<br>' . "* $IS_EMAIL_EXIST *" . $db_exec->errstr. '<br>' );     
    $qh->bind_param(1, $email);
    $qh->execute()or die (@errors, '<br>' . "* $IS_EMAIL_EXIST *" . $qh->errstr. '<br>' );
     my ($ret) = $qh->fetchrow_array();
     if ( $ret >= 1){
	return 1;
     }else{
	return 0;
     }
}

sub addNewUserToDb {
    my (%hash) = @_;
    my $qh = $db_exec->prepare ($ADD_NEW_USER) or die (@errors, '<br>' . "* $ADD_NEW_USER *" . $db_exec->errstr. '<br>' );     
    $qh->bind_param(1, $hash{'firstname'});
    $qh->bind_param(2, $hash{'lastname'});
    $qh->bind_param(3, $hash{'email'});
    $qh->bind_param(4, $NEW_PASSWD );
    $qh->bind_param(5, $hash{'adress'});
    $qh->bind_param(6, $hash{'phone'});
    $qh->bind_param(7, $hash{'role'});
    $qh->bind_param(8, $hash{'Active'});
    $qh->bind_param(9, $hash{'Zip'});
    
    eval {
        $qh->execute()or die (@errors, '<br>' . "* $ADD_NEW_USER *" . $qh->errstr. '<br>' );

    };
    if($@){
	return $@;
    }else{
	return 1;
    }
}

sub updateCategoryNameToDb {
    my (%hash) = @_;
    foreach my $categoryId (keys (%hash)){
	my $qh = $db_exec->prepare ($MODIFY_CATEGORY_NAME) or die (@errors, '<br>' . "* $MODIFY_CATEGORY_NAME *" . $db_exec->errstr. '<br>' );     
     	eval {
		$qh->execute($hash{$categoryId} , $categoryId )or die (@errors, '<br>' . "* $MODIFY_CATEGORY_NAME *" . $qh->errstr. '<br>' );
	};
	if($@){
	    return $@;
	}
    }
    return 1;
}


sub modifyProductInToDb {
    my (%hash) = @_;
     my $qh = $db_exec->prepare ($MODIFY_PRODUCT) or die (@errors, '<br>' . "* $MODIFY_PRODUCT *" . $db_exec->errstr. '<br>' );     
    eval {
      $qh->execute( $hash{productName},$hash{productPrice},$hash{productUnit},$hash{productId} )or die (@errors, '<br>' . "* $MODIFY_PRODUCT *" . $qh->errstr. '<br>' );
    };
    if ($@){
	retrun $@;
    }else{
	return 1;
    }
    
}

sub updateSubCategoryNameToDb{
    my (%hash) = @_;
    foreach my $subcategoryId (keys (%hash)){
	my $qh = $db_exec->prepare ($MODIFY_SUB_CATEGORY_NAME) or die (@errors, '<br>' . "* $MODIFY_SUB_CATEGORY_NAME *" . $db_exec->errstr. '<br>' );     
     	eval {
		$qh->execute($hash{$subcategoryId} , $subcategoryId )or die (@errors, '<br>' . "* $MODIFY_SUB_CATEGORY_NAME *" . $qh->errstr. '<br>' );
	};
	if($@){
	    return $@;
	}
    }
    return 1; 
}

sub inActiveCategoryNameFromDb {
    my (%hash) = @_;
     foreach my $subcategoryId (keys (%hash)){
	my $qh = $db_exec->prepare ($INACTIVE_CATEGORY_NAME) or die (@errors, '<br>' . "* $INACTIVE_CATEGORY_NAME *" . $db_exec->errstr. '<br>' );     
     	eval {
		$qh->execute($subcategoryId )or die (@errors, '<br>' . "* $INACTIVE_CATEGORY_NAME *" . $qh->errstr. '<br>' );
	};
	if($@){
	    return $@;
	}
    }
    return 1;
}

sub inActiveSubCategoryNameFromDb {
    my (%hash) = @_;
     foreach my $categoryId (keys (%hash)){
	my $qh = $db_exec->prepare ($INACTIVE_SUB_CATEGORY_NAME) or die (@errors, '<br>' . "* $INACTIVE_SUB_CATEGORY_NAME *" . $db_exec->errstr. '<br>' );     
     	eval {
		$qh->execute($categoryId )or die (@errors, '<br>' . "* $INACTIVE_SUB_CATEGORY_NAME *" . $qh->errstr. '<br>' );
	};
	if($@){
	    return $@;
	}
    }
    return 1;
}

sub inActiveProductFromDb {
    my (%hash) = @_;
     foreach my $categoryId (keys (%hash)){
	my $qh = $db_exec->prepare ($INACTIVE_PRODUCT) or die (@errors, '<br>' . "* $INACTIVE_PRODUCT *" . $db_exec->errstr. '<br>' );     
     	eval {
		$qh->execute($categoryId )or die (@errors, '<br>' . "* $INACTIVE_PRODUCT *" . $qh->errstr. '<br>' );
	};
	if($@){
	    return $@;
	}
    }
    return 1;    
}

sub updateUserInfoToDb {
      my (%hash) = @_;
    my $qh = $db_exec->prepare ($UPDATE_USER_INFO) or die (@errors, '<br>' . "* $UPDATE_USER_INFO *" . $db_exec->errstr. '<br>' );     
    $qh->bind_param(1, $hash{'firstname'});
    $qh->bind_param(2, $hash{'lastname'});
    $qh->bind_param(3, $hash{'adress'});
    $qh->bind_param(4, $hash{'phone'});
    $qh->bind_param(5, $hash{'Zip'});
    $qh->bind_param(6, $hash{'email'});
    eval {
        $qh->execute()or die (@errors, '<br>' . "* $UPDATE_USER_INFO *" . $qh->errstr. '<br>' );

    };
    if($@){
	return $@;
    }else{
	return 1;
    }
}

sub getSessionOrderFromDb {
    my ( $sid) = @_;
    my $qh = $db_exec->prepare ($GET_SESSION_ORDER) or die (@errors, '<br>' . "* $GET_SESSION_ORDER *" . $db_exec->errstr. '<br>' );     
    $qh->bind_param(1, $sid);
    $qh->execute()or die (@errors, '<br>' . "* $GET_SESSION_ORDER *" . $qh->errstr. '<br>' );
    my ($order) = $qh->fetchrow_array();
    if ($order !~ /[0-9]/ ){
	return 'NULL';
    }else{
	return $order;
    }    
}

sub registerOrderInToDb{
    my ($sid,$order) = @_;
    my $sessionOrder = getSessionOrderFromDb ($sid);
    if ( $sessionOrder ne 'NULL' ){
	$order = $sessionOrder . ';' . $order ;
    }
    my $qh = $db_exec->prepare ($REGISER_NEW_ORDER) or die (@errors, '<br>' . "* $REGISER_NEW_ORDER *" . $db_exec->errstr. '<br>' );     
    eval {
      $qh->execute($order, $sid )or die (@errors, '<br>' . "* $REGISER_NEW_ORDER *" . $qh->errstr. '<br>' );
    };
    if ($@){
	retrun $@;
    }else{
	return 1;
    }
}

sub registerUpdatedOrderInToDb{
    my ($sid,$order) = @_;
    my $qh = $db_exec->prepare ($REGISER_NEW_ORDER) or die (@errors, '<br>' . "* $REGISER_NEW_ORDER *" . $db_exec->errstr. '<br>' );     
    eval {
      $qh->execute($order, $sid )or die (@errors, '<br>' . "* $REGISER_NEW_ORDER *" . $qh->errstr. '<br>' );
    };
    if ($@){
	retrun $@;
    }else{
	return 1;
    }
}


sub getProductDetailFromDb {
    my ($productId) = @_;
     my $qh = $db_exec->prepare ($GET_PRODUCT_DETAIL) or die (@errors, '<br>' . "* $GET_PRODUCT_DETAIL *" . $db_exec->errstr. '<br>' );     
    $qh->bind_param(1, $productId);
    $qh->execute()or die (@errors, '<br>' . "* $GET_PRODUCT_DETAIL *" . $qh->errstr. '<br>' );
    my %product ;
    while ( my ($productName, $productId, $productImage,$productPrice,$productUnit) = $qh->fetchrow_array() ){		
	        my %product_hash;
		$product{'productName'} = $productName;
		$product{'image'} = $productImage;
		$product{'price'} = $productPrice;
		$product{'productId'} = $productId;
		$product{'productUnit'} = $productUnit;
    }
    return %product;
}


sub GetProductNameFromDb {
    
    my $qh = $db_exec->prepare ($GET_PRODUCT_NAME) or die (@errors, '<br>' . "* $GET_PRODUCT_NAME *" . $db_exec->errstr. '<br>' );      
    
    $qh->execute()or die (@errors, '<br>' . "* $GET_PRODUCT_NAME *" . $qh->errstr. '<br>' );
    my @ProductNames;
    while ( my ($ProductGroupId, $ProductName ) = $qh->fetchrow_array() ){
        my %hash;
        @hash{'value', 'label' } = ($ProductGroupId, $ProductName ); 
        push (@ProductNames,\%hash);
    }
    return @ProductNames;
}

sub GetCategoryNamesFromDb {
    
    my $qh = $db_exec->prepare ($GET_CATEGORY_NAME) or die (@errors, '<br>' . "* $GET_CATEGORY_NAME *" . $db_exec->errstr. '<br>' );      
    
    $qh->execute()or die (@errors, '<br>' . "* $GET_CATEGORY_NAME *" . $qh->errstr. '<br>' );
    my @CategoryNames;
    while ( my ($CategoryName, $CategoryId ) = $qh->fetchrow_array() ){
        my %hash;
        @hash{'CategoryName', 'CategoryId'} = ($CategoryName, $CategoryId );
        push (@CategoryNames,\%hash);
    }
    return @CategoryNames;
}

sub GetProductListFromDb {
    my ($Product) = @_;
    
    my $qh = $db_exec->prepare ($GET_PRODUCT_LIST) or die (@errors, '<br>' . "* $GET_PRODUCT_LIST *" . $db_exec->errstr. '<br>' );      
    $qh->bind_param( 1, "%$Product%" );
    $qh->execute()or die (@errors, '<br>' . "* $GET_PRODUCT_LIST *" . $qh->errstr. '<br>' );
    my @ProductNames;
    while ( my ( $ProductName, $Manufacturer, $Description , $Category, $SubCategory, $Availability   ) = $qh->fetchrow_array() ){
        my %hash;
        @hash{'ProductGroupId','ProductName', 'Manufacturer', 'Description', 'Category', 'SubCategory', 'Availability'} =
                                   ( $ProductName, $Manufacturer, $Description , $Category, $SubCategory, $Availability );
         push (@ProductNames,\%hash);
    }
    return @ProductNames;
}

sub GetProductDetailsFromDb {
    my ($ProductId) = @_;
    
    my $qh = $db_exec->prepare ($GET_PRODUCT_DETAIL) or die (@errors, '<br>' . "* $GET_PRODUCT_DETAIL *" . $db_exec->errstr. '<br>' );      
    $qh->bind_param( 1, "$ProductId" );
    $qh->execute()or die (@errors, '<br>' . "* $GET_PRODUCT_LIST *" . $qh->errstr. '<br>' );
    my %ProductDetail;
    @ProductDetail{'ProductGroupId','ProductGrpName','ProductManufacturer','ProductDesc','ProductShortDesc','ProductLongDesc','Category','SubCategory'}
            = $qh->fetchrow_array(); 
    return %ProductDetail;
    
}
sub GetSubCategoryNamesFromDb {
    
    my $qh = $db_exec->prepare ($GET_SUB_CATEGORY_NAME) or die (@errors, '<br>' . "* $GET_SUB_CATEGORY_NAME *" . $db_exec->errstr. '<br>' );      
    
    $qh->execute()or die (@errors, '<br>' . "* $GET_SUB_CATEGORY_NAME *" . $qh->errstr. '<br>' );
    my @SubCategoryNames;
    while ( my ($CategoryName, $CategoryId ) = $qh->fetchrow_array() ){
        my %hash;
        @hash{'SubCategoryName', 'SubCategoryId'} = ($CategoryName, $CategoryId );
        push (@SubCategoryNames,\%hash);
    }
    return @SubCategoryNames;
}
sub DeleteProductGroup {
     my ( $ProductGrpID,$uname,$ProductName) = @_;
     my $qh = $db_exec->prepare ($CALL_DEL_PROD) or die (@errors, '<br>' . "* $CALL_DEL_PROD *" . $db_exec->errstr. '<br>' );         
     $qh->bind_param(1, $ProductGrpID);
     $qh->bind_param(2, $ProductName);
     $qh->bind_param(3, $uname);
     eval {
        $qh->execute()or die (@errors, '<br>' . "* $CALL_DEL_PROD *" . $qh->errstr. '<br>' );
    };
    
    if ($@){
        return $@;
    }
    return 1;
}


sub AddProductGroup{
    my (
        $ProductGrpName, 
        $ProductManufacturer ,
        $ProductShortDesc ,
        $ProductDesc ,
        $ProductLongDesc ,
        $uname ,
        $CategoryId ,
        $SubCategoryId,
        $LogDescription
    ) = @_;
    
    my $qh = $db_exec->prepare ( $CALL_ADD_PROD );
    $qh->bind_param(1, $ProductGrpName);
    $qh->bind_param(2, $ProductManufacturer);
    $qh->bind_param(3, $ProductDesc);
    $qh->bind_param(4, $ProductShortDesc);
    $qh->bind_param(5, $ProductLongDesc);
    $qh->bind_param(6, $CategoryId);
    $qh->bind_param(7, 'This is Image');
    $qh->bind_param(8, $SubCategoryId);
    $qh->bind_param(9, $uname);
    $qh->bind_param(10, $LogDescription);
    eval {
        $qh->execute()or die (@errors, '<br>' . "* $CALL_ADD_PROD *" . $qh->errstr. '<br>' );
    };
    
    if ($@){
        return $@;
    }
    return 1;

}


sub ModifyProductGroup{
    my (
        $ProductGrpNameId,
        $ProductGrpName, 
        $ProductManufacturer ,
        $ProductShortDesc ,
        $ProductDesc ,
        $ProductLongDesc ,
        $uname ,
        $CategoryId ,
        $SubCategoryId,
        $LogDescription
    ) = @_;
    
    my $qh = $db_exec->prepare ( $CALL_MOD_PROD );
    $qh->bind_param(1, $ProductGrpNameId);
    $qh->bind_param(2, $ProductGrpName);
    $qh->bind_param(3, $ProductManufacturer);
    $qh->bind_param(4, $ProductDesc);
    $qh->bind_param(5, $ProductShortDesc);
    $qh->bind_param(6, $ProductLongDesc);
    $qh->bind_param(7, $CategoryId);
    $qh->bind_param(8, 'This is Image');
    $qh->bind_param(9, $SubCategoryId);
    $qh->bind_param(10, $uname);
    $qh->bind_param(11, $LogDescription);
    eval {
        $qh->execute()or die (@errors, '<br>' . "* $CALL_MOD_PROD *" . $qh->errstr. '<br>' );
    };
    
    if ($@){
        return $@;
    }
    return 1;

}


sub db_exec_single_val_ret {
   my ($sql) = @_;
   my $qh = $db_exec->prepare ($sql) or push (@errors, '<br>' . "* $sql *" . $db_exec->errstr. '<br>' );
   $qh->execute()or push (@errors, '<br>' . "* $sql *" . $qh->errstr. '<br>' );   
   my ($ret)  = $qh->fetchrow_array() ;
   if ( defined ( $ret )){
               return $ret;   
   }else{
               return ('__FAIL__');    
   }  
}


sub is_uname_exist_in_db{
    my ($uname ) = @_;
    my $sql = "select COUNT(*) from t_user where email=\'$uname\' and Active=\'1\';";
    my $qh = $db_exec->prepare ($sql) or die (@errors, '<br>' . "* $sql *" . $db_exec->errstr. '<br>' );      
    $qh->execute()or die (@errors, '<br>' . "* $sql *" . $qh->errstr. '<br>' );  
    my ($count) = $qh->fetchrow_array();
    if ( $count){
      return 0;
    }else{
      return 1;
    }
}


sub get_uname_by_uid_from_db{
   my ( $uid ) = @_;
   my $sql = "SELECT user_email  FROM login_info where uid=\'$uid\';";   
   my $qh = $db_exec->prepare ($sql) or die (@errors, '<br>' . "* $sql *" . $db_exec->errstr. '<br>' );
   $qh->execute()or die (@errors, '<br>' . "* $sql *" . $qh->errstr. '<br>' );
   my ($uname) = $qh->fetchrow_array();
   return $uname;
}

sub get_all_user_info_from_db {
     my $sql = "SELECT user_email, uid, user_role FROM login_info where is_active=\'1\';";
    
    my $qh = $db_exec->prepare ($sql) or die (@errors, '<br>' . "* $sql *" . $db_exec->errstr. '<br>' );      
    
    $qh->execute()or die (@errors, '<br>' . "* $sql *" . $qh->errstr. '<br>' );
    my @user_list;
    while ( my ($email , $uid, $role) = $qh->fetchrow_array() ){
      my %hash;
      @hash{'email', 'uid', 'role'} = ($email , $uid, $role);
      push (@user_list,\%hash);
    }
    return @user_list;
}

sub get_project_info_by_proj_id_from_db {
   my ( $proj_id ) = @_;
   my $sql = "select project_name , project_desc from projects where project_id=\'$proj_id\' and is_active=\'1\';"; 
   my $qh = $db_exec->prepare ($sql) or die (@errors, '<br>' . "* $sql *" . $db_exec->errstr. '<br>' );      
   $qh->execute()or die (@errors, '<br>' . "* $sql *" . $qh->errstr. '<br>' ); 
   my %project_info;
   @project_info { 'project_name' , 'project_desc' } =  $qh->fetchrow_array();
   return %project_info;
}


sub my_sql_exec {
    my ($sql) = @_;
    my $qh = $db_exec->prepare ($sql) or die (@errors, '<br>' . "* $sql *" . $db_exec->errstr. '<br>' );
    $qh->execute()or die (@errors, '<br>' . "* $sql *" . $qh->errstr. '<br>' );
    return 1;
}

sub create_uniq_string {
         my $length_of_randomstring=shift;
         my @chars=('a'..'z','A'..'Z','0'..'9','_');
         my $random_string;
         foreach (1..$length_of_randomstring){
		$random_string.=$chars[rand @chars];
	}
	return $random_string;
}

sub generate_my_sql_rand_db {
   
   my $sql= "SELECT CAST(RAND() * 99999999 AS UNSIGNED) + 1 as randNum";
   my $qh = $db_exec->prepare ($sql) or die (@errors, '<br>' . "* $sql *" . $db_exec->errstr. '<br>' );
   $qh->execute()or die (@errors, '<br>' . "* $sql *" . $qh->errstr. '<br>' ); 
   my ($rand) = $qh->fetchrow_array();
   return $rand;
}

sub db_exec_return_boolean {
   my ($sql) = @_;
   my $ret;
    my @errors;
   eval { 
         my $qh = $db_exec->prepare ($sql) or push (@errors, '<br>' . "* $sql *" . $db_exec->errstr. '<br>' );
         $qh->execute()or push (@errors, '<br>' . "* $sql *" . $qh->errstr. '<br>' );   
         $ret = $qh->fetchrow_array() ;
     };
      if ( $@ ){
            return 0;
      }else{
            if ( defined ( $ret )){
               return 1;   
            }else{
               return 0;   
            } 
   }    
}


1
;