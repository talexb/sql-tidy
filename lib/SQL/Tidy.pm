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
      margin   => '',
      @_
    );

	my $self = {};
	my $keywords = delete( $args{'keywords'} );
	foreach my $word ( @$keywords ) {

	  $self->{'keywords'}{ $word } = 1;
	}

	bless $self, $class;
	return $self
}

1; # End of SQL::Tidy
