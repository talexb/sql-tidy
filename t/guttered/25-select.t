#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use SQL::Tidy;
use SQL::Tidy::Util;

{
    my $tidy = SQL::Tidy->new(sub_select_indent => 1, format => 'guttered');
    my $query = q{ select rtrim(CODESLSP1) as CODESLSP1 from ARCUS where IDCUST
    in (select IDCUST from ARCUS where ANNUAL_SALES > 100000) order by
    LAST_NAME };

    #  This tests whether a sub-select gets formatted correctly.

    my $result = $tidy->tidy($query);
    is ( scalar @$result, 7, 'Got seven lines' );

    my $gutter_position = gutter_check ( $result, $tidy->keyword_exceptions );

    #  Check to see that the sub-select is properly indented. It's on lines
    #  4-6.

    my $expected_indent = (' ') x ( $gutter_position + 1 );
    for my $line ( 3 .. 5 ) {

      is( substr( $result->[$line], 0, $gutter_position + 1 ),
        $expected_indent, 'Sub-select indented as expected' );
    }

    done_testing;
}
