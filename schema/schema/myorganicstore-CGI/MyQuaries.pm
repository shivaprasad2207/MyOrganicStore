package MyQuaries;
require(Exporter);
use warnings;
use strict;
our @ISA = qw(Exporter);
our @EXPORT    = qw (
                    $GET_CATEGORY
                    $GET_SUB_CATEGORY
                    $GET_PRODUCT
                    $GET_SUB_CATEGORY_PRODUCTS
                    $GET_PRODUCT_DETAIL
                    $IS_EMAIL_EXIST
                    $ADD_NEW_USER
                    $GET_USER_FULL_NAME
                    $GET_SUB_CATEGORY_NAME_BY_PRODUCT_ID
                    $GET_SESSION_ORDER
                    $REGISER_NEW_ORDER
                    $GET_USER_PROFILE
                    $ADD_NEW_DELIVERY_ADDRESS
                    $GET_NEW_DELIVERY_ADDRESS
                    $SET_CR
                    $UPDATE_USER_INFO
                    $ADD_NEW_CATEGORY
                    $MODIFY_CATEGORY_NAME
                    $INACTIVE_CATEGORY_NAME
                    $ADD_NEW_SUB_CATEGORY
                    $MODIFY_SUB_CATEGORY_NAME
                    $INACTIVE_SUB_CATEGORY_NAME
                    $ADD_NEW_PRODUCT
                    $ADD_IMAGE
                    $MODIFY_PRODUCT
                    $INACTIVE_PRODUCT
                    $GET_IMAGE_CATEGORY
                    $GET_USER_DETAILS
                    $DELETE_ADRESS
                    $MYRAND
                    $ADD_NEW_ORDER
                    $GET_ORDER_ID
                    $ADD_PRODUCT_ORDER
                    $ADD_ORDER_STATE
                    $GET_ALL_ORDER
                    $GET_ORDER_PRODUCTS
                    $GET_ORDER_META
                    $CANCEL_ORDER
                    
                    );
                  
our $GET_CATEGORY = "SELECT categoryName, categoryId FROM t_category WHERE Active=1;";
our $GET_SUB_CATEGORY = "SELECT subCategoryName,subCategoryId FROM t_subcategory WHERE Active=1 AND CategoryId=? ;";
our $GET_PRODUCT = "SELECT productName, productId, productImage, productPrice FROM t_product where subCategoryId=? AND Active=1;";
our $GET_SUB_CATEGORY_PRODUCTS = "SELECT productName, productId, productImage, productPrice, productUnit FROM t_product where subCategoryId=(
                                    SELECT subCategoryId  FROM t_subcategory WHERE subCategoryName=?) AND  Active=1
                                 ;";
