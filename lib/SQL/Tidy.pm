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
	#  INTO is an exception to that rule. So some keywords will cause a new
	#  output line to be created (design to come.)

	push ( @{$self->{'output'}}, { left => [], right => [] } );

	foreach my $t ( @tokens ) {

      if ( exists $self->{'keywords'}{$t} ) {

        push( @{ $self->{'output'}->[-1]->{'left'} }, $t );
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

	my ( @output, $output );
	foreach my $line ( @{$self->{'output'}} ) {

      $output =  join ( ' ', $self->{'indent'},
        join ( ' ', @{ $line->{'left'} } ) );
        
      foreach my $r ( @{ $line->{'right'} } ) {

        if ( length ( $output ) + length ( $r ) + 1 > $self->{'width'}  ) {

          push ( @output, $output );
          $output = join( ' ',
            $self->{'indent'},
            ( ' ' x length( join( ' ', @{ $line->{'left'} } ) ) )
          );
		}
		$output .= " $r";
      }
	}
	if ( $output =~ /\w/ ) { push ( @output, $output ); }

	return ( \@output );
}

1; # End of SQL::Tidy
