#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use SQL::Tidy;
use SQL::Tidy::Util;

{
    my $tidy = SQL::Tidy->new;
    my $query = q{ select cast(OEORDHO.VVALUE AS int) as WEBORDERNUM,
                      OEORDH.COMPLETE, OEORDH.ORDDATE, OEORDH.ORDUNIQ
                 from OEORDHO
                 join OEORDH on OEORDH.ORDUNIQ=OEORDHO.ORDUNIQ
                where OEORDHO.OPTFIELD='WEBORDERNUM' and OEORDH.ORDUNIQ in
                        (select OEORDHO.ORDUNIQ
                           from OEORDHO
                           join OEORDH on OEORDH.ORDUNIQ=OEORDHO.ORDUNIQ
                          where OEORDHO.OPTFIELD='WEBSITE' and
                                OEORDHO.VVALUE=? and
                                OEORDH.TYPE = 1) };

	#  This tests whether we can format SQL with a sub-select. The answer is
	#  yes, but not as ideally as I'd like (see above for the ideal). This
	#  will do for now.

    my $result = $tidy->tidy($query);
    is ( scalar @$result, 12, 'Got twelve lines' );

    gutter_check ( $result, $tidy->keyword_exceptions );

    done_testing;
}
