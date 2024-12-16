-- https://docs.aws.amazon.com/redshift/latest/dg/r_SVV_ROLES.html
select * from pg_catalog.SVV_ROLES;
select * from pg_catalog.pg_group;
select * from pg_catalog.pg_user;

-- Modify a user to group
-- https://docs.aws.amazon.com/redshift/latest/dg/r_ALTER_GROUP.html
ALTER GROUP group_name
{
    ADD USER username |
    DROP USER username |
    RENAME TO new_name
}

-- What groups a user belong to
select groname from pg_user , pg_group
where pg_user.usesysid = ANY(pg_group.grolist)
	and usename = 'user_name';

-- The granted permissons to the entities (user, group, role) on tables, views
-- https://docs.aws.amazon.com/redshift/latest/dg/r_SVV_RELATION_PRIVILEGES.html
select * from pg_catalog.SVV_RELATION_PRIVILEGES;

-- The granted permission on the schemas
-- https://docs.aws.amazon.com/redshift/latest/dg/r_SVV_SCHEMA_PRIVILEGES.html
select * from pg_catalog.SVV_SCHEMA_PRIVILEGES;

-- Grant and revoke
GRANT select on the_schema.the_table to entity
REVOKE select on the_schema.the_table from entity


