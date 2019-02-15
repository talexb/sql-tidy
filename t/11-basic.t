#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use SQL::Tidy;

{
    my $tidy = SQL::Tidy->new;

	my $result = $tidy->tidy;
	is_deeply ( $result, [ '' ], 'Null string returned for no input' );

	$result = $tidy->tidy('');
	is_deeply ( $result, [ '' ], 'Null string returned for empty input' );

	#  This is a trivial example to get things going.

	my $sql = 'select 1';
	$result = $tidy->tidy( $sql );
	is ( scalar @$result, 1, 'Array is the right size' );
	like ( $result->[0], qr/^\s{4}/, 'Indent is 4' );
	like ( $result->[0], qr/$sql/,   'SQL is there' );

	done_testing;
}
