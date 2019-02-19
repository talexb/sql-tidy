package SQL::Tidy::Constants;

use parent qw/Exporter/;

require Exporter;
our @ISA = ('Exporter');

our @EXPORT = qw/@Keywords/;

#  This module holds the keyword definitions.

our @Keywords = ( qw/
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
    inner
    insert
    into
    join
    left
    on
    only
    or
    order
	outer
    read
    select
    then
    union
    update
    values
    view
    when
    where/ );

1;