our $GET_PRODUCT_DETAIL = "SELECT productName, productId, productImage, productPrice,productUnit FROM t_product where productId=? AND Active=1;";
our $IS_EMAIL_EXIST = "SELECT COUNT(*) FROM t_user WHERE email=?;";
our $ADD_NEW_USER = "INSERT INTO t_user ( firstname, lastname, email, usr_key, adress, phone, role, Active, Zip) VALUES(?,?,?,MD5(?),?,?,?,?,?) ;";
our $UPDATE_USER_INFO = "UPDATE t_user SET firstname=?, lastname=?, adress=?, phone=?, Zip=? WHERE email=?;";
our $GET_USER_FULL_NAME = "SELECT firstname, lastname FROM t_user WHERE email=?;";
our $GET_USER_DETAILS = "SELECT firstname, lastname , email, adress, phone, Zip FROM t_user WHERE email=?;";
our $GET_SUB_CATEGORY_NAME_BY_PRODUCT_ID = "SELECT subCategoryName FROM t_subcategory WHERE subCategoryId=(SELECT subCategoryId FROM t_product WHERE productId=?);";
our $GET_SESSION_ORDER = "SELECT orders FROM t_persession WHERE sid=?;";
our $REGISER_NEW_ORDER = "UPDATE t_persession SET orders=? WHERE sid=?;";
our $GET_USER_PROFILE = " SELECT firstname, lastname, email, adress, phone, Zip FROM t_user WHERE email=?;";
our $ADD_NEW_DELIVERY_ADDRESS = "INSERT INTO t_adress ( adress, userId , Active) VALUES ( ? , (SELECT usr_id FROM t_user WHERE email=?), 1 );";
our $GET_NEW_DELIVERY_ADDRESS ="SELECT adress,adressId FROM t_adress WHERE userId=(SELECT usr_id FROM t_user WHERE email=?) AND Active=1;";
our $SET_CR = "UPDATE t_user SET usr_key=? WHERE email=?;";
our $ADD_NEW_CATEGORY = "INSERT INTO t_category(categoryName,Active) VALUES (?,1);";
our $MODIFY_CATEGORY_NAME = "UPDATE t_category SET categoryName=? WHERE categoryId=?;";
our $INACTIVE_CATEGORY_NAME = "UPDATE t_category SET Active=0 WHERE categoryId=?;";
our $ADD_NEW_SUB_CATEGORY = "INSERT INTO t_subcategory ( subCategoryName, CategoryId, Active) VALUES ( ?,?, 1);";
our $MODIFY_SUB_CATEGORY_NAME = "UPDATE t_subcategory SET subCategoryName=? WHERE subCategoryId=?;";
our $INACTIVE_SUB_CATEGORY_NAME = " UPDATE t_subcategory SET  Active=0 WHERE subCategoryId=?;";
our $ADD_NEW_PRODUCT = "INSERT INTO t_product (subCategoryId,productName,productPrice,productUnit,Active ) VALUES (?,?,?,?,1 );";
our $ADD_IMAGE = "UPDATE t_product SET productImage=? WHERE productId=?;";
our $MODIFY_PRODUCT = "UPDATE t_product SET productName=? , productPrice=? , productUnit=? WHERE productId=?;";
our $INACTIVE_PRODUCT ="UPDATE t_product SET Active=0 WHERE productId=?;";
our $GET_IMAGE_CATEGORY= "select A.productImage, B.subCategoryName FROM t_product A, t_subcategory B WHERE A.subCategoryId=B.subCategoryId AND A.Active=1;";
our $DELETE_ADRESS = "UPDATE t_adress SET Active=0 WHERE adressId=?;"; 
our $MYRAND = "SELECT  MyRandom (8) 'MYRAND'  FROM DUAL;";
our $ADD_NEW_ORDER = "INSERT INTO t_orderindex (
                                                orderCode,  userId, orderDate,  email,  sid,    addressId,  orderCost,  Active
                                )VALUES ( ?,?,?,?,?,?,?,? );
                     ";
our $GET_ORDER_ID = "SELECT orderId FROM t_orderindex WHERE orderCode=?;";
our $ADD_PRODUCT_ORDER = "INSERT INTO t_orderregistry ( orderId, productId, productName, productUnitPrice, productUnit,productPrice, productQty) VALUES ( ?,?,?,?,?,?,? );";
our $ADD_ORDER_STATE = "INSERT INTO t_orderstate (orderId,orderStatus,changeDate) VALUES (?,?,?);";
our $GET_ALL_ORDER = "SELECT orderId , orderCode FROM t_orderindex WHERE email=? AND sid=? AND orderCost > 0.00 AND Active=1;";
our $GET_ORDER_PRODUCTS = " SELECT A.orderId, A.productId, A.productName , A.productUnitPrice , A.productUnit, A.productPrice, A.productQty , B.productImage
                                    FROM  t_orderregistry A, t_product B   WHERE A.orderId=? AND A.productId=B.productId;";
our $GET_ORDER_META ="SELECT A.adress, B.orderCost, B.orderDate,B.orderCode,C.orderStatus FROM  t_adress A, t_orderindex B, t_orderstate C 
                                                             WHERE A.adressId=B.addressId AND C.orderId=B.orderId AND B.orderId=?;";
our $CANCEL_ORDER =" UPDATE t_orderindex SET Active=0 WHERE orderCode=?;"; 
1


;