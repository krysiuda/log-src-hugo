---
layout: post
title:  "clearing oracle db schema"
date:   2016-11-09
tags:
- oracle
- sql
---

# oracle: how to drop all objects #

This is a handy script to remove everything from a oracle database.
Useful when you need to recreate the database schema using SQL script, or a ORM.

```sql
declare
cursor c_get_objects is
  select object_type,'\"'||object_name||'\"'||decode(object_type,'TABLE' ,' cascade constraints',null) obj_name
  from user_objects -- change this if you want to clear someone else's objects
  where object_type in ('TABLE','VIEW','PACKAGE','SEQUENCE','SYNONYM','MATERIALIZED VIEW','TYPE','FUNCTION') -- add more if you need
  order by object_type;
begin
  begin
    for object_rec in c_get_objects loop
      execute immediate ('drop '||object_rec.object_type||' ' ||object_rec.obj_name);
    end loop;
  end;
  execute immediate ('purge recyclebin');
end;
/
```

Append this to clear geospatial data, if you need it:

```sql
delete from user_sdo_geom_metadata;
commit;
/
```

Note: Always consider using ``TRUNCATE`` instead of ``DELETE`` as it does not use undo space and resets the High Watermark.
