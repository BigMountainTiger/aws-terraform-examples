import json
import psycopg2
from utilities.conn_util_sm import get_conn_string

def lambdaHandler(event, context):

    sql_1 = {
        'text': 'select * from public.get_students()',
        'params': ()
    }

    sql_2 = {
        'text': 'select * from public.get_a_student(%s)',
        'params': (1,)
    }

    sql = sql_2

    rows = []
    try:
        conn_str = get_conn_string(
            'rds-postgres-example', 'experiment')

        conn = psycopg2.connect(conn_str)
        cur = conn.cursor()
        cur.execute(sql.get('text'), sql.get('params'))

        rows = cur.fetchall()
        cur.close()

    except:
        get_conn_string.cache_clear()
        raise

    finally:
        if conn is not None:
            conn.close()

    print(rows)

    return {
        'statusCode': 200,
        'body': json.dumps(rows)
    }
