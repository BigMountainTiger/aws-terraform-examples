CREATE TEMP TABLE IF NOT EXISTS student
(
	student_id INTEGER NOT NULL
	,student_name VARCHAR(200) NULL
	,score INTEGER NULL
	,PRIMARY KEY (student_id)
);


CREATE TEMP TABLE IF NOT EXISTS student_name
(
	student_id INTEGER NOT NULL
	,student_name VARCHAR(200) NULL
	,PRIMARY KEY (student_id)
);


CREATE TEMP TABLE IF NOT EXISTS student_score
(
	student_id INTEGER NOT NULL
	,score INTEGER NULL
	,PRIMARY KEY (student_id)
);

truncate TABLE student;
truncate TABLE student_name;
truncate TABLE student_score;

insert into student(student_id) values (1);
insert into student(student_id) values (2);

insert into student_name(student_id, student_name) values (1, 'Song');
insert into student_name(student_id, student_name) values (2, 'Trump');

insert into student_score(student_id, score) values (1, 99);


select * from student;
select * from student_name;
select * from student_score;

update s
set student_name = sn.student_name, score = ss.score
from student s, student_name sn, student_score ss
where s.student_id = sn.student_id and s.student_id = ss.student_id;

-- Both student_name and score are NULL for trump
-- Even though 2 has student_name = Trump
-- The update is inner join nature

select * from student order by student_id;

-- To be safe need to issue the update for each source table one by one