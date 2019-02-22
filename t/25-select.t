#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use SQL::Tidy;
use SQL::Tidy::Util;

{
    my $tidy = SQL::Tidy->new;
    my $query = q{ select rtrim(CODESLSP1) as CODESLSP1 from ARCUS where IDCUST
    in (select IDCUST from ARCUS where ANNUAL_SALES > 100000) order by
    LAST_NAME };

	#  This tests whether a sub-select gets formatted correctly.

    my $result = $tidy->tidy($query);
    is ( scalar @$result, 7, 'Got seven lines' );

    gutter_check ( $result, $tidy->keyword_exceptions );

    done_testing;
}
