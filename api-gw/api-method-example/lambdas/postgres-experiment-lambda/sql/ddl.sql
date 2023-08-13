drop function if exists public.get_students();
drop function if exists public.get_a_student(student_id int4);
drop table if exists public.student;

CREATE TABLE IF NOT EXISTS public.student (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	name varchar NOT NULL,
	CONSTRAINT student_pk PRIMARY KEY (id)
);


CREATE OR REPLACE FUNCTION public.get_students()
 RETURNS table (like public.student)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
 
 return QUERY
 SELECT s.id, s.name from public.student s;

END; $function$;

drop function if exists public.get_a_student(student_id int4);

CREATE OR REPLACE FUNCTION public.get_a_student(student_id int4)
 RETURNS TABLE(id int4, name varchar)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
 
 return QUERY
 SELECT s.id, s.name from public.student s where s.id = student_id;

END; $function$;

DO $$
BEGIN
  if NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE  rolname = 'api_user') THEN
      create user api_user WITH LOGIN;
  END IF;
END
$$;

--revoke all on schema public from api_user;
--revoke all on function public.get_students() from api_user;
--revoke all on function public.get_a_student(int4) from api_user;
--drop user api_user;

GRANT rds_iam TO api_user;
grant usage on schema public to rds_iam;
grant execute on function public.get_students() to rds_iam;
grant execute on function public.get_a_student(int4) to rds_iam;

-- Added test data
insert into public.student (name) values ('Song Li - 1');
insert into public.student (name) values ('Song Li - 2');
insert into public.student (name) values ('Song Li - 3');

select * from public.student;
