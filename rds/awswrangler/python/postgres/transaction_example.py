import awswrangler as wr

if __name__ == '__main__':

    query = 'select * from public.student order by id;'

    with wr.postgresql.connect(secret_id='docker-secret') as con:
        df = wr.postgresql.read_sql_query(query, con=con)

    print('\nOriginal data')
    print(df)

    df['visit_count'] = df['visit_count'] + 1
    print()
    print('\nUpdated data')
    print(df)

    input("\nPress any key to update the database ...")

    with wr.postgresql.connect(secret_id='docker-secret') as con:
        wr.postgresql.to_sql(
            df=df,
            schema='public',
            table='student',
            mode='upsert',
            upsert_conflict_columns=['id'],
            con=con,
            use_column_names=True
        )

        # The default con.autocommit can change with different awswragler versions
        # 1. Call the commit() for safety
        # 2. If no active transaction, commit() does nothing
        con.commit()
