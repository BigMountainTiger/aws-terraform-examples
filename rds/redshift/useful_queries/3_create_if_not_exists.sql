drop role if exists example_user_name;
drop role if exists example_role_name;

--CREATE_USER

DO
$$
<<CREATE_USER>>
DECLARE
	user_name varchar := 'example_user_name';
	pass_word varchar := '?????';
BEGIN
	IF EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = user_name) THEN
		RAISE info 'Role "%" already exists. Skipping.', user_name;
		exit CREATE_USER;
	ELSE
		EXECUTE format('CREATE ROLE %s LOGIN PASSWORD ''%s''', user_name, pass_word);
	END IF;
end
$$;

-- CREATE_ROLE

DO
$$
<<CREATE_ROLE>>
DECLARE
	role_name varchar := 'example_role_name';
BEGIN
	IF EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = role_name) THEN
		RAISE info 'Role "%" already exists. Skipping.', role_name;
		exit CREATE_ROLE;
	ELSE
		EXECUTE format('CREATE ROLE %s', role_name);
	END IF;
end
$$;



