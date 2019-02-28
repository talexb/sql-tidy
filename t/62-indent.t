#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use SQL::Tidy;
use SQL::Tidy::Util;

{
    my $tidy = SQL::Tidy->new(
      watch_for_code     => 1,
      keyword_exceptions => [qw/day cast as char desc on/]
    );

    my @lines;
    foreach my $line (<DATA>) {

      $line =~ s/\s+$//;
      push ( @lines, $line );
    }
    my $query = join ( ' ', @lines );

    my $result = $tidy->tidy($query);

    my @parts = split(/([{}])/, $query);
    my $before = join('', @parts[0..1]);
    my $after = join('', @parts[3..4]);

    is ( substr ( $result->[0], 0, length ( $before ) ), $before,
      'First part matches' );
    like ( $result->[-1], qr/$after/, 'Last part matches' );

    is ( scalar @{ $result }, 9, 'Got nine lines' );

    substr ( $result->[0], 0, length ( $before ) ) = (' ') x length ( $before );
    gutter_check ( $result, $tidy->keyword_exceptions );

    done_testing;
}

__DATA__
    $cmd = q{select top 10
               DATEDIFF(DAY, CAST(ORDDATE AS char(8)),
                             CAST(EXPDATE AS char(8))) as DELTA,
               rtrim(OEORDHO.VALUE) as FDTICKETNO, ORDNUMBER, EXPDATE, ORDDATE
              from OEORDH
         left join OEORDHO on OEORDH.ORDUNIQ=OEORDHO.ORDUNIQ
             where COMPDATE = ? and COMPLETE >= 3 and OPTFIELD='FDTICKETNO'
          order by EXPDATE-ORDDATE desc};
