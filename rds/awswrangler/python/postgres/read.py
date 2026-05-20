import awswrangler as wr

query = 'select * from public.student;'


def read_to_cursor():
    print('Read to cursor')

    try:
        con = wr.postgresql.connect(secret_id='docker-secret')
        with con.cursor() as cursor:
            cursor.execute(query)
            data = cursor.fetchall()

    finally:
        # This makes sure the con is always closed
        if con is not None:
            con.close()

    print(len(data))
    print(data)


def read_to_dataframe():
    print('Read to dataframe')

    try:
        con = wr.postgresql.connect(secret_id='docker-secret')
        df = wr.postgresql.read_sql_query(query, con=con)

    finally:
        if con is not None:
            con.close()

    print(df)


if __name__ == '__main__':
    read_to_cursor()

    print()
    read_to_dataframe()
