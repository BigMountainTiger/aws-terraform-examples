-- Everything is gone when docker compose down

DROP table if exists public.student;

CREATE table if not exists public.student (
	id int4 NOT NULL,
	lname varchar NOT NULL,
	fname varchar NOT NULL,
	CONSTRAINT student_pk PRIMARY KEY (id)
);

insert into  public.student values(1, 'Li', 'Song');
insert into  public.student values(2, 'Trump', 'Donald');
insert into  public.student values(3, 'Biden', 'Joe');

select * from public.student;