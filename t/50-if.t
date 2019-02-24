#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use SQL::Tidy;
use SQL::Tidy::Util;

{
    my $tidy = SQL::Tidy->new(sub_select_indent => 1);
    my $query = q{IF EXISTS (SELECT * FROM table_name WHERE id = ?)
            BEGIN
            select 1
            END
            ELSE
            BEGIN
            select 2
            END};

    #  Test to see why this is tidied up as
    #    
    #                    EXISTS IF (',
    #                           SELECT *',
    #                             FROM table_name',
    #                            WHERE id = ? )',
    #              BEGIN select 2',
    #     END ELSE BEGIN select 3',
    #                       END'
    #
    #  The puzzling part is why the order of the first two words is reversed.

    #  OK, after adding a grup of 'possible keywords in the fuuture', this is
    #  now being tidied as
    #
    #               IF EXISTS ('
    #                            SELECT *'
    #                              FROM table_name'
    #                             WHERE id = ? )'
    #            BEGIN select 1'
    #   END ELSE BEGIN select 2'
    #                     END'
    #
    #  The IF was not a keyword, putting that into the right group. Interesting
    #  behaviour, but logical.
    #
    #  The output is still not what I'd prefer, which is something like
    #
    #               IF EXISTS ('
    #                            SELECT *'
    #                              FROM table_name'
    #                             WHERE id = ? )'
    #                   BEGIN
    #                     select 1
    #                   END
    #               ELSE
    #                   BEGIN
    #                     select 2
    #                   END'
    #
    #  Like the issue in formatting a CREATE TABLE statement, this requires a
    #  different approach than making a gutter.


    my $result = $tidy->tidy($query);
    is ( scalar @$result, 7, 'Got seven lines' );

    done_testing;
}
