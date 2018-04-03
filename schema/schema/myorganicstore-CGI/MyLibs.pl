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

sub is_valid_user {
    my ($cgi) = @_;
    my $sid = $cgi->cookie('CGISESSID');
    if ($sid){
        my $session = CGI::Session->new( $sid );
        my $name = $session->param("usr_name");
        my $role = $session->param("role");
        return ($name,$role);
    }else {
        my $cookie = $cgi->cookie(
                            -name=>'CGISESSID',
                            -value=>$sid,
                            -expires=>'-1d',
                        );
        print $cgi->redirect(-cookie=>$cookie,-location=>"login.pl?status=Alogout"); 
        return;    
    }
}




sub  get_photos_of_directory_by_did {   
    my ( $did ) = @_;
    my @photos = get_photos_of_directory_by_did_db( $did);
    return @photos;
}
sub get_photo_gal_desc_by_did{
    my ( $did ) = @_;
    my $gal_desc = get_photo_gal_desc_by_did_db( $did);
    return  $gal_desc ;
}

sub get_photo_gal_dir_by_did {
     my ( $did ) = @_;
    my $gal_dir = get_photo_gal_dir_by_did_db( $did);
    return  $gal_dir ;
    
    
}

sub serach_text {
    my ( $uid , $txt ) = @_;
    my @ret1 = serach_text_in_dir_from_db ( $uid , $txt );
    my @ret2 = serach_text_in_file_from_db( $uid , $txt );
    return (\@ret1,\@ret2);
}

sub  reg_new_dir_node{
   my ($sql) = @_;
   my $ret = raw_sql_exec ( $sql );
   return $ret;   
}

sub insert_new_fnode_in_tree_t{
   my ($sql) = @_;
   my $ret = raw_sql_exec ( $sql );
   return $ret;     
}

sub insert_new_fnode_in_info_t{
   my ($sql) = @_;
   my $ret = raw_sql_exec ( $sql );
   return $ret;     
}

sub update_new_fnode_in_tree_t{
   my ($sql) = @_;
   my $ret = raw_sql_exec ( $sql );
   return $ret;     
}


sub get_nlevel_by_tid {
   my( $tid ) = @_;
   my $sql = "select is_enode from tree_index where tid=\'$tid\' ;";
   my $ret = db_exec_single_val_ret ( $sql);
   if ( $ret eq '__FAIL__'){return -1;}else{return $ret;}
}

sub get_node_name_by_tid {
   my( $tid ) = @_;
   my $sql = "select name from tree_index where tid=\'$tid\' ;";
   my $ret = db_exec_single_val_ret ( $sql);
   if ( $ret eq '__FAIL__'){return -1;}else{return $ret;}
}

sub rename_node_name {
    my ( $sql ) = @_;
    my $ret = raw_sql_exec ( $sql );
    return $ret;    
}

sub rename_file_node{
    my ( $sql ) = @_;
    my $ret = raw_sql_exec ( $sql );
    return $ret;    
}

sub register_new_user {
    my ( $sql ) = @_;
    my $ret = raw_sql_exec ( $sql );
    return $ret;    
}

sub update_file_node_data{
    my ( $sql ) = @_;
    my $ret = raw_sql_exec ( $sql );
    return $ret;    
}

sub delete_node {
    my ( $sql ) = @_;
    my $ret = raw_sql_exec ( $sql );
    return $ret; 
}

sub get_fnode_id_from_tree_t {
    my ( $sql ) = @_;
    my $ret = db_exec_single_val_ret ( $sql);
    if ( $ret eq '__FAIL__'){return -1;}else{return $ret;}  
}

sub get_fnode_iid_from_info_t {
    my ( $sql ) = @_;
    my $ret = db_exec_single_val_ret ( $sql);
    if ( $ret eq '__FAIL__'){return -1;}else{return $ret;}  
}

sub find_node_type {
    my ( $tid ) = @_;
    my $sql = "select is_enode from tree_index where tid=\'$tid\' ;";
    my $ret = db_exec_single_val_ret ( $sql);
    if ( $ret eq '__FAIL__'){return -1;}else{return $ret;}   
}

