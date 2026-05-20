import psycopg

from db import CONSTR


def run():

    # Clear the table
    with psycopg.connect(CONSTR) as conn:
        conn.isolation_level = psycopg.IsolationLevel.SERIALIZABLE
        with conn.cursor() as cur:
            cur.execute('DELETE FROM public.student')

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
    print('The transaction isolation level can be set with psycopg.IsolationLevel.SERIALIZABLE')
    print(f'for example, psycopg.IsolationLevel.SERIALIZABLE = {psycopg.IsolationLevel.SERIALIZABLE}')

