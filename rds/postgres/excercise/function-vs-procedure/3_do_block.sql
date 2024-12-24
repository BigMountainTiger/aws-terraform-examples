-- DO executes an anonymous code block, in other words a nonymous function
-- https://www.postgresql.org/docs/current/sql-do.html

-- The double $$ serves as quote of the code block
-- https://www.geeksforgeeks.org/postgresql-dollar-quoted-string-constants/#

-- If the string has $$,
-- we can add an optional tag/label, so $$ is recognized as part of the string

select $tag_txt$This is the escaped $$$$.$tag_txt$;

-- We can raise from the code block
-- DEBUG, LOG, INFO, NOTICE, WARNING, and EXCEPTION, default is EXCEPTION
-- https://www.postgresql.org/docs/current/plpgsql-errors-and-messages.html

do
$$
begin

	raise info 'The information to output';
end
$$;

do
$$
begin

	raise notice 'The notice to output';
end
$$;


do
$$
begin
	-- nothing sent to output when exception happens
	raise exception 'an exception terminate the command';
end
$$;

