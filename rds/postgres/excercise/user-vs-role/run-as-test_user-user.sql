-- Verify select permission is granted
select * from public.student s;

-- https://www.postgresql.org/docs/8.0/sql-alteruser.html
-- A user is able to change its own password 
ALTER role test_user with password 'ok-ok';
