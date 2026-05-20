import psycopg2
import pandas as pd

CONSTR = 'postgres://postgres:docker@localhost:5432/postgres'


def run():
    # If the result set is large, fetchmany can be used to fetch a limited number of rows at a time
    # https://www.psycopg.org/psycopg3/docs/cursor.html#fetching-rows
    # This can reduce memory usage and improve performance when processing large datasets.

    with psycopg2.connect(CONSTR) as conn:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM public.example")
            columns = [desc[0] for desc in cursor.description]

            batch_size = 5
            batch_number = 0
            while True:
                result = cursor.fetchmany(batch_size)
                if not result:
                    break

                df = pd.DataFrame(result, columns=columns)
                batch_number += 1
                print(f'Batch {batch_number}:')
                print(df)
                print()


if __name__ == "__main__":
    run()
    print('Done')
