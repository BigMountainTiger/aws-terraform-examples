-- run the script in table.sql to create the student table first

-- A function returns a value

-- The following function returns a table
-- the table type is defined use "like" syntax
CREATE OR REPLACE FUNCTION public.get_students()
 RETURNS table (like public.student)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $$
begin
	
 return QUERY
 SELECT s.id, s.student_name from public.student s;
END; $$;

-- The following function take a parameter
-- the table type in defined in-line
CREATE OR REPLACE FUNCTION public.get_a_student(student_id int4)
 RETURNS TABLE(id int4, student_name varchar)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $$
BEGIN
 
 return QUERY
 SELECT s.id, s.student_name from public.student s where s.id = student_id;
END; $$;

-- It is possible to return a scalar value
CREATE OR REPLACE FUNCTION public.get_a_scalar()
 RETURNS int4
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $$
BEGIN
 
 return 100;
END; $$;

select * from public.get_students();
select * from public.get_a_student(1);
select public.get_a_scalar();


