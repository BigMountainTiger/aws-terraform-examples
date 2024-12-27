-- https://www.postgresql.org/docs/current/functions-string.html
-- s formats the argument value as a simple string. A null value is treated as an empty string.
-- I treats the argument value as an SQL identifier, double-quoting it if necessary. It is an error for the value to be null (equivalent to quote_ident).
-- L quotes the argument value as an SQL literal. A null value is displayed as the string NULL, without quotes (equivalent to quote_nullable).

-- https://www.postgresql.org/docs/current/ddl-priv.html
-- The special “role” name PUBLIC can be used to grant a privilege to every role on the system

drop table if exists public.student;

CREATE TABLE public.student (
	id int4 NOT NULL,
	student_name varchar NULL,
	CONSTRAINT student_pk PRIMARY KEY (id)
);

insert into public.student values(1, 'Student No.1');

-- In postgres role and user are the samething
-- user is a special role that can be used to connect to the database
do $$
begin
	if not exists(select from pg_catalog.pg_roles where rolname = 'test_user') then
		create user "test_user" with password 'test_pass';
	end if;
END
$$;

do $$
begin
	if not exists(select from pg_catalog.pg_roles where rolname = 'read_only') then
		create role "read_only" with NOLOGIN;
	end if;
END
$$;

grant usage on schema public to read_only;
grant select on table public.student to read_only;
grant read_only to test_user;


-- Clear up
revoke all on all tables in schema public from read_only;
revoke usage on schema public from read_only;
drop role if exists test_user;
drop role if exists read_only;



