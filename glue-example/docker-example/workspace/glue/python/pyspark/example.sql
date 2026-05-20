DROP TABLE if exists public.student_source;
DROP TABLE if exists public.student_target;

CREATE TABLE public.student_source (
	student_name varchar(255) NOT NULL,
	class_name varchar(255) NOT NULL,
    score int4 not NULL
);

CREATE TABLE public.student_target (LIKE public.student_source);

insert into public.student_source values('Song Li', 'Math', 99);
insert into public.student_source values('Song Li', 'English', 99);
insert into public.student_source values('Song Li', 'Science', 99);
insert into public.student_source values('Trump', 'Math', 33);
insert into public.student_source values('Trump', 'English', 33);

SELECT * FROM public.student_source;
SELECT * FROM public.student_target;
