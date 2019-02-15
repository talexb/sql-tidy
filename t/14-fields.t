#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use SQL::Tidy;

{
    #  Test line-folding by making the width shorter and the number of fields
    #  longer.

    # foreach my $max_width ( 30 ) {
    foreach my $max_width ( 30, 31, 32, 33, 34 ) {

      my $tidy = SQL::Tidy->new( width => $max_width );

      #  Create a list of field names that are going to overflow the small margin
      #  that I've specified.

      my @field_names =
        qw/abc def ghi jkl mno pqr stu vwx yza bcd efg hij klm xyz/;
      my $sql = join( ' ', 'select', join( ',', @field_names ),
        'from bar where baz>0' );

      # diag ( "sql is $sql" );

      #  Make a list of all the fields ..

      my %fields = map { $_ => undef } @field_names;

      my $result = $tidy->tidy($sql);
      foreach my $line (@$result) {

        # diag ( "check line $line" );
        like( $line, qr/^\s{4}/, 'Indent is 4' );
        ok( length $line <= $max_width,
          "Length not larger than $max_width" );

        foreach my $field ( $line =~ /(\w+)/g ) {

          #  Note each field that was seen ..

          if ( exists $fields{$field} ) {

            ok( 1, "Saw $field" );
            $fields{$field} = 1;
          }
        }
      }

      #  And check that no fields was missed.

      foreach my $field ( keys %fields ) {

        is( $fields{$field}, 1, "$field was seen" );
      }

      #  Will need to do a gutter check eventually. Code to come.
    }

    done_testing;
}
