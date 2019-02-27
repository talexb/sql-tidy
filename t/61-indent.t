#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use SQL::Tidy;
use SQL::Tidy::Util;

{
    my $tidy = SQL::Tidy->new(watch_for_code => 1);

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

    is ( scalar @{ $result }, 6, 'Got six lines' );

    #  OK, now for the clever part -- replace the code in front of the SQL with
    #  spaces, and check for a gutter. Ignoring the stuff in 'after', this
    #  should be fine.

    substr ( $result->[0], 0, length ( $before ) ) = (' ') x length ( $before );
    gutter_check ( $result, $tidy->keyword_exceptions );

    done_testing;
}

__DATA__
    my $cmd = q{select DATA_TYPE, COMPLETE, count(*) as COUNT2, format(sum(INVAMTDUE),'N2') as AMTDUE
                  from OEORDH
                 where ORDDATE=?
              group by DATA_TYPE, COMPLETE
              order by DATA_TYPE, COMPLETE};
