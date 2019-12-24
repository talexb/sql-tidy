package SQL::Tidy;

use 5.006;
use strict;
use warnings;

our $VERSION = '0.01';

our %formats = (
  'staggered' => 'SQL::Tidy::Staggered',
  'guttered'  => 'SQL::Tidy::Guttered'
);

use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw/%formats/;

#  Because I'm pulling in the module, I may be redefining the routines within
#  the module. Perl warns about this, but that's not useful.

$SIG{__WARN__} = sub
{
    my $warning = shift;
    warn $warning unless $warning =~ /Subroutine .* redefined at/;
};

sub new 
{
    my $class = shift;  #  Ignored -- object will getting blessed into child class.
    my %args = @_;

    my $module = $formats{ $args{'format'} };
    if ( defined $module ) {
        #  Convert module name into module file name, pull it in, and run that
        #  module's new function.

        my $module_file = $module;
        $module_file =~ s!::!/!g;

        do "$module_file.pm";

        return $module->new ( %args );
    } else { die "Failed to load $module"; }
}

1;    # End of SQL::Tidy