sub get_fnode_content_by_tid {
    my ( $tid ) = @_;
    my $sql = "select info from info_index where tid=\'$tid\' ;";
    my $ret = db_exec_single_val_ret ( $sql);
    if ( $ret eq '__FAIL__'){return -1;}else{return $ret;}      
}

sub get_registered_new_root_id {
    my ( $sql ) = @_;
    my $ret = db_exec_single_val_ret ( $sql);
    if ( $ret eq '__FAIL__'){return -1;}else{return $ret;}   
}

sub update_ptid_for_new_root_id {
    my ( $sql ) = @_;
    my $ret = raw_sql_exec ( $sql );
    return $ret;        
}

sub register_new_node {
    my ( $sql ) = @_;
    my $ret = raw_sql_exec ( $sql );
    return $ret;        
}

sub change_my_passwd {
    my ( $sql) = @_;
     my $ret = raw_sql_exec ( $sql );
    return $ret; 
}
sub register_new_root_id {
    my ( $sql ) = @_;
    my $ret = raw_sql_exec ( $sql );
    return $ret;       
}

sub get_root_id_by_uid{
     my ( $uid ) = @_;
    my $sql = "select tid from tree_index where uid=\'$uid\' and is_root=\'1\' ;";
    my $ret = db_exec_single_val_ret ( $sql);
    if ( $ret eq '__FAIL__'){return -1;}else{return $ret;}      
}

sub get_uid_by_email {
    my ($uname ) = @_;
    my $sql = "select uid from login_info where user_email=\'$uname\';";
    my $ret = db_exec_single_val_ret ( $sql);
    if ( $ret eq '__FAIL__'){return -1;}else{return $ret;}      
}


sub get_all_l1_node_by_uid{
    my ( $uid, $ptid)  = @_;
    my @ret = get_all_l1_node_by_uid_from_db ( $uid, $ptid);
    return @ret;
}

sub get_all_l2_node_by_ptid {
    my $tid = shift ;
     my @ret = get_all_l2_node_by_ptid_from_db ( $tid );
    return @ret;   
    
}

