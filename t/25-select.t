#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use SQL::Tidy;
use SQL::Tidy::Util;

{
    my $tidy = SQL::Tidy->new;
    my $query = q{
	SELECT p1.ProductModelID
FROM Production.Product AS p1
GROUP BY p1.ProductModelID
HAVING MAX(p1.ListPrice) >= ALL
    (SELECT AVG(p2.ListPrice)
     FROM Production.Product AS p2
     WHERE p1.ProductModelID = p2.ProductModelID)
	};

	#  This tests queries from the SQL Server 2017 page.

    my $result = $tidy->tidy($query);
    is ( scalar @$result, 6, 'Got six lines' );

    gutter_check ( $result );

    done_testing;
}
