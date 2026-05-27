-------------- Users ------------------

CREATE OR REPLACE PROCEDURE public.user_management_create_if_not_exists(user_name IN VARCHAR)
LANGUAGE plpgsql
SECURITY INVOKER
AS $$
BEGIN
	IF EXISTS (SELECT 1 FROM svl_user_info u WHERE u.usename = user_name) THEN 
        RAISE NOTICE 'User [%] already exists, skipping', user_name;
	ELSE
		EXECUTE 'CREATE USER ' || quote_ident(user_name) || ' PASSWORD DISABLE';
		RAISE NOTICE 'User [%] created', user_name;
    END IF;
END;
$$;


call public.user_management_create_if_not_exists('stupid_user');

-- We can set password if needed after the creation
alter user stupid_user password 'Pass1234';
drop user if exists stupid_user;


-------------- Roles ------------------

CREATE OR REPLACE PROCEDURE public.role_management_create_if_not_exists(role_name IN VARCHAR)
LANGUAGE plpgsql
SECURITY INVOKER
AS $$
BEGIN
	IF EXISTS (SELECT 1 FROM svv_roles v WHERE v.role_name = role_name) THEN 
        RAISE NOTICE 'Role [%] already exists, skipping', role_name;
	ELSE
		EXECUTE 'CREATE ROLE ' || quote_ident(role_name);
		RAISE NOTICE 'Role [%] created', role_name;
    END IF;
END;
$$;

-- **** https://docs.aws.amazon.com/redshift/latest/dg/r_DROP_ROLE.html
-- Although the force option is defined as "Use FORCE to remove all role assignments, if any exists."
-- It actually worked even when the role has permissions on tables, schemas, and default privileges.

CREATE OR REPLACE PROCEDURE public.role_management_drop_if_exists(role_name IN VARCHAR, force BOOLEAN)
LANGUAGE plpgsql
SECURITY INVOKER
AS $$
BEGIN
	IF EXISTS (SELECT 1 FROM svv_roles v WHERE v.role_name = role_name) THEN
		EXECUTE 'DROP ROLE ' || quote_ident(role_name) || ' ' || CASE WHEN force THEN 'FORCE' ELSE 'RESTRICT' END;
		RAISE NOTICE 'Role [%] dropped', role_name;
	ELSE
		RAISE NOTICE 'Role [%] does not exist, skipping', role_name;
    END IF;
END;
$$;

call public.role_management_create_if_not_exists('stupid_role');
call public.role_management_drop_if_exists('stupid_role', true);

-- Check if role exists
select * from svv_roles v WHERE v.role_name = 'stupid_role';

