import psycopg2

user = 'postgres'
password = 'A12345678'
host = 'experiment-postgres.cfa5drybscc2.us-east-1.rds.amazonaws.com'
port = 5432
database = 'postgres'

def run():

    update_password(password, password)
    valid = password_is_valid(password)

    print(f'password is valid - {valid}')


def update_password(current_password, new_password):
    try:
        conn = get_connection(current_password)
        cur = conn.cursor()
        cur.execute(
            f"ALTER USER {user} WITH ENCRYPTED PASSWORD '{new_password}'")
        conn.commit()

    finally:
        if conn:
            conn.close()


def password_is_valid(password):
    if not password:
        return False

    try:
        conn = get_connection(password)
    finally:
        if conn:
            conn.close()

    return True if conn else False


def get_connection(password):
    constr = f'postgres://{user}:{password}@{host}:{port}/{database}'

    try:
        conn = psycopg2.connect(constr)
    except Exception as e:
        print(e)
        conn = None

    return conn


if __name__ == '__main__':
    run()
