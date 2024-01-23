import psycopg

from db import CONSTR


def run():

    sql = 'call public.upsert_student(%s, %s, %s, %s);'
    parms = (1, 'Song Li', 20, False)

    # Clear the table
    with psycopg.connect(CONSTR) as conn:
        with conn.cursor() as cur:
            cur.execute('DELETE FROM public.student')

    # Insert data
    try:
        with psycopg.connect(CONSTR) as conn:
            print(f'By default, conn.autocommit = {conn.autocommit}')
            conn.autocommit = True
            with conn.cursor() as cur:
                cur.execute(sql, (1, 'Song Li', 100, True))
                cur.execute(sql, (2, 'Joe Biden', 20, False))

            raise Exception('Artificial exception')
    except Exception as ex:
        print(ex)
        print('Even with the exception, the sql commands are committed')

    # Select the row
    with psycopg.connect(CONSTR) as conn:
        with conn.cursor() as cur:
            cur.execute('SELECT * FROM public.student')
            result = cur.fetchall()

    return result


if __name__ == '__main__':

    result = run()
    print(result)

    print()
    print('With conn.autocommit = True, each SQL query command is its own transaction, no commit() needed')
