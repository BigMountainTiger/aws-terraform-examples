from athena_client import AthenaClient

s3_bucket = "athena-sql-examples-huge-head-li"
client = AthenaClient(f"s3://{s3_bucket}/athena/")


sql = f"""
    with student_name as (
        SELECT * FROM (VALUES 
            (1, 'student 1'), 
            (2, 'student 2'), 
            (3, 'student 3')
        ) AS t(id, name)
    ),
    student_score as (
        SELECT * FROM (VALUES 
            (1, 90), 
            (2, 100), 
            (3, 100)
        ) AS t(id, score)
    )
    select sn.id, sn.name, ss.score 
    from student_name sn
        left join student_score ss on sn.id = ss.id;
"""

df = client.read_sql_query(sql=sql)
print(df)