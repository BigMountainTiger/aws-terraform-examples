-- A connection can have a single active transaction

-- the messages are displayed in the "output" tab in dbeaver
-- with psycopg, it is in the conn.notifies of the connection

-- trying to start a transaction in an active transaction wont throw errors
-- it only shows a NOTIFICATION
-- "there is already a transaction in progress"
begin;
begin transaction;

-- https://www.postgresql.org/docs/current/sql-begin.html
-- BEGIN initiates a transaction block
-- START TRANSACTION has the same functionality as BEGIN.
-- begin is the same as begin transaction ("transaction" is optional that has no effect);

-- trying to commit without an active transaction get NOTIFICATION
-- "there is no transaction in progress"
commit;

-- trying to commit without an active transaction get NOTIFICATION
-- "there is no transaction in progress"
rollback;


-- the "begin;" and "begin ... end;" block is different
-------------------------------------------------------

-- "begin;" starts a transaction
begin;

-- "begin ... end;" create a code block
do
$$
begin

end$$;