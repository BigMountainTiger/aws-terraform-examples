-- https://www.postgresql.org/docs/current/functions-string.html
-- s formats the argument value as a simple string. A null value is treated as an empty string.
-- I treats the argument value as an SQL identifier, double-quoting it if necessary. It is an error for the value to be null (equivalent to quote_ident).
-- L quotes the argument value as an SQL literal. A null value is displayed as the string NULL, without quotes (equivalent to quote_nullable).


-- NULL is format to empty string
-- No quote is added
SELECT format('Hello %s', null);
SELECT format('Hello %s', 'world');


-- NULL throws exception
-- Double quote is added if necessary (have spaces, etc.)
-- SELECT format('Hello %I', null);
SELECT format('Hello %I', 'world');
SELECT format('Hello %I', 'to the world');


-- NULL => null, no quote is added
-- Single quote is added
SELECT format('Hello %L', null);
SELECT format('Hello %L', 'world');

-- %% escape % in the format string