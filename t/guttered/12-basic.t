#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use SQL::Tidy;

{
    my $tidy = SQL::Tidy->new(format => 'guttered');

    my $result = $tidy->tidy;

    #  This is a slightly more complex example.

    my $sql = 'select foo, bar';
    $result = $tidy->tidy( $sql );
    is ( scalar @$result, 1, 'Array is the right size' );
    like ( $result->[0], qr/^\s{4}/, 'Indent is 4' );
    like ( $result->[0], qr/$sql/,   'SQL is there' );

    done_testing;
}
