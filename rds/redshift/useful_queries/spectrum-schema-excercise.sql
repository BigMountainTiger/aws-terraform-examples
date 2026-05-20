-- Need to make the "example-json.txt" at the s3 location
-- under the data folder

{"field_1": "value 11","field_2": "value 12"}
{"field_1": "value 21","field_2": "value 22"}

-- This excercise shows that we can create the spectrum schema before
-- glue database exists. If can pick up the glue database and tables afterwards

-- Create the schema
CREATE EXTERNAL SCHEMA a_song_test
    FROM DATA CATALOG
    DATABASE 'a_song_test'
    REGION 'us-east-1'
    IAM_ROLE 'arn:aws:iam:::role/redshift-role';

SELECT * from a_song_test.test;

drop schema if exists a_song_test;

-- At the athena side
CREATE DATABASE if not exists a_song_test;


CREATE EXTERNAL TABLE test(
    field_1 string,
    field_2 string
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
LOCATION 's3://the-bucket-name/data/';

select * from test;

drop table if exists test;
DROP DATABASE if exists a_song_test;