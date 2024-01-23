# https://medium.com/@benshearlaw/asynchronous-postgres-with-python-fastapi-and-psycopg-3-fafa5faa2c08

import asyncio
from psycopg_pool import AsyncConnectionPool

from db import CONSTR


async def run():
    # Async connection pool has to be created in an asyncio loop
    async_pool = AsyncConnectionPool(conninfo=CONSTR)

    sql = 'select * from public.student s;'

    # async with has to be in a async function
    async with async_pool.connection() as conn:
        async with conn.cursor() as cur:
            await cur.execute(sql)
            result = await cur.fetchall()

    await async_pool.close()
    return result


if __name__ == '__main__':

    result = asyncio.run(run())
    print(result)
