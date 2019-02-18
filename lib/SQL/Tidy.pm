package SQL::Tidy;

use 5.006;
use strict;
use warnings;

our $VERSION = '0.01';

use SQL::Tokenizer;

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

#  2019-0218: Feature idea: add keyword and nonkeyword casing (upper, lower,
#  and unchanged) as optional arguments to the object creation.

sub new
{
    my $class = shift;
    my %args  = (

      # Some defaults
      indent   => '    ',
      width    => 78,
      keywords => [KEYWORDS],
      @_
    );

    my $self = {};
    my $keywords = delete( $args{'keywords'} );
    foreach my $word ( @$keywords ) {

      $self->{'keywords'}{ $word } = 1;
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

      if ( exists $self->{'keywords'}{lc($t)} ) {

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
    #  keywords (left) from everyting else (right.

    my ( @output, $output );
    foreach my $line ( @{$self->{'output'}} ) {

      my $left = join ( ' ', @{ $line->{'left'} } );
      $output =  join ( '', $self->{'indent'},
        (' ') x ($left_max - length($left)), $left );
        
      foreach my $r ( @{ $line->{'right'} } ) {

        if ( length ( $output ) + length ( $r ) + 1 > $self->{'width'}  ) {

          push ( @output, $output );
          $output = join( '', $self->{'indent'}, ( ' ' x $left_max ) );
        }
        $output .= " $r";
      }
      push ( @output, $output );
      $output = '';
    }
    if ( $output =~ /\w/ ) { push ( @output, $output ); }

    return ( \@output );
}

1; # End of SQL::Tidy
