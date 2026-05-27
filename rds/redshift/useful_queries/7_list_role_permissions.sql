-- 1. schema privileges
SELECT * 
FROM svv_schema_privileges 
WHERE identity_name = 'the_role_name';

-- 2. relation privileges
select *
FROM svv_relation_privileges 
WHERE identity_type = 'role' 
  AND identity_name = 'the_role_name';

-- 3. default privileges
SELECT * FROM svv_default_privileges;

-- 4. table ownership
SELECT * FROM pg_tables
WHERE tableowner = 'the_role_name';

-- 5. view ownership
select * from pg_views where viewowner = 'the_role_name';

-- 6. schema ownership
SELECT 
    s.nspname AS schema_name, 
    u.usename AS owner_name
FROM 
    pg_catalog.pg_namespace s 
JOIN 
    pg_catalog.pg_user u ON u.usesysid = s.nspowner 
WHERE  u.usename = 'the_role_name';

-- 7. user membership in role
select * from svv_user_grants
where role_name = 'the_role_name';

-- 8. role membership
select * from svv_role_grants
where role_name = 'the_role_name' or granted_role_name = 'the_role_name';