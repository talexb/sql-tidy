package SQL::Tidy::Util;

use parent qw/Exporter/;

require Exporter;
our @ISA = ('Exporter');

our @EXPORT = qw/gutter_check/;

use Test::More;

#  2019-0217: This module will check that the gutter in the output is correct,
#  as that's one of the design goals for this module. Yes, this list of
#  keywords has been copied from SQL::Tidy.

use constant KEYWORDS => qw/
    and
    as
    between
    by
    case
    create
    delete
    desc
    else
    end
    for
    from
    group
    into
    insert
    join
    left
    on
    only
    or
    order
    read
    select
    then
    union
    update
    values
    view
    when
    where/;

my %keywords = map { $_ => undef } KEYWORDS;

sub gutter_check
{
    my $array = shift;
	defined $array or BAILOUT ( 'Arrayref not supplied to GutterCheck' );

	#  First, get the location of the gutter from the first line, keeping in
	#  mind that there will be an indent, followed by one or more keywords.

	my ( $indent, $remainder );
	( $indent, $remainder ) = ( $array->[0] =~ /^(\s+)(.+)$/ );

	my @reserved;
    foreach my $word ( split ( /\s/, $remainder ) ) {

      if ( exists( $keywords{ lc $word } ) ) { push( @reserved, $word ); }
      else                                   { last; }
    }

	my $gutter_position = length ( $indent ) + length ( join ( ' ', @reserved ) );

	foreach my $line ( @$array ) {

	  is ( substr ( $line, $gutter_position, 1 ), ' ', 'Gutter check' );

	  #  Now, double check that if there were words on the left, that they were
	  #  only reserved words.

	  my $left = substr ( $line, 0, $gutter_position );
	  if ( $left =~ /\w/ ) {

	    foreach my $word ( grep { /\w/ } split (/ +/, $left ) ) {

		  ok ( exists $keywords{ $word }, "$word is a keyword" );
		}
	  }
	}

}

1;
