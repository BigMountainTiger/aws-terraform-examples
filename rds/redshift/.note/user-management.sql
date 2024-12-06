-- https://docs.aws.amazon.com/redshift/latest/dg/r_SVV_ROLES.html
select * from pg_catalog.SVV_ROLES;
select * from pg_catalog.pg_group;
select * from pg_catalog.pg_user;

-- The granted permissons to the entities (user, group, role) on tables, views
-- https://docs.aws.amazon.com/redshift/latest/dg/r_SVV_RELATION_PRIVILEGES.html
select * from pg_catalog.SVV_RELATION_PRIVILEGES;

-- The granted permission on the schemas
-- https://docs.aws.amazon.com/redshift/latest/dg/r_SVV_SCHEMA_PRIVILEGES.html
select * from pg_catalog.SVV_SCHEMA_PRIVILEGES;

-- Grant and revoke
GRANT select on the_schema.the_table to entity
REVOKE select on the_schema.the_table from entity


