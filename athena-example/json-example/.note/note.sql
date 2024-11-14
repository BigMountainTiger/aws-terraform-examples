-- We can create glue tables by SQL

-- Single line json
CREATE EXTERNAL TABLE test(
    field_1 string,
    field_2 string
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
LOCATION 's3://athena-bucket-huge-head-li/data/';


-- multiple line json
-- https://docs.aws.amazon.com/athena/latest/ug/json-serde.html
-- https://docs.aws.amazon.com/athena/latest/ug/querying-JSON.html
-- Empty lines are allowed in the data
CREATE EXTERNAL TABLE test(
    field_1 string,
    field_2 string
)
STORED AS ION
LOCATION 's3://athena-bucket-huge-head-li/data/';


DROP TABLE if exists test;

select * from test;

-- json_extract and json_extract_scalar only work for JsonSerDe
select field_1, json_extract(field_2, '$') as field_2_a from test;
select field_1, json_extract_scalar(field_2, '$.a') as field_2_a from test;