create schema if not exists aaa_base_schema;
create schema if not exists aaa_view_schema;


CREATE TABLE IF NOT EXISTS aaa_base_schema.a_table
(
    id INT not null ,name VARCHAR(255) NOT NULL
);

DROP MATERIALIZED VIEW IF EXISTS aaa_view_schema.a_table_v;
CREATE MATERIALIZED VIEW aaa_view_schema.a_table_v
AUTO REFRESH YES AS 
SELECT * from aaa_base_schema.a_table;

-- Add test data
insert into aaa_base_schema.a_table values(1, 'name no.1');
select * from aaa_view_schema.a_table_v;

-- Drop
-- Redshift is not good at checking dependencies
-- cascade is needed to drop the schema even when it only depends on others
drop schema aaa_base_schema cascade;
drop schema aaa_view_schema cascade;