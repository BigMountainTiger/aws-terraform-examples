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
end; $$;

-- create the playground
call public.create_test_table();
select * from public.visit_count;

-- Example to use variables in plpgsql
-- https://www.postgresql.org/docs/current/plpgsql-overview.html
create or replace procedure public.raise_notice_if_even_visit()
language plpgsql
as $$
declare
	visit_count int;
	msg varchar;
begin
	update public.visit_count set no_of_visits = no_of_visits + 1 where person = 'Song';
	select no_of_visits into visit_count from public.visit_count where person = 'Song';
	
	if visit_count % 2 = 0
	then
		raise notice '%', format('Even visits: No. of visits = %s', visit_count);
	end if;

end;$$;

-- Notice only raised when visit count is even
call public.raise_notice_if_even_visit();
