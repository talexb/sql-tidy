#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use SQL::Tidy;
use SQL::Tidy::Util;

{
    my $tidy = SQL::Tidy->new(format => 'guttered');
    my $query = q{ Select foo, bar, baz, one, two, three, four, five, six,
      seven, eight, nine, ten from something where foo > 2 and bar < 3 order
      by baz desc};

    #  This tests whether a sub-select gets formatted correctly.

    my $result = $tidy->tidy($query);
    is ( scalar @$result, 6, 'Got seven lines' );

    my $gutter_position = gutter_check ( $result, $tidy->keyword_exceptions );

    done_testing;
}
