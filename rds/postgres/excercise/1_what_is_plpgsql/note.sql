-- PL/pgSQL
-- PL/pgSQL (Procedural Language/PostgreSQL) is a procedural programming language supported by the PostgreSQL ORDBMS

-- https://en.wikipedia.org/wiki/PL/pgSQL

-- This is a simple example
-----------------------------------------
do
language plpgsql
-- language is optional in a do block
-- but required in functions and procedures
$$
declare
	a_variable varchar;
begin
	a_variable := 'This is the value of the variable';
	raise info '%', a_variable;
end$$;
