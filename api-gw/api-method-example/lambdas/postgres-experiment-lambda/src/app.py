import json
import psycopg2
import urllib
from utilities.conn_util_iam import get_conn_dict


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
        d = get_conn_dict(
            'rds-postgres-example', 'experiment')

        print(json.dumps(d))
        print()

        username = d.get('USER')
        password_encoded = urllib.parse.quote_plus(d.get('TOKEN'))
        endpoint_address = d.get('ENDPOINT')
        endpoint_port = d.get('PORT')
        db_name = d.get('DBNAME')
        conn_str = f'postgres://{username}:{password_encoded}@{endpoint_address}:{endpoint_port}/{db_name}'

        conn = psycopg2.connect(conn_str)
        # conn = psycopg2.connect(host=d.get('ENDPOINT'), port=d.get('PORT'), database=d.get(
        #     'DBNAME'), user=d.get('USER'), password=d.get('TOKEN'))
        
        cur = conn.cursor()
        cur.execute(sql.get('text'), sql.get('params'))

        rows = cur.fetchall()
        cur.close()

    except:
        get_conn_dict.cache_clear()
        raise

    finally:
        if conn is not None:
            conn.close()

    print(rows)

    return {
        'statusCode': 200,
        'body': json.dumps(rows)
    }
