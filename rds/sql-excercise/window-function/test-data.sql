DROP TABLE if exists public.baby_names;
CREATE TABLE public.baby_names (
	country varchar NOT NULL,
	gender varchar NOT NULL,
	baby_name varchar NOT NULL,
	total int4 NOT NULL
);

insert into public.baby_names values ('USA', 'G', 'Ava', 95);
insert into public.baby_names values ('USA', 'G', 'Emma', 106);
insert into public.baby_names values ('USA', 'B', 'Ethan', 115);
insert into public.baby_names values ('USA', 'G', 'Isabella', 100);
insert into public.baby_names values ('USA', 'B', 'Jacob', 101);
insert into public.baby_names values ('USA', 'B', 'Liam', 84);
insert into public.baby_names values ('USA', 'B', 'Logan', 73);
insert into public.baby_names values ('USA', 'B', 'Noah', 120);
insert into public.baby_names values ('USA', 'G', 'Olivia', 100);
insert into public.baby_names values ('USA', 'G', 'Sophia', 88);

insert into public.baby_names values ('Canada', 'G', 'Ava', 95);
insert into public.baby_names values ('Canada', 'G', 'Emma', 106);
insert into public.baby_names values ('Canada', 'B', 'Ethan', 115);
insert into public.baby_names values ('Canada', 'G', 'Isabella', 100);
insert into public.baby_names values ('Canada', 'B', 'Jacob', 101);
insert into public.baby_names values ('Canada', 'B', 'Liam', 84);
insert into public.baby_names values ('Canada', 'B', 'Logan', 73);
insert into public.baby_names values ('Canada', 'B', 'Noah', 120);
insert into public.baby_names values ('Canada', 'G', 'Olivia', 100);
insert into public.baby_names values ('Canada', 'G', 'Sophia', 88);

select * from public.baby_names;