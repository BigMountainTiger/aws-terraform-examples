-- Postgres has both procedures and functions
-- Note: use the docker image in the .script to test the following scritps

drop table if exists public.student;

CREATE TABLE public.student (
	id int4 NOT NULL,
	student_name varchar NULL,
	CONSTRAINT student_pk PRIMARY KEY (id)
);