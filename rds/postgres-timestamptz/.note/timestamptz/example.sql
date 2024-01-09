DROP table if exists public.example_table;

-- 1. data => only date, time => only time, timestamp => both date and time
CREATE TABLE public.example_table (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	entry_time timestamptz NOT NULL,
	CONSTRAINT example_table_pk PRIMARY KEY (id)
);

-- 2. timezone is a client session variable. With DBeaver,
-- it is set at Window => Preferences => User Interface => Timezone, the default is the client timezone
show timezone;
select * from pg_settings where name = 'TimeZone';

-- 3. This list all the available time zones, UTC, America/New_York, etc.
select * from pg_timezone_names;

-- 4. timezone can be set by the following command. BUT it does not work all as expected
set timezone='UTC';

-- 5. now() returns a timestamptz
select now();

-- 6. Convert timestmptz => timestamp simply remove the timezone information
-- Convert timestmp => timestmptz simply add the timezone information
select now()::timestamp;
select (now()::timestamp)::timestamptz;

-- 7. When a string cast to timestamptz, it simply add the current timezone to it
-- When a string cast to timestamp, it is a straight conversion
select '2023-12-28 15:51:36.987'::timestamptz;
select '2023-12-28 15:51:36.987'::timestamp;

-- More example
-- A string of timestamptz has timezone in it - '2023-12-28 15:51:36.987 -0500'
-- If the timezone is missing, the current timezone is added to it
insert into public.example_table (entry_time) values('2023-12-28 15:51:36.987 -0500');
insert into public.example_table (entry_time) values('2023-12-28 15:51:36.987');

select * from public.example_table where entry_time = '2023-12-28 15:51:36.987 -0500';
select * from public.example_table;
