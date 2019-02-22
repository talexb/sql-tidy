package SQL::Tidy;

use 5.006;
use strict;
use warnings;

our $VERSION = '0.01';

use SQL::Tidy::Constants;

use SQL::Tokenizer;

use constant KEYWORD_EXCEPTIONS =>
  qw/as on set desc asc cast int in like all date time/;

#  2019-0218: Feature idea: add keyword and nonkeyword casing (upper, lower,
#  and unchanged) as optional arguments to the object creation.

sub new
{
    my $class = shift;
    my %args = (

      # Some defaults
      indent             => '    ',
      width              => 78,
      keywords           => [ @Keywords ],
      keyword_exceptions => [KEYWORD_EXCEPTIONS],
      @_
    );

    my $self = {};
    my $keywords = delete( $args{'keywords'} );
    my $keyword_exceptions = delete( $args{'keyword_exceptions'} );
	my %keyword_exceptions = map { $_ => undef } @$keyword_exceptions;

	#  2019-0218: The keyword maps to a value that tells us whether or not to
	#  start a new output line.

    foreach my $word (@$keywords) {

      $self->{'keywords'}{$word} = exists $keyword_exceptions{$word} ? 0 : 1;
    }
    foreach my $arg ( keys %args ) {

      $self->{ $arg } = $args{ $arg };
    }

    bless $self, $class;
    return $self
}

sub tidy
{
    my ( $self, $sql ) = @_;
    my $result = '';

    defined $sql or return [ $result ];
    $sql =~ /\w/ or return [ $result ];

    my @tokens = grep !/^\s+$/, SQL::Tokenizer->tokenize($sql);

    #  2019-0215: The concept behind this design is that we'll have keywords to
	#  the left of the gutter and everything else to the right of the gutter.
	#  I'm expecting there to be just a single left side keyword, but INSERT
	#  INTO is an exception to that rule. Some keywords will cause a new output
	#  line to be created (details and design to come.)

	#  2019-0218: Instead of doing a push, which added to whatever was here
	#  from previous calls, doing a set, so as to intentionally clear out
	#  anything from previous calls.

    $self->{'output'} = [ { left => [], right => [] } ];

    my $left_max = 0;
    foreach my $t ( @tokens ) {

	  #  2019-0218: This is a bit of a logical mess. I want to know that 'as'
	  #  is a keyword, but I don't want it to start a new line. The SQL
	  #
	  #    select rtrim(foo) as foo ..
	  #
	  #  should not be tidied to be
	  #
	  #    select rtrim(foo)
	  #        as foo ..

      if ( exists $self->{'keywords'}{lc($t)} && $self->{'keywords'}{lc($t)} ) {

        #  2019-0215: If we've already got something in the left column and the
        #  right column and there's a new keyword, then it's time to start a
        #  new line.

        if ( @{ $self->{'output'}->[-1]->{'left'} }  &&
             @{ $self->{'output'}->[-1]->{'right'} } ) {

          push ( @{$self->{'output'}}, { left => [], right => [] } );
        }
        push( @{ $self->{'output'}->[-1]->{'left'} }, $t );
        my $this_max =
          length ( join ( ' ', @{ $self->{'output'}->[-1]->{'left'} } ) );
        if ( $this_max > $left_max ) { $left_max = $this_max; }
      }
      else {

        #  2019-0215: If the token's a comma, just add it on to the existing
        #  line.

        if ( $t eq ',' ) {

          $self->{'output'}->[-1]->{'right'}->[-1] .= $t;

        } else {

          push( @{ $self->{'output'}->[-1]->{'right'} }, $t );
        }
      }
    }

    #  2019-0215: This is where we take all of the elements we've read in and
    #  build the output lines, leaving a gutter down the middle to separate the
    #  keywords (left) from everything else (right).

    my ( @output, $output );

    #  2019-0221: In order to indent sub-selects, we're going to track when we
    #  saw an opening bracket on the previous line, and also track the value of
    #  left_max (the largest keywords on the left side so far).

    my $bracket_in_previous_line = 0;
    my $local_left_max = 0;

    foreach my $line ( @{$self->{'output'}} ) {

      #  Build everything to the left of the gutter. That's the indent, the
      #  correct number of spaces, then all of the words on the left side.

      my $left = join ( ' ', @{ $line->{'left'} } );
      if ( $local_left_max < length $left ) { $local_left_max = length $left; }

      #  Normally the padding amount is the left_max less the length of the
      #  string on the left; but if we're inside a bracket, that amount is
      #  increased by the size of the string in the left side, plus one for the
      #  gutter.

      my $padding_amount =
        $bracket_in_previous_line
          ?   $left_max - length($left) + 1 + $local_left_max
          : ( $left_max - length($left) );

      $output = join( '', $self->{'indent'}, (' ') x $padding_amount, $left );
        
      #  Build everything to the right of the gutter. If it overflows, push
      #  what we have onto the stack and start a new line with the maximum
      #  indent. Whether or not it overflows, add the current word to the
      #  output.

      foreach my $r ( @{ $line->{'right'} } ) {

        if ( length ( $output ) + length ( $r ) + 1 > $self->{'width'}  ) {

          push ( @output, $output );
          $output = join( '', $self->{'indent'}, ( ' ' x $left_max ) );
        }
        $output .= " $r";
      }

      #  Push the last output string onto the stack, and clear the output.

      push ( @output, $output );

      #  2019-0221: Here's where we turn on and off whether we've seen a
      #  bracket in the previous line. 

      if ( $bracket_in_previous_line ) {

        if ( $output =~ /\)$/ ) { $bracket_in_previous_line = 0; }

      } else {

        $bracket_in_previous_line = ( $output =~ /\($/ );
      }

      $output = '';
    }

    #  We've finished going through the output; if there's anything left that's
    #  non-blank, add it to the stack, then return the stack.

    if ( $output =~ /\w/ ) { push ( @output, $output ); }

    return ( \@output );
}

sub keyword_exceptions
{
    my $self = shift;
    my %exceptions =
      map { $_ => undef }
      grep { !$self->{'keywords'}->{$_} }
      keys %{ $self->{'keywords'} };

	return ( \%exceptions );
}

1; # End of SQL::Tidy
