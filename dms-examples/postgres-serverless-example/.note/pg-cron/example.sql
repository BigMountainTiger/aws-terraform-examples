-- Once enabled, cron is accessible from any database
-- https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/PostgreSQL_pg_cron.html

DROP table if exists public.example_table;

CREATE TABLE public.example_table (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	entry_time timetz NOT NULL,
	CONSTRAINT example_table_pk PRIMARY KEY (id)
);

--insert into public.example_table (entry_time) values(now());

-- Every 2 minutes
select cron.schedule('Run every minute', '*/2 * * * *', 'insert into public.example_table (entry_time) values(now());');
-- Every 1 minute
select cron.schedule('Run every minute', '* * * * *', 'insert into public.example_table (entry_time) values(now());');

select * from cron.job where jobname = 'Run every minute';
select * from cron.job_run_details;

-- Delete a job
select cron.unschedule('Run every minute');

select * from public.example_table;