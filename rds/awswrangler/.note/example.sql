-- Everything is gone when docker compose down

DROP table if exists public.student;

CREATE TABLE public.student (
	id int4 NOT NULL,
	lname varchar NOT NULL,
	fname varchar NOT NULL,
	visit_count int4 DEFAULT 0 NOT NULL,
	CONSTRAINT student_pk PRIMARY KEY (id)
);

insert into  public.student values(1, 'Li', 'Song');
insert into  public.student values(2, 'Trump', 'Donald');
insert into  public.student values(3, 'Biden', 'Joe');

update public.student set visit_count = visit_count + 1
where id = 1;

select * from public.student
order by id;