#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use SQL::Tidy;
use SQL::Tidy::Util;

{
    my $tidy = SQL::Tidy->new;
    my $sql = 'UPDATE players SET count = 0 WHERE build = $1 AND (hero = $2 OR region = $3) LIMIT 1';

    my $result = $tidy->tidy($sql);
    is ( scalar @$result, 5, 'Got five lines' );

    gutter_check ( $result, $tidy->keyword_exceptions );

    done_testing;
}
