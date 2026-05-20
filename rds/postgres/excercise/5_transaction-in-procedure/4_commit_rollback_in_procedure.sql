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


-- Issueing commit/rollback in procedure can cause trouble
------------------------------------------------------------


-- A function that has commit statement in it (Not recommended, but allowed)
-- and throw an error
create or replace procedure public.procedure_with_commit()
language plpgsql
as $$
begin
	update public.visit_count set no_of_visits = no_of_visits + 1 where person = 'Song';
	commit;

	update public.visit_count set no_of_visits = null where person = 'Trump';
end; $$;

-- With autocommit
-- Puttig a commit in the stored procedure can commit the partial update
-- no_of_visits add 1 for Song, but no change for Trump
-- With autocommit = true
-- The error show the procedure fails when the null is updated to the NON-NULL column no_of_visits
call public.procedure_with_commit();
select * from public.visit_count;


-- With an explicit transaction
-- The error happen when the "commit;" is called. It means postgres does not support calling commit
-- in the procedure with an transaction started by "begin transaction" or autocommit = false
-- explicit commit/rollback in a stored procedure is not a good practice
begin transaction;	
call public.procedure_with_commit();
commit;


-- CONCLUSION
-- It is not a good practice to put transaction control in a procedure in postgres
-- 1. begin transaction in a function is a syntax error
-- 2. If the prodecure or function is called in a transaction, error is thrown if rollback/commit is called in the function

