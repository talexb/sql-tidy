#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use SQL::Tidy;
use SQL::Tidy::Util;

#  2019-0225: This test is for queries that are already embedded in code (and
#  that's actually the target for this module). The re-formatted query should
#  be positioned the same way as the original.

#  Original:
#    my $shipment_query =
#      'select min(COMPLETE) as COMPLETE from OESHIH where ORDUNIQ=?'; 
#
#  Tidied:
#    my $shipment_query =
#      'select min(COMPLETE) as COMPLETE
#         from OESHIH
#        where ORDUNIQ=?';
#
#  This will require grabbing everything up to the start of the query, and
#  everything at the end of the query -- hopefully we can match up the end with
#  the beginning.

{
    my $tidy = SQL::Tidy->new(watch_for_code => 1);
    my $query =
      q{    my $q = 'select min(COMPLETE) as COMPLETE from OESHIH where ORDUNIQ=?';};

    my $result = $tidy->tidy($query);

    my @parts = split(/(')/, $query);
    my $before = join('', @parts[0..1]);
    my $after = join('', @parts[3..4]);

    is ( substr ( $result->[0], 0, length ( $before ) ), $before,
      'First part matches' );
    like ( $result->[-1], qr/$after/, 'Last part matches' );

    is ( scalar @{ $result }, 3, 'Got three lines' );

    done_testing;
}
