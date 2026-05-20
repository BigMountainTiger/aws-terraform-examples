import psycopg

from db import CONSTR


def run():

    sql = 'call public.upsert_student(%s, %s, %s, %s);'
    parms = (1, 'Song Li', 20, False)

    # Clear the table
    with psycopg.connect(CONSTR) as conn:
        with conn.cursor() as cur:
            cur.execute('DELETE FROM public.student')

    # Insert a row
    with psycopg.connect(CONSTR) as conn:
        with conn.cursor() as cur:
            cur.execute(sql, parms)

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
    print('psycopg 3, when used in the with context')
    print('1. a transaction is automatically committed if no exception')
    print('2. a transaction is automatically rolledback if there is an exception')
