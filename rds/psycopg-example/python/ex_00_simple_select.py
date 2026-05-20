import psycopg

from db import CONSTR


def run():
    sql = 'select * from public.student s;'

    with psycopg.connect(CONSTR) as conn:
        with conn.cursor() as cur:
            cur.execute(sql)
            result = cur.fetchall()

    return result


if __name__ == '__main__':

    result = run()
    print(result)
