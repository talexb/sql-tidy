#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use SQL::Tidy;

{
    my $tidy = SQL::Tidy->new(format => 'guttered');
    ok ( defined $tidy, 'Create tidy object' );

    done_testing;
}
