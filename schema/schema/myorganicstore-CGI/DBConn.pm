package DBConn;
require(Exporter);
use warnings;
use strict;
use Data::Dumper;
use DBI;
use DBD::mysql;
our @ISA = qw(Exporter);

our @EXPORT    = qw (
                      $db_exec
                   );
                   
my $user = 'root';
my $pw = 'root';
my $database = 'myorganicstore';
my $dsn = "DBI:mysql:" . $database. ":localhost:3306";


                   
our $db_exec = DBI->connect("$dsn", $user, $pw,
                        {PrintError => 1, RaiseError => 1});

1
;