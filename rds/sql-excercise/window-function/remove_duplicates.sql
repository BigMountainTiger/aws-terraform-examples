-- https://stackoverflow.com/questions/18390574/delete-duplicate-rows-keeping-the-first-row


DROP TABLE if exists public.student;
CREATE TABLE public.student (
	id int4 NOT NULL,
	student_name varchar(255) NOT NULL,
    sequence int4 not NULL
);

insert into public.student values(1, 'Song Li', 1);
insert into public.student values(1, 'Song Li', 2);
insert into public.student values(1, 'Song Li', 3);

insert into public.student values(2, 'Trump', 1);
insert into public.student values(2, 'Trump', 2);
insert into public.student values(2, 'Trump', 3);

select * from public.student;

-- select
with query as (
	select id, student_name, sequence,
	row_number() over (partition by id, student_name order by sequence desc) as rn
	from public.student
)
select * from query
where rn = 1;


-- delete from postgres is not possible
-- but we can join with CTE (postgres needs "using" keyword)
with query as (
	select id, student_name, sequence,
	row_number() over (partition by id, student_name order by sequence desc) as rn
	from public.student
)
delete
from public.student s using query q
where s.id = q.id and s.student_name = q.student_name and s.sequence = q.sequence and q.rn > 1;

select * from public.student;

