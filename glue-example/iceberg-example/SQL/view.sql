-- AWS glue supports VIEWs
-- https://docs.aws.amazon.com/glue/latest/dg/catalog-views.html

-- Test data
-- 2_insert_data.py
-- 5_insert_data_ids_table.py


create or replace view iceberg_example.student_id_under_3 as 
select * from iceberg_example.student
where id in (
    select id from iceberg_example.ids_table
);

select * from iceberg_example.student_id_under_3
order by id;


DROP VIEW IF EXISTS iceberg_example.student_id_under_3;