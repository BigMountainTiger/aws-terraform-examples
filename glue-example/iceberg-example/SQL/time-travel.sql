-- https://docs.aws.amazon.com/athena/latest/ug/querying-iceberg-time-travel-and-version-travel-queries.html
-- https://docs.aws.amazon.com/prescriptive-guidance/latest/apache-iceberg-on-aws/introduction.html
-- https://aws.amazon.com/blogs/big-data/implement-historical-record-lookup-and-slowly-changing-dimensions-type-2-using-apache-iceberg/

----------------------------------------------

CREATE TABLE IF NOT EXISTS glue_database_name.first_iceberg_table (
    id bigint,
    name string
)
LOCATION 's3://duke-energy-cc-customer-di-data-recon-results-dev/IcebergPOC/first_iceberg_table/'
TBLPROPERTIES ( 'table_type' = 'ICEBERG', 'format' = 'PARQUET' );
 
 
DROP TABLE if EXISTS glue_database_name.first_iceberg_table;
 
 
----------------------------------------------
 
 
INSERT INTO glue_database_name.first_iceberg_table (id, name)
VALUES (1, 'name no. 1'), (2, 'name no. 2'), (3, 'name no. 3');
 
INSERT INTO glue_database_name.first_iceberg_table (id, name)
VALUES (4, 'name no. 4');
 
UPDATE glue_database_name.first_iceberg_table
SET name = 'name no. 1 updated'
WHERE id = 1;
 
DELETE FROM glue_database_name.first_iceberg_table
WHERE id = 3;
 
 
------------------------------------------
 
 
select * from glue_database_name.first_iceberg_table order by id;
 
select * from "glue_database_name"."first_iceberg_table$snapshots"
order by committed_at;
 
select * from "glue_database_name"."first_iceberg_table$history"
order by made_current_at;
 
--  Time Travel using Timestamp
select * from glue_database_name.first_iceberg_table FOR TIMESTAMP AS OF 	
TIMESTAMP '2024-06-10 12:00:00'
order by id;

-- Time Travel using Version
select * from glue_database_name.first_iceberg_table FOR VERSION AS OF 	
2546833515697266959
order by id;