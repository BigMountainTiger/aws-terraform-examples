--------------------- Look at the data ------------------------

select * from awswrangler_iceberg_example_db.student_nested;


--------------------- Alter Scalar column ---------------------

-- 1. Standard change column syntax work on scalar column
ALTER TABLE awswrangler_iceberg_example_db.student_nested 
CHANGE COLUMN id id bigint;

-- 2. Nerrow a type is not allowed
ALTER TABLE awswrangler_iceberg_example_db.student_nested 
CHANGE COLUMN id id int;

--------------------- Alter Nested column ---------------------

-- 1. drop a nested field
-- drop the field also drop the data
ALTER TABLE awswrangler_iceberg_example_db.student_nested 
DROP COLUMN student.age;

-- 2. add a nested field
ALTER TABLE awswrangler_iceberg_example_db.student_nested 
ADD COLUMNS (student.age int);

-- 3. widen a nested field type
ALTER TABLE awswrangler_iceberg_example_db.student_nested 
CHANGE COLUMN student.age age bigint;


----------- Update date value of a child property --------------
-- It is not possible by standard SQL
-- Must construct a whole parent record to update it as a whole



