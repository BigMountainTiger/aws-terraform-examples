-- DO start an anonymous function execution

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

-- https://www.postgresql.org/docs/current/sql-do.html
--------------------------------------------------------------
-- * The DO code block is treated as though it were the body of a function with no parameters,
-- returning void. It is parsed and executed a single time

-- * Transaction control statements are only allowed if DO is executed in its own transaction.

-- Examples:

-- 1. both updates succeed

do
$$
begin
	update public.visit_count set no_of_visits = no_of_visits + 1 where person = 'Song';
	update public.visit_count set no_of_visits = no_of_visits + 1 where person = 'Trump';
end$$;

select * from public.visit_count;

-- 2. the do block is treated as a single command, neither update is committed

do
$$
begin
	update public.visit_count set no_of_visits = no_of_visits + 1 where person = 'Song';

	-- this update will fail because no_of_visits is NOT NULL
	update public.visit_count set no_of_visits = null where person = 'Trump';
end$$;

select * from public.visit_count;

-- 3.subblock does not change the transaction behavior, neither update is committed

do
$$
begin

	begin
		update public.visit_count set no_of_visits = no_of_visits + 1 where person = 'Song';
	end;

	-- this update will fail because no_of_visits is NOT NULL
	begin
		update public.visit_count set no_of_visits = null where person = 'Trump';
	end;
end$$;

select * from public.visit_count;

-- 4. It is possible partially commit or rollback transactions in a DO block
-- But what is the use case? Is it useful?

call public.create_test_table();
select * from public.visit_count;


do
$$
begin
	update public.visit_count set no_of_visits = no_of_visits + 1 where person = 'Song';
	commit;

	update public.visit_count set no_of_visits = no_of_visits + 1 where person = 'Trump';
	rollback;
	
	update public.visit_count set no_of_visits = no_of_visits + 1 where person = 'Song';
	commit;
end$$;

select * from public.visit_count;
