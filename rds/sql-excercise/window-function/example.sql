-- https://www.youtube.com/watch?v=rIcB4zMYMas&ab_channel=MavenAnalytics

-- SQL Windows functions are used to create a number on each row of the selected data
-- Windows functions are not aggregations, it wont affect the number or rows returned

-- It is OK without partitions
-- Then it is a single partition with the whole data set

select country, gender, baby_name, total,
	row_number() over (order by total desc) as popularity,
	rank() over (order by total desc) as popularity_rank,
	dense_rank() over (order by total desc) as popularity_dense_rank
from public.baby_names;

-- It is possible to partition by multiple columns separated by commas ","

select country, gender, baby_name, total,
	row_number() over (partition by country, gender order by total desc) as popularity,
	rank() over (partition by country, gender order by total desc) as popularity_rank,
	dense_rank() over (partition by country, gender order by total desc) as popularity_dense_rank
from public.baby_names;

-- It is possible to use CTE to select based on the windows function

with query as (
	select country, gender, baby_name, total,
		row_number() over (partition by country, gender order by total desc) as popularity,
		rank() over (partition by country, gender order by total desc) as popularity_rank,
		dense_rank() over (partition by country, gender order by total desc) as popularity_dense_rank
	from public.baby_names
)
select * from query where popularity = 1;