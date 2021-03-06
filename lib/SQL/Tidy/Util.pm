package SQL::Tidy::Util;

use parent qw/Exporter/;

require Exporter;
our @ISA = ('Exporter');

our @EXPORT = qw/gutter_check/;

use SQL::Tidy::Constants;

use Test::More;

#  2019-0217: This module will check that the gutter in the output is correct,
#  as that's one of the design goals for this module.

my %keywords = map { $_ => undef } @Keywords;

sub gutter_check
{
    my ( $array, $keyword_exceptions ) = @_;

    # uncoverable branch true
    defined $array or BAILOUT ( 'Arrayref not supplied to GutterCheck' );

    #  First, get the location of the gutter from the first line, keeping in
    #  mind that there will be an indent, followed by one or more keywords.

    my ( $indent, $remainder );
    ( $indent, $remainder ) = ( $array->[0] =~ /^(\s+)(.+)$/ );

    my @reserved;
    foreach my $word ( split( /\s/, $remainder ) ) {

      if (  exists( $keywords{ lc $word } )
        && !exists $keyword_exceptions->{ lc $word } )
      {

        push( @reserved, $word );

      } else {

        last;
      }
    }

    my $gutter_position = length ( $indent ) + length ( join ( ' ', @reserved ) );

    foreach my $line ( @$array ) {

      is ( substr ( $line, $gutter_position, 1 ), ' ', 'Gutter check' );

      #  Now, double check that if there were words on the left, that they were
      #  only reserved words.

      my $left = substr ( $line, 0, $gutter_position );
      if ( $left =~ /\w/ ) {

        foreach my $word ( grep { /\w/ } split (/ +/, $left ) ) {

          ok ( exists $keywords{ lc $word }, "$word is a keyword" );
        }
      }
    }
    return ( $gutter_position );
}

1;
