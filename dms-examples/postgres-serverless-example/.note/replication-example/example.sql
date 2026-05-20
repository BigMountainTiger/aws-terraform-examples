-- Source Table
DROP table if exists public.example;

CREATE TABLE public.example (
	id int8 NOT NULL GENERATED ALWAYS AS IDENTITY,
	field_1 varchar(255) NULL,
	CONSTRAINT example_pk PRIMARY KEY (id)
);

-- Test insert data
insert into public.example (field_1) values('Initial');
insert into public.example (field_1) values('Initial');
insert into public.example (field_1) values('Initial');

-- Update and delete
update public.example set field_1 = 'updated' where id = 1;
delete from public.example where id != 1;

-- Source Table
select * from public.example;

-- The target table
DROP table if exists public.example_target;
SELECT * FROM public.example_target;

-- Job Monitoring
select * from awsdms_ddl_audit;
select * from awsdms_apply_exceptions aae;

-- Additional Test
insert into public.example_target (id, field_1) values (2, 'Inserted directly to the target');
SELECT * FROM public.example_target;
