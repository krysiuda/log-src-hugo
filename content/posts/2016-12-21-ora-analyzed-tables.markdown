---
layout: post
title:  "get not analyzed tables on oracle"
date:   2016-12-21
tags:
- oracle
- sql
---

# oracle pl/sql routine to get tables which were not analyzed #

While working on projects having oracle database we might need to confirm if tables' statistics are properly collected.
As tables are added to the database with newer releases and the trigger used for gathering statistics may change over time (job, cron, ...) we might need to verify manually if the collection works properly.
Here is a simple script counting all tables which were not analyzed since a given date.

## finding tables which were not analyzed ##

```sql
declare
  r_count number;
  total_x_count number := 0;
  cursor t_list is select
    table_name
  from
    all_tables
  where
    last_analyzed < to_date('14/07/16','YY/MM/DD') -- the date when statistics should have been gathered
  and
    owner = 'OWNER' -- owner schema
  ;
  t_name t_list%rowtype;
begin
  open t_list;
  loop
    fetch t_list
     into t_name;
    exit when t_list%notfound;
    execute immediate
      'select count(*) from OWNER.' || t_name.table_name || ''
      into r_count; -- apply extra filtering if needed, here we do a count(id)
    if r_count > 0 then
      total_x_count := total_x_count + 1;
    end if;
  end loop;
  close t_list;
  DBMS_OUTPUT.PUT_LINE('tables count:' || total_x_count);
end;
```

More on this subject in oracle's [Database Performance Tuning Guide](http://docs.oracle.com/cd/B19306_01/server.102/b14211/stats.htm#g49431)
