CREATE role a_test_role;

CREATE table if not exists public.example (
	id int NOT NULL,
	"name" varchar NULL
);

GRANT select ON public.example TO a_test_role;

-- drop the object allow droping the roles
-- the easier way to drop the roles is to drop the objects first
-- If table is not dropped, dropping role will fail
drop table if exists public.example cascade;
drop role if exists a_test_role;

-- It is possible to drop a database
drop database if exists "AAA" WITH (FORCE);