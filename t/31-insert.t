#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use SQL::Tidy;
use SQL::Tidy::Util;

{
    my $tidy = SQL::Tidy->new;
    my $query =
      'INSERT INTO OEORDHO 
      VALUES ( ?, ?, 
      replace ( cast ( GETUTCDATE() as date ), \'-\', \'\' ), 
      substring ( replace ( replace ( cast ( GETUTCDATE() as time ),
      \':\', \'\' ), \'.\', \'\' ), 1, 8 ), 
      ?, ?, ?, ?, ?, ?, ?, ?, ? )';

	my $result = $tidy->tidy($query);
	is ( scalar @$result, 4, 'Got four lines' );

	gutter_check ( $result );

	done_testing;
}
