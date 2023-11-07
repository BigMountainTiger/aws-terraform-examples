CREATE table if not exists Student (
  ID int,
  Name varchar (255)
);

delete from student;
--select * from sys_load_error_detail;

-- The s3 prefix can have multiple tables
-- copy is append in redshift
copy student from 's3://redshift-serverless-example-huge-head-li/data/'
iam_role default
delimiter '|'
ignoreheader 1;

-- To rename a table
--alter table student rename to students;

select * from public.public.student;