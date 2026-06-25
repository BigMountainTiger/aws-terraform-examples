-- Create a backup of the iceberg table
-- external = false is required
CREATE TABLE awswrangler_iceberg_example_db.student_nested_backup
WITH (
  is_external = false,
  table_type = 'ICEBERG',
  location = 's3://iceberg-example-huge-head-li/database/awswrangler_iceberg_example_db/student_nested_backup'
) AS 
SELECT * 
FROM awswrangler_iceberg_example_db.student_nested;


-- Drop the tables
drop table if exists awswrangler_iceberg_example_db.student_nested;
drop table if exists awswrangler_iceberg_example_db.student_nested_backup;

-- Verify the backup
select * from awswrangler_iceberg_example_db.student_nested;
select * from awswrangler_iceberg_example_db.student_nested_backup;
