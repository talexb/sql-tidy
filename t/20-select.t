#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use SQL::Tidy;

{
    my $tidy = SQL::Tidy->new;
	my $sql = 'select foo from bar where baz>0';

	#  This tests the functionality that we get two lines in the format
	#
	#    select foo
	#      from bar
	#     where baz > 0
	#
	#  from the module.

	my $result = $tidy->tidy($sql);
	is ( scalar @$result, 3, 'Got three lines' );

	my $last_len_left = 0;
	foreach my $line ( @$result ) {

	  my ( $left, $right ) = ( $line =~ /(\s+\S+)\s/ );
	  if ( $last_len_left == 0 ) { $last_len_left = length ( $left ); next; }

	  is ( length ( $left ), $last_len_left, 'Gutter check' );
	}

	done_testing;
}
