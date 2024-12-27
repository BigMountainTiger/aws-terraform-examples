-- run the script in table.sql to create the student table first

-- A procedure does not have a return value
create or replace procedure public.upsert_student(
	_id int,
	_student_name varchar,
	_is_delete boolean default false
)
language plpgsql
as $$
begin
	IF _is_delete THEN
    	delete from public.student where id = _id;
	ELSE
	    insert into public.student values(_id, _student_name) ON CONFLICT (id) 
		DO UPDATE SET student_name = _student_name;
	END IF;
end; $$;

-- Use keyword call the call a procedure
-- Use select is a syntax error
call public.upsert_student('1', 'The student''s name');

select * from public.student;
