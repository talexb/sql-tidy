#!/usr/bin/perl

use strict;
use warnings;

use Getopt::Long;
use Pod::Usage;
use FindBin qw/$Bin/;

use lib "$Bin/../lib";

use SQL::Tidy;

#  This is the command line interface to SQL::Tidy.

{
    my ( $indent, $width, @keywords, @keyword_exs, $sub_select_indent,
      $watch_for_code, $format );
    my ( $help, $man ) = ( 0, 0 );

    GetOptions(
      'indent=i'          => \$indent,
      'width=i'           => \$width,
      'keywords=s@'       => \@keywords,
      'keyword_exs=s@'    => \@keyword_exs,
      'sub_select_indent' => \$sub_select_indent,
      'watch_for_code'    => \$watch_for_code,
      'format=s'          => \$format,

      'help|?|n' => \$help,
      'man'      => \$man
    ) or pod2usage(2);

    if ( $help ) { pod2usage(1); exit; }
    if ( $man ) { pod2usage( -exitval => 0, -verbose => 2 ); }

    my %args;

    defined $indent and $args{'indent'}             = $indent;
    defined $width  and $args{'width'}              = $width;
    @keywords       and $args{'keywords'}           = \@keywords;
    @keyword_exs    and $args{'keyword_exceptions'} = \@keyword_exs;
    defined $sub_select_indent
      and $args{'sub_select_indent'} = $sub_select_indent;
    defined $watch_for_code
      and $args{'watch_for_code'} = $watch_for_code;
    $args{'format'} //= 'guttered';

    if ( !exists $formats{ $args{'format'} } ) { pod2usage(1); exit; }

    my @input = map { s/\s+$//; $_ } <>;
    # my @input = <>;
    my $input = join( $/, @input );

    my $obj = SQL::Tidy->new(%args);
    my $result = $obj->tidy( $input );

    print join ( $/, @$result, '' );
}

__END__

=head1  NAME

sqltidy - Tidy up formatting of some SQL commands

=head1 SYNOPSIS

sqltidy [options]

 Options:
   --help          brief help message
   --man           full documentation
   --indent        number of spaces to indent (default is 4)
   --width         width to use for wrapping (default is 78)
   --keywords      list of keywords to use instead of defaults
   --keyword_exs   list of keyword exceptions instead of the defaults
   --sub_select_indent  enable experimental code to handle sub-selects
   --watch_for_code     enable experimental code to handle quoted SQL

=head1 OPTIONS

=over 8

=item B<-help>
 
Print a brief help message and exits.
 
=item B<-man>
 
Prints the manual page and exits.

=item B<indent>

Defines the size of the indent to be used when outputting the formatted SQL.
Defaults to 4.

=item B<width>

Defines the width to be used when outputting the formatted SQL.
Defaults to 78.

=item B<keywords>

Defines the keywords to be used when formatting, instead of the defaults.
Defaults the reserved and possiblt future reserved keywords in the SQL92
standard found at http://www.contrib.andrew.cmu.edu/~shadow/sql/sql1992.txt.

=item B<keyword_exs>

Defines the keyword exceptions to be used when formatting, instead of the
defaults.  The list is currently as, on, set, desc, asc, cast, int, in, like,
all, date, time, replace, and substring.

=item B<sub_select_indent>

This enables code to further indent a sub-select that may be part of the SQL
being tidied.

=item B<watch_for_code>

This switch allows the tool to deal with a query that has code around (before
and after) the SQL.

=back

=head1 DESCRIPTION

This program will read an SQL statement from stdin, and format it tidily on
stdout, suitable for being called from an editor.

Statements not currently handled well are CREATE TABLE and statements that
include an IF ELSEIF END block.

=cut
