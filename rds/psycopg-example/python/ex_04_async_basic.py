# https://www.psycopg.org/psycopg3/docs/advanced/async.html#async

import asyncio
from psycopg import AsyncConnection as ac

from db import CONSTR


async def run():

    sql = 'call public.upsert_student(%s, %s, %s, %s);'
    parms_1 = (1, 'Song Li', 100, True)
    parms_2 = (2, 'Joe Biden', 20, False)

    # Clear the table
    async with await ac.connect(CONSTR) as conn:
        async with conn.cursor() as cur:
            await cur.execute('DELETE FROM public.student')

    print(f'Connection is closed once exits the context block = {conn.closed}')

    # Insert some data
    async with await ac.connect(CONSTR) as conn:
        async with conn.cursor() as cur:
            await cur.execute(sql, parms_1)
            await cur.execute(sql, parms_2)

    # async with has to be in an async function
    async with await ac.connect(CONSTR) as conn:
        async with conn.cursor() as cur:
            await cur.execute('select * from public.student s;')
            result = await cur.fetchall()

    return result


if __name__ == '__main__':

    result = asyncio.run(run())
    print(result)

    print()
    print('It looks like that the AsyncConnection behaves similarly to the non-async psycopg')
