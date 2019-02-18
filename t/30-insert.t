#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use SQL::Tidy;
use SQL::Tidy::Util;

{
	#  A fairly trivial test of an insert statement. Since both insert and into
	#  are reserved words, the get added to they left column. The result should
	#  look like this:
	#
    #    insert into TABLE ( foo, bar, baz )',
    #         VALUES ( 4, "jolly", "20180422" )'

    my $tidy = SQL::Tidy->new;
	my $sql = 'insert into TABLE (foo, bar, baz) VALUES (4, "jolly", "20180422")';

	my $result = $tidy->tidy($sql);
	is ( scalar @$result, 2, 'Got two lines' );

	gutter_check ( $result );

	done_testing;
}
