#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use SQL::Tidy;
use SQL::Tidy::Util;

{
    my $tidy = SQL::Tidy->new(format => 'guttered');

    foreach my $modifier ( '', 'TOP 5', 'DISTINCT' ) {

      foreach my $group_by ( 0 .. 1 ) {

        foreach my $having ( 0 .. 1 ) {

          foreach my $order_by ( 0 .. 1 ) {

            my @clauses;
            if ($group_by) { push( @clauses, 'group by COMPANY' ); }
            if ($having)   { push( @clauses, 'having SALES > 100000' ); }
            if ($order_by) { push( @clauses, 'order by AGE' ); }

            my $query = join( ' ',
              "select $modifier ORDNUMBER, ORDUNIQ, SALESPER1, SALESPER2, ",
              'PONUMBER, CUSTOMER, SHIPVIA',
              'from OEORDH', @clauses );

            my $result = $tidy->tidy($query);
            is( scalar @$result, 3 + scalar(@clauses), 'Correct line count' );

            gutter_check( $result, $tidy->keyword_exceptions );
          }
        }
      }
    }

    done_testing;
}
