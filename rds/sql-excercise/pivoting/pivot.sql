-- Postgres does not natively support PIVOT
-- In redshift

CREATE EXTENSION IF NOT EXISTS tablefunc;

DROP TABLE if exists public.student;
CREATE TABLE public.student (
	student_name varchar(255) NOT NULL,
	class_name varchar(255) NOT NULL,
    score int4 not NULL
);

insert into public.student values('Song Li', 'Math', 99);
insert into public.student values('Song Li', 'English', 99);
insert into public.student values('Song Li', 'Science', 99);

insert into public.student values('Trump', 'Math', 33);
insert into public.student values('Trump', 'English', 33);


select * from public.student;


select * from
(
	select class_name, score from public.student
) s PIVOT (
	MAX(score) for class_name in (
		'Math',
		'English',
		'Science'
	)
);

select * from
(
	select student_name, class_name, score from public.student
) s PIVOT (
	MAX(score) for class_name in (
		'Math',
		'English',
		'Science'
	)
);

-- The idea of PIVOT:
-- 1. Do aggregation GROUP BY
-- 2. Remove 2 columns from the result
-- 3. Add bunch of columns to the result