package SQL::Tidy::Constants;

use parent qw/Exporter/;

require Exporter;
our @ISA = ('Exporter');

our @EXPORT = qw/@Keywords/;

#  This module holds the keyword definitions.

#  These keywords grabbed from section 5.2 (<token> and <separator>) of the
#  SQL92 spec at http://www.contrib.andrew.cmu.edu/~shadow/sql/sql1992.txt.

our @Keywords = (
  qw/
    absolute  action  add  all  allocate  alter  and
    any  are  as  asc
    assertion  at  authorization  avg

    begin  between  bit  bit_length  both  by
    
	cascade  cascaded  case  cast  catalog  char  character  char_length
    character_length  check  close  coalesce  collate  collation
    column  commit  connect  connection  constraint
    constraints  continue
    convert  corresponding  count  create  cross  current
    current_date  current_time  current_timestamp  current_user  cursor

    date  day  deallocate  dec  decimal  declare  default  deferrable
    deferred  delete  desc  describe  descriptor  diagnostics
    disconnect  distinct  domain  double  drop

    else  end  end-exec  escape  except  exception
    exec  execute  exists
    external  extract

    false  fetch  first  float  for  foreign  found  from  full

    get  global  go  goto  grant  group

    having  hour

    identity  immediate  in  indicator  initially  inner  input
    insensitive  insert  int  integer  intersect  interval  into  is
    isolation

    join

    key

    language  last  leading  left  level  like  local  lower

    match  max  min  minute  module  month

    names  national  natural  nchar  next  no  not  null
    nullif  numeric

    octet_length  of  on  only  open  option  or
    order  outer
    output  overlaps

    pad  partial  position  precision  prepare  preserve  primary
    prior  privileges  procedure  public

    read  real  references  relative  restrict  revoke  right
    rollback  rows

    schema  scroll  second  section  select  session  session_user  set
    size  smallint  some  space  sql  sqlcode  sqlerror  sqlstate
    substring  sum  system_user

    table  temporary  then  time  timestamp  timezone_hour  timezone_minute
    to  trailing  transaction  translate  translation  trim  true

    union  unique  unknown  update  upper  usage  user  using

    value  values  varchar  varying  view

    when  whenever  where  with  work  write

    year

    zone
    /
);

1;
