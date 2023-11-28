import psycopg2

CONSTR = 'postgres://postgres:docker@localhost:5432/postgres'


def run():

    # %s for all data types - https://www.psycopg.org/psycopg3/docs/basic/params.html
    sql = 'call public.upsert_student(%s, %s, %s, %s);'

    try:
        conn = None
        conn = psycopg2.connect(CONSTR)

        print(f'Default autocommit is {conn.autocommit}')

        cur = conn.cursor()

        cur.execute(sql, (1, 'Sonng Li', 100, True))
        cur.execute(sql, (2, 'Joe Biden', 80, False))

        # Commit is required even calling a procedure
        conn.commit()

        cur.close()

    except (Exception, psycopg2.DatabaseError) as error:
        print(error)

    finally:
        if conn is not None:
            conn.close()

    print('Done')


if __name__ == '__main__':
    run()
