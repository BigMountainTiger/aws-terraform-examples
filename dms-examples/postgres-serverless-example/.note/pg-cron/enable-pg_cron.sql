-- Need to add pg_cron to shared_preload_libraries through the parameter group
-- https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/PostgreSQL_pg_cron.html

-- Must run in the database postgres
CREATE EXTENSION pg_cron;
