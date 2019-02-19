#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use SQL::Tidy;
use SQL::Tidy::Util;

{
    my $tidy = SQL::Tidy->new;
    my $query = q{
	SELECT p.Name AS ProductName,
NonDiscountSales = (OrderQty * UnitPrice),
Discounts = ((OrderQty * UnitPrice) * UnitPriceDiscount)
FROM Production.Product AS p
INNER JOIN Sales.SalesOrderDetail AS sod
ON p.ProductID = sod.ProductID
ORDER BY ProductName DESC
	};

	#  This tests queries from the SQL Server 2017 page.

    my $result = $tidy->tidy($query);
    is ( scalar @$result, 6, 'Got six lines' );

    gutter_check ( $result, $tidy->keyword_exceptions );

    done_testing;
}
