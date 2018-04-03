package MyVars;
require(Exporter);
use warnings;
use strict;
our @ISA = qw(Exporter);

our @EXPORT    = qw (
                      
                      $footer
                      $IMAGE_DIR
                      $META_TAGS
                      $NEW_PASSWD
                      $APP_CGI_BIN
                      
                   );
our $IMAGE_DIR = "/static/images/myorganicstore/products/p/";

our $footer = qq {
     </div>
        <div class="jumbotron" style="background:#00d200; height:30px;padding:5px;text-align:center">
	   <span ><a href="http://www.shivaprasad.co.in" target="_blank"><font style="color:white";> &copy;Author </font></a></span>
	</div>    
  </body>
    
};

 our $META_TAGS  = qq {   
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    };
 our $NEW_PASSWD = "myorganicstore";
 our $APP_CGI_BIN = "/cgi-bin/myorganicstore/";

1
;