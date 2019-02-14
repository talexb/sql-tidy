#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'SQL::Tidy' ) || print "Bail out!\n";
}

diag( "Testing SQL::Tidy $SQL::Tidy::VERSION, Perl $], $^X" );
