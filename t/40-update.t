#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use SQL::Tidy;
use SQL::Tidy::Util;

{
    my $tidy = SQL::Tidy->new;
    my $sql = 'UPDATE OEORDHO SET VVALUE = ?
                WHERE ORDUNIQ = ? and OPTFIELD = ?';

    my $result = $tidy->tidy($sql);
    is ( scalar @$result, 3, 'Got three lines' );

    gutter_check ( $result, $tidy->keyword_exceptions );

    done_testing;
}
