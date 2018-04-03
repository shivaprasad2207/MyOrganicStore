package Header;
require(Exporter);
use warnings;
use strict;
our @ISA = qw(Exporter);
our @EXPORT    = qw (
                     
                      $Header
                    
                    );

our $Header = {
                        -title => 'myorganicstore.in|A healthy Organic food shopping online',
                        -style=>[ 
                                    { -type =>'text/css', -src=>'/static/styles/myorganicstore/bootstrap.css'},
                                    { -type =>'text/css', -src=>'/static/styles/myorganicstore/jquery.smartmenus.bootstrap.css'},
                                    { -type =>'text/css', -src=>'/static/styles/myorganicstore/thumbnail-gallery.css'},
                                    { -type =>'text/css', -src=>'/static/styles/myorganicstore/font-awesome.min.css'},
                                    { -type =>'text/css', -src=>'/static/styles/myorganicstore/jquery.bxslider.css'},
                                     { -type =>'text/css', -src=>'/static/styles/myorganicstore/bootstrap-checkbox.css'},
                                  
                                      
                                ],  
                         -script=>[
                                        { -type => 'text/javascript', -src => '/static/js/myorganicstore/jquery.js'},
                                        { -type => 'text/javascript', -src => '/static/js/myorganicstore/jquery.bxslider.min.js'}, 
                                        { -type => 'text/javascript', -src => '/static/js/myorganicstore/md5.min.js'}, 
                                        { -type => 'text/javascript', -src => '/static/js/myorganicstore/bootstrap.js'},  
                                          { -type => 'text/javascript', -src => '/static/js/myorganicstore/bootbox.min.js'},
                                            { -type => 'text/javascript', -src => '/static/js/myorganicstore/validator.js'},
                                            { -type => 'text/javascript', -src => '/static/js/myorganicstore/bootstrap-checkbox.js'},  
                                        { -type => 'text/javascript', -src => '/static/js/myorganicstore/jquery.smartmenus.bootstrap.min.js'},                                       
                                        { -type => 'text/javascript', -src => '/static/js/myorganicstore/jquery.smartmenus.bootstrap.js'},                                        
                                        { -type => 'text/javascript', -src => '/static/js/myorganicstore/jquery.smartmenus.js'},
                                         { -type => 'text/javascript', -src => '/static/js/myorganicstore/myorganicstore.js'},  
                                        
                                ],
                      
                    };

            

1

;