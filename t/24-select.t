#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use SQL::Tidy;
use SQL::Tidy::Util;

{
    my $tidy = SQL::Tidy->new;
    my $query = q{
    select c.name as Companyname,
    Sales = ( o.qty * o.unit_price ),
    Discounts = ( o.qty * o.unit_price * o.discount )
    from Company as c
    join Product as p on p.company_id = c.company_id
    join Order as o one o.product_id = p.product_id
    order by p.product_name
    };

    my $result = $tidy->tidy($query);
    is ( scalar @$result, 6, 'Got six lines' );

    gutter_check ( $result, $tidy->keyword_exceptions );

    done_testing;
}
