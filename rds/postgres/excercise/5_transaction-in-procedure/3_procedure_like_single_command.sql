-- This function creates the test table and insert the initial data
-- Call it to reset the playground
create or replace procedure public.create_test_table()
language plpgsql
as $$
begin
	drop table if exists public.visit_count;
	CREATE TABLE public.visit_count (
		person varchar NOT NULL,
		no_of_visits int4 DEFAULT 0 NOT NULL,
		CONSTRAINT visit_count_pk PRIMARY KEY (person)
	);

	insert into public.visit_count (person) values ('Song');
	insert into public.visit_count (person) values ('Trump');
end; $$;


call public.create_test_table();
select * from public.visit_count;

-- Test in autocommit = true
--------------------------------------------------------------

-- 1. A function that wont throw errors
create or replace procedure public.procedure_without_error()
language plpgsql
as $$
begin
	update public.visit_count set no_of_visits = no_of_visits + 1 where person = 'Song';
	update public.visit_count set no_of_visits = no_of_visits + 1 where person = 'Trump';
end; $$;

-- Both rows should be updated properly
call public.procedure_without_error();
select * from public.visit_count;

-- 2. A function that will throw an error at the second update
create or replace procedure public.procedure_throw_error()
language plpgsql
as $$
begin
	update public.visit_count set no_of_visits = no_of_visits + 1 where person = 'Song';
	update public.visit_count set no_of_visits = null where person = 'Trump';
end; $$;

-- After calling the function, the first update is rolled back
-- because the second update failed
-- the procedure is treated as a single block
call public.procedure_throw_error();
select * from public.visit_count;

