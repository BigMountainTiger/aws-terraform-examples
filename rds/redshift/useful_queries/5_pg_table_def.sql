-- 1. Only the tables visible to the user is returned
-- 2. The table name is lower case
-- 3. It can be used to see all the columns and their types of a table

select * from pg_catalog.pg_table_def where tablename = lower('table_name');