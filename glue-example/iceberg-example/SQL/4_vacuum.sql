VACUUM iceberg_example.student;

-- verify the snapshots after vacuum
select * from iceberg_example."student$snapshots"
order by committed_at;

-- Range [60, 9223372036854775807]
ALTER TABLE iceberg_example.student
SET TBLPROPERTIES ('vacuum_max_snapshot_age_seconds'='60');

-- Set to 1 for test purpose
ALTER TABLE iceberg_example.student
SET TBLPROPERTIES ('vacuum_min_snapshots_to_keep'='1');