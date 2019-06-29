#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use SQL::Tidy;
use SQL::Tidy::Util;

{
    my $tidy = SQL::Tidy->new;
    my $query = q{select cast(ORDNUMBER as int) as ORDNUMBER, ORDUNIQ,
                         SALESPER1, SALESPER2, PONUMBER, CUSTOMER, SHIPVIA,

                         BILNAME, BILADDR1, BILADDR2, rtrim(BILCITY) as
                         BILCITY, BILSTATE, BILZIP, BILCOUNTRY, BILPHONE,
                         rtrim(BILCONTACT) as BILCONTACT,

                         SHPNAME, SHPADDR1, SHPADDR2, rtrim(SHPCITY) as
                         SHPCITY, SHPSTATE, SHPZIP, SHPCOUNTRY, SHPPHONE,
                         rtrim(SHPCONTACT) as SHPCONTACT,

                         COMPLETE

                    from OEORDH
                   where ORDNUMBER like '[0-9][0-9][0-9][0-9][0-9][0-9]' and
                         cast(ORDNUMBER as int) > ? and TYPE = 1 and
                         AUDTDATE > '20180301' and
                         cast(ORDNUMBER as int)
                order by ORDNUMBER asc};

    #  This tests another complex query.

    my $result = $tidy->tidy($query);
    is ( scalar @$result, 14, 'Got fourteen lines' );

    gutter_check ( $result, $tidy->keyword_exceptions );

    done_testing;
}
