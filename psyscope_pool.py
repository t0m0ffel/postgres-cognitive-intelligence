import os

import psycopg2
from psycopg2 import pool

from postgres_config import conf_dbname, conf_dbpassword, conf_dbport, conf_dbuser, conf_hostname


def get_pool(connections=1):
    return psycopg2.pool.SimpleConnectionPool(connections, connections, host=conf_hostname, database=conf_dbname,
                                              user=conf_dbuser, password=conf_dbpassword, port=conf_dbport)


def create_tables():
    table_dir = './tables/'
    tables = os.listdir(table_dir)
    table_count = len(tables)

    db = get_pool(table_count)

    for filename in tables:
        with open(table_dir + filename) as SQLQuery:
            con = db.getconn()
            cur = con.cursor()
            cur.execute(SQLQuery.read())
            con.commit()


def drop_tables():
    db = get_pool()
    con = db.getconn()
    with open('./drop_tables.sql') as SQLQuery:
        cur = con.cursor()
        cur.execute(SQLQuery.read())
        con.commit()
