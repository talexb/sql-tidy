#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use SQL::Tidy;
use SQL::Tidy::Util;

{
    my $tidy = SQL::Tidy->new;
    my $sql = 'select rtrim(CODESLSP1) as CODESLSP1
             from ARCUS
             where IDCUST=?';

    #  This tests whether we can format SQL with placeholders. Answer:
    #  placeholders are OK, but 'as' is treated correctly as a keyword, and
    #  starts a new line. So I'd like to add an exception to that processing.

    my $result = $tidy->tidy($sql);
    is ( scalar @$result, 3, 'Got three lines' );

    gutter_check ( $result, $tidy->keyword_exceptions );

    done_testing;
}
