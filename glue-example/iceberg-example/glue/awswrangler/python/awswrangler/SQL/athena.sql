select * from awswrangler_iceberg_example_db.student;

select * from awswrangler_iceberg_example_db."student$snapshots";

select * from awswrangler_iceberg_example_db."student$history";


select * from awswrangler_iceberg_example_db.student FOR VERSION AS of
    2653918260013208066
order by id;

