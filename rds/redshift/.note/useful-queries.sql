-- Get a range of days
SELECT TRUNC(DATEADD('day', 1 - ROW_NUMBER() OVER (), '2024-12-03')) as d
FROM a_table_has_enough_rows
limit 365;

-- Check query history
-- https://docs.aws.amazon.com/redshift/latest/dg/r_STL_QUERY.html
select * from STL_QUERY limit 10;
select * from STL_QUERYTEXT limit 10;
select * from STL_DDLTEXT limit 10;
select * from STL_UTILITYTEXT limit 10;
select * from SVL_STATEMENTTEXT limit 10; 

-- Table information
-- https://docs.aws.amazon.com/redshift/latest/dg/r_SVV_TABLE_INFO.html
select * from SVV_TABLE_INFO limit 10; 