sub GetBasename {
	my $fullname = shift;
	my(@parts);
	# check which way our slashes go.
	if ( $fullname =~ /(\\)/ ) {
		@parts = split(/\\/, $fullname);
	} else {
		@parts = split(/\//, $fullname);
	}
	return(pop(@parts));
}

sub is_user_authorised{
   my  ( $user_name , $user_passwd ) = @_;
   if ( user_authentication ( $user_name , $user_passwd )){
      return 1;   
   }else{
      return 0;
   }
}

sub get_all_prod_by_proj_id {
   my ( $proj_id ) = @_;
   my @prods = get_all_prod_by_proj_id_db ( $proj_id );
   return @prods;
}

sub is_uname_exist {
    my ( $uname ) = @_;
    my $ret = is_uname_exist_in_db ( $uname);  
    return $ret;
}

sub get_tc_id_by_tc_info{
   my ( $test_desc,$project,$product,$component ) = @_;
   my $sql = "select test_id from staging_index
                                             where
                                                project=\'$project\' and
                                                product=\'$product\' and
                                                component=\'$component\' and
                                                test_desc=\'$test_desc\' and
                                                is_active=\'1\';
            ";
   my $tc_id = get_tc_id_by_tc_info_from_db($sql);
   return $tc_id;   
}

sub det_tcs_by_info{
   my ($proj_name,$prod_name,$comp_name,$tc_name ) = @_;
   my $sql = " update staging_index
                                    set
                                 is_active=\'0\' 
                                    where
                                                project=\'$proj_name\' and
                                                product=\'$prod_name\' and
                                                component=\'$comp_name\' and
                                                test_desc=\'$tc_name\' 
                                                ;
            ";
   my $ret = raw_sql_exec ( $sql );
   return $ret;   
}

sub is_tcs_exist{
   my ( $test_desc, $project, $product, $component) = @_;
   my $sql = "select COUNT(*) from staging_index
                      where
                           test_desc=\'$test_desc\' and project=\'$project\'
                                 and product=\'$product\' and component=\'$component\'
                                 and is_active=\'1\';
             ";
   my $ret = is_tcs_exist_db ($sql);
   return $ret;
}

sub add_new_project {
   my ($proj_name,$proj_desc,$uid) = @_;
   my $sql = "insert into projects
                                 (project_name,project_desc,is_active,uid)
                              values
                           (\'$proj_name\', \'$proj_desc\',  \'1\', \'$uid\' );
             ";
   my $ret = raw_sql_exec ( $sql );
   return $ret;
}

sub is_project_exist{
    my ($proj_name) = @_;
    my $sql = "select COUNT(*) from projects where project_name=\'$proj_name\';" ;
    my $ret = is_tcs_exist_db ($sql);
    return $ret;
}

sub get_all_proj_info {
    my @ret = get_all_proj_info_from_db ();
    return @ret;
}

sub get_list_of_all_proj {
    my @ret = get_list_of_all_proj_from_db ();
    return @ret;
}

sub raw_sql_exec{
   my( $sql ) = @_;
   my $ret = my_sql_exec ($sql);
   return $ret;  
}


sub get_all_comp_by_prod_id {
   my ( $prod_id ) = @_;
   my @comp_info = get_all_comp_by_prod_id_db ($prod_id );
   return @comp_info;
}

sub get_project_by_proj_id {
   my( $proj_id ) = @_;
   my $sql = "select project_name from projects where project_id=\'$proj_id\' ;";
   my $ret = db_exec_single_val_ret ( $sql);
   if ( $ret eq '__FAIL__'){return 0;}else{return $ret;}
}

sub get_product_by_prod_id {
   my( $prod_id ) = @_;
   my $sql = "select product_name from products where product_id=\'$prod_id\' ;";
   my $ret = db_exec_single_val_ret ( $sql);
   if ( $ret eq '__FAIL__'){return 0;}else{return $ret;}
}

sub get_component_by_comp_id {
   my( $comp_id ) = @_;
   my $sql = "select comp_name from components where comp_id=\'$comp_id\' ;";
   my $ret = db_exec_single_val_ret ( $sql);
   if ( $ret eq '__FAIL__'){return 0;}else{return $ret;}
}

sub get_tc_name_by_tc_id {
   my ($tc_id) = @_;
   my $sql = "select test_desc from staging_index where test_id=\'$tc_id\' ;";
   my $ret = db_exec_single_val_ret ( $sql);
   if ( $ret eq '__FAIL__'){return 0;}else{return $ret;}
   
}
sub get_tcs_ids{
   my ( $proj_name, $prod_name, $comp_name) = @_;
   my @ret = get_tcs_ids_db ( $proj_name, $prod_name, $comp_name);
   return @ret;
}

sub get_all_tcs_by_tc_id{
   my ($tc_id) = @_;
   my @ret = get_all_tcs_by_tc_id_db ($tc_id);
   return @ret;
}

sub get_proj_tree_info{
    my ($uid, $proj_id , $proj_name ) = @_;
    my %proj_info_tree;
    my @products = get_all_prod_by_proj_id ( $proj_id );
    my $i = 0;
    foreach my $key (@products){
      my %product = %{$key};
      my $prod_id = $product{product_id};
      my $product_name = $product{product_name};
      $proj_info_tree{$i}{prod_id} = $prod_id;
      $proj_info_tree{$i}{product_name} = $product_name;
      my $j = 0;
      my @comp_info = get_all_comp_by_prod_id ( $prod_id );
      foreach my $key (@comp_info){
         my %comp = %{$key};  
         $proj_info_tree{$i}{components}{$j}{comp_name} = $comp{comp_name};
         $proj_info_tree{$i}{components}{$j}{comp_id} = $comp{comp_id};
         my @tc_ids = get_tcs_ids ($proj_name, $product_name, $comp{comp_name} );
               my $k = 0;
               foreach my $tc_id (  @tc_ids ){
                  my %tc_info = %{$tc_id};
                  $proj_info_tree{$i}{components}{$j}{tcs}{$k}{tc_name} = $tc_info{ test_desc };  
                  $proj_info_tree{$i}{components}{$j}{tcs}{$k}{tc_id} = $tc_info{ test_id };
                  $k++;
               }
         $j++;         
      } 
       $i++; 
   }
   return %proj_info_tree;
}

sub get_product_tree_info {
   my ($uid, $prod_id , $prod_name, $proj_id ) = @_;
   my $proj_name = get_project_by_proj_id ($proj_id);
   my %comp_info_tree;
   my @comp_info = get_all_comp_by_prod_id ( $prod_id );
   my $i = 0;
   foreach my $key (@comp_info){
      my %comp = %{$key};
      $comp_info_tree{$i}{comp_name} = $comp{comp_name};     
      $comp_info_tree{$i}{comp_id} = $comp{comp_id};
      my @tc_ids = get_tcs_ids ($proj_name, $prod_name, $comp{comp_name} );
      my $j = 0;
      foreach my $tc_id (  @tc_ids ){
         my %tc_info = %{$tc_id};
         $comp_info_tree{$i}{tcs}{$j}{tc_name} = $tc_info{ test_desc };  
         $comp_info_tree{$i}{tcs}{$j}{tc_id} = $tc_info{ test_id };
         $j++;
      }
      $i++;
   }
   return %comp_info_tree;
}


sub del_proj_tree{
    my ($uid, $proj_id , $proj_name ) = @_;
    my %proj_info_tree;
    my @products = get_all_prod_by_proj_id ( $proj_id );
    my @del;
    foreach my $key (@products){
      my %product = %{$key};
      my $prod_id = $product{product_id};
      my $product_name = $product{product_name};
      my @comp_info = get_all_comp_by_prod_id ( $prod_id );
      foreach my $key (@comp_info){
         my %comp = %{$key};  
         my $comp_name = $comp{comp_name};
         my $comp_id = $comp{comp_id};
         my @tc_ids = get_tcs_ids ($proj_name, $product_name, $comp_name );
               my $k = 0;
               foreach my $tc_id (  @tc_ids ){
                  my %tc_info = %{$tc_id};
                  my $tc_id = $tc_info{ test_id };
                  my $sql_tc_del = "update staging_index set is_active=\'0\', uid=\'$uid\' where test_id=\'$tc_id\';";
                  push ( @del , $sql_tc_del);
               }
          my $sql_com_del = "update components set is_active=\'0\', uid=\'$uid\' where comp_id=\'$comp_id\';";      
          push ( @del , $sql_com_del);
      } 
      my $sql_prod_del = "update products set is_active=\'0\', uid=\'$uid\' where product_id=\'$prod_id\';";      
      push ( @del , $sql_prod_del);
   }
   my $sql_proj_del = "update projects set is_active=\'0\', uid=\'$uid\' where project_id=\'$proj_id\';";      
   push ( @del , $sql_proj_del);
   
   foreach my $sql (@del){
      raw_sql_exec ($sql);
   }
   return 1;
}

sub del_product_tree{
   my ($uid, $prod_id , $proj_name ) = @_;
   my %prod_info_tree;
   my @del;
      my $product_name = get_product_by_prod_id ( $prod_id);
      my @comp_info = get_all_comp_by_prod_id ( $prod_id );
      foreach my $key (@comp_info){
         my %comp = %{$key};  
         my $comp_name = $comp{comp_name};
         my $comp_id = $comp{comp_id};
         my @tc_ids = get_tcs_ids ($proj_name, $product_name, $comp_name );
               my $k = 0;
               foreach my $tc_id (  @tc_ids ){
                  my %tc_info = %{$tc_id};
                  my $tc_id = $tc_info{ test_id };
                  my $sql_tc_del = "update staging_index set is_active=\'0\', uid=\'$uid\' where test_id=\'$tc_id\';";
                  push ( @del , $sql_tc_del);
               }
          my $sql_com_del = "update components set is_active=\'0\', uid=\'$uid\' where comp_id=\'$comp_id\';";      
          push ( @del , $sql_com_del);
      } 
      my $sql_prod_del = "update products set is_active=\'0\', uid=\'$uid\' where product_id=\'$prod_id\';";      
      push ( @del , $sql_prod_del);
      
   foreach my $sql (@del){
      raw_sql_exec ($sql);
   }
   return 1;                  
}

sub del_comp_tree {
   my (%data) = @_;
   my @del;
   my $uid = $data{uid};
   my $comp_id = $data{comp_id};
   my $sql_com_del = "update components set is_active=\'0\', uid=\'$uid\' where comp_id=\'$comp_id\';";
   my @tc_ids = @{$data{tcs}};
   foreach my $tc_id (  @tc_ids ){
         my %tc_info = %{$tc_id};
         my $tc_id = $tc_info{ test_id };
         my $sql_tc_del = "update staging_index set is_active=\'0\', uid=\'$uid\' where test_id=\'$tc_id\';";
         push ( @del , $sql_tc_del);
   }
   push ( @del , $sql_com_del);
   foreach my $sql (@del){
      raw_sql_exec ($sql);
   }
   return 1;
}



######################################################################################################################

sub get_all_project_data {
    my @projects = get_all_project_data_from_db ();
    return @projects;
}


sub get_project_info_by_proj_id {
         my( $proj_id ) = @_ ;
         my %project_info = get_project_info_by_proj_id_from_db ( $proj_id );
         return %project_info;
} 

sub get_all_instances_of_proj {
   my ( $proj_id ) = @_;
   my @insta_info = get_all_instances_of_proj_from_db ( $proj_id );
   return @insta_info;
}

sub get_all_compos_of_instance {
   my ( $insta_id) = @_;
   my @compos = get_all_compos_of_instance_from_db ( $insta_id );
   return @compos;
}

########################### PROJECT RELATED #########################

sub delete_project {
   my ($proj_id, $proj_name, $cgi) = @_;
   my ($uid , $time) = get_uid_and_time ( $cgi);
   my $sql = "update projects set is_active=\'0\', time=\'$time\',uid=\'$uid\' where project_name=\'$proj_name\' and project_id=\'$proj_id\';";
   my $ret = my_sql_exec ($sql);
   return $ret;
}


sub  modify_project_name {
   my ($proj_name,$proj_id, $cgi) = @_;
   my ($uid , $time) = get_uid_and_time ( $cgi);
   my $sql = "update projects set project_name=\'$proj_name\' , time=\'$time\',uid=\'$uid\' where project_id=\'$proj_id\';";
   my $ret = my_sql_exec ($sql);
   return $ret;
}
######################### INSTANCE RELATED ##################

sub add_new_instance_of_proj {
   my ($insta_name , $proj_id, $cgi ) = @_;
   my ($uid , $time) = get_uid_and_time ( $cgi);
   my $sql = "insert into instances ( project_id , insta_name , is_active, time, uid)
                    values (\'$proj_id\' , \'$insta_name\'  ,  \'1\' , \'$time\', \'$uid\');";
   my $ret = my_sql_exec ($sql);
   return $ret;
}

sub modify_porj_insta_name {
   my ( $new_insta_name, $insta_id , $cgi ) = @_;
   my ($uid , $time) = get_uid_and_time ( $cgi);
   my $sql = "update  instances set insta_name=\'$new_insta_name\' , time=\'$time\',uid=\'$uid\' where insta_id=\'$insta_id\';";
   my $ret = my_sql_exec ($sql);
   return $ret;
}

sub delete_insta_name {
   my ($insta_id , $cgi) = @_;
   my ($uid , $time) = get_uid_and_time ( $cgi);
   my $sql = "update  instances set is_active=\'0\' , time=\'$time\',uid=\'$uid\'  where insta_id=\'$insta_id\';";
   my $ret = my_sql_exec ($sql);
   return $ret;
}

######################### COMPONENT RELATED ##################

sub add_new_component{
   my ($insta_id,$type,$host_name,$ip,$user,$passwd,$comment,$cgi ) = @_;
   my ($uid , $time) = get_uid_and_time ( $cgi);
   my $sql = "insert into components ( insta_id , host_name , ip, user, type, password, Comments, is_active,time,uid)
                    values (\'$insta_id\', \'$host_name\', \'$ip\', \'$user\', \'$type\', \'$passwd\',\'$comment\', \'1\', \'$time\' , \'$uid\');";
   my $ret = my_sql_exec ($sql);
   return $ret;
}



sub get_comp_info_by_comp_id {
   my ($comp_id) = @_;
   my %comp_info = get_comp_info_by_comp_id_from_db ( $comp_id );
   return %comp_info;
}

sub exec_raw_sql{
   my( $sql ) = @_;
   my $ret = my_sql_exec ($sql);
   return $ret;  
}

sub get_insta_name_by_insta_id {
   my ( $insta_id ) = @_;
   my $insta_name = get_insta_name_by_insta_id_from_db ( $insta_id ) ;
   return $insta_name;
}

sub get_passwd_by_comp_id {
   my( $comp_id ) = @_;
   my $passwd =  get_passwd_by_comp_id_from_db ( $comp_id);
   return $passwd;
}

sub get_uid_and_time {
   my ($cgi) = @_;
   my $time = strftime('%Y-%m-%d %H:%M:%S',localtime);
   my $sid = $cgi->cookie('CGISESSID');
   my $session = CGI::Session->new( $sid );
   my $uid = $session->param("uid");
   return ($uid,$time);
}

###################### ADMIN RELATED ######################

sub get_all_user_info{
    my @user_info = get_all_user_info_from_db ();
    return @user_info;
}



sub create_book_tag_string {
         my $length_of_randomstring=shift;
         my @chars=('A'..'Z','0'..'9');
         my $random_string;
         foreach (1..$length_of_randomstring){
		$random_string.=$chars[rand @chars];
	}
	return $random_string;
}



sub get_user_specific_info {
   my ( $id_x, $term ) = @_;
   my ( @ret ,@ings);
   
   if ( $id_x =~ /uname/){ 
      @ret = get_all_login_names_from_db ();
      @ings  = grep {/$term/} @ret;
   }elsif ( $id_x =~ /fname/){ 
      @ret = get_all_login_fnames_from_db ();
      @ings  = grep {/$term/} @ret;
   }elsif ( $id_x =~ /lname/){ 
     @ret = get_all_login_lnames_from_db ();
     @ings  = grep {/$term/} @ret;
   }elsif ( $id_x =~ /adress/){ 
     @ret = get_all_login_adress_from_db ();
     @ings  = grep {/$term/} @ret;
   }elsif ( $id_x =~ /dadress/){ 
     @ret = get_all_login_dadress_from_db ();
     @ings  = grep {/$term/} @ret;
   }elsif ( $id_x =~ /phone/){ 
     @ret = get_all_login_phones_from_db ();
     @ings  = grep {/$term/} @ret;
   }elsif ( $id_x =~ /email/){ 
     @ret = get_all_login_emails_from_db ();
     @ings  = grep {/$term/} @ret;
   }
   return @ings;     
}


sub local_my_get_style(){

my $style =<<"EOT";
 
.new_css {
    border: 1px solid #006;
    background: #ffc;
}
.new_css:hover {
    border: 1px solid #f00;
    background: #ff6;
}

.button {
    border: none;
    background: url('/forms/up.png') no-repeat top left;
    padding: 2px 8px;
}
.button:hover {
    border: none;
    background: url('/forms/down.png') no-repeat top left;
    padding: 2px 8px;
}
label {
    display: block;
    width: 150px;
    float: left;
    margin: 2px 4px 6px 4px;
    text-align: right;
}
br { clear: left; } 

   
EOT

return $style;

}



1
;