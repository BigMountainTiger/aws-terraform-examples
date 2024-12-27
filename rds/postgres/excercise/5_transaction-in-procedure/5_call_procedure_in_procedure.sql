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

-- Procedure without error
create or replace procedure public.procedure_without_error()
language plpgsql
as $$
begin
	update public.visit_count set no_of_visits = no_of_visits + 1 where person = 'Song';
	update public.visit_count set no_of_visits = no_of_visits + 1 where person = 'Trump';
end; $$;


-- Procedure with error
create or replace procedure public.procedure_with_error()
language plpgsql
as $$
begin
	update public.visit_count set no_of_visits = null where person = 'Song';
	update public.visit_count set no_of_visits = null where person = 'Trump';
end; $$;

-- Procedure with error
create or replace procedure public.call_both()
language plpgsql
as $$
begin
	call public.procedure_without_error();
	call public.procedure_with_error();
end; $$;

-- Reset the playground
call public.create_test_table();

-- This call will fail and fail as a single unit
-- even though it calls two different procedures
call public.call_both();

-- Verify the result
select * from public.visit_count;



