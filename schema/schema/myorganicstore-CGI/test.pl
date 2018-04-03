#!perl
BEGIN {
   binmode(STDIN);                       # Form data
   binmode(STDOUT, ':encoding(UTF-8)');  # HTML
   binmode(STDERR, ':encoding(UTF-8)');  # Error messages
}

use strict;
use warnings;
use Data::Dumper;

my %h = (
          'Grocery/Grains and Lintels' => {
                                            'pulses' => {
                                                          'Green Gram' => {
                                                                            'price' => '20.20',
                                                                            'image' => 'green_gram.jpg'
                                                                          },
                                                          'Toor Dal' => {
                                                                          'price' => '20.20',
                                                                          'image' => 'toor_dhal.jpg'
                                                                        },
                                                          'Urad Dal' => {
                                                                          'price' => '20.20',
                                                                          'image' => 'urad_dhal.jpg'
                                                                        }
                                                        },
                                            'Millets' => undef,
                                            'Grains' => {
                                                          'Wheat' => {
                                                                       'price' => '20.20',
                                                                       'image' => 'wheat.jpg'
                                                                     },
                                                          'Rice' => {
                                                                      'price' => '20.20',
                                                                      'image' => 'rice.jpg'
                                                                    },
                                                          'Raagi' => {
                                                                       'price' => '20.20',
                                                                       'image' => 'raagi.jpg'
                                                                     }
                                                        }
                                          },
          'Milk Products' => {
                               'Paneer' => undef,
                               'Ghee' => undef,
                               'Butter' => undef
                             },
          'Vegetables' => {
                            'Leafy Veggies' => {
                                                 'Methi' => {
                                                              'price' => '20.20',
                                                              'image' => 'methi.jpg'
                                                            },
                                                 'Spinich' => {
                                                                'price' => '40.40',
                                                                'image' => 'spinich.jpg'
                                                              },
                                                 'Palakh' => {
                                                               'price' => '40.40',
                                                               'image' => 'palak.jpg'
                                                             }
                                               },
                            'Non-Leafy Veggies' => {
                                                     'Tomato' => {
                                                                   'price' => '40.40',
                                                                   'image' => 'tomato.jpg'
                                                                 },
                                                     'Ladies Fingre' => {
                                                                          'price' => '40.40',
                                                                          'image' => 'lady_finger.jpg'
                                                                        },
                                                     'potato' => {
                                                                   'price' => '40.40',
                                                                   'image' => 'potato.jpg'
                                                                 },
                                                     'Carrot' => {
                                                                   'price' => '40.40',
                                                                   'image' => 'carrot.jpg'
                                                                 },
                                                     'Brinjal' => {
                                                                    'price' => '40.40',
                                                                    'image' => 'brinjal.jpg'
                                                                  },
                                                     'raddish' => {
                                                                    'price' => '40.40',
                                                                    'image' => 'raddish.jpg'
                                                                  }
                                                   }
                          },
          'Sweeteners ' => {
                             'Honey' => undef,
                             'Jaggery' => undef,
                             'Sugar' => undef
                           }
        );

&rec ( %h);

sub rec {
   my (%h) = @_;
   
   foreach my $k (keys (%h)){
      my $r;
      if (!defined ($h{$k})){
           print '<li><a href=# >' .  $k . '</a></li>'  , "\n" ;   
           next ;
      }
      if (ref ($h{$k}) eq "HASH"){  
         my $t = '<ul class="dropdown-menu"><li><a href="#">CONTENT<span class="caret"></span></a>';   
         $t =~ s/CONTENT/$k/g;
         print $t , "\n";
         rec ( %{$h{$k}} );
         print '</li></ul>' , "\n" ;
      }else{
         print '<li><a href=# >' .  $k . '</a></li>'  , "\n" ;   
         return ;
      }
      
   }
   
   
}