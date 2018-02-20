# Basic script for importing imbd database
import gzip
import io
import os.path
import threading
import time
import urllib.request
from queue import Queue

import pandas as pd

from engine import engine
from imbd_specs import *
from postgres_config import is_db_existing
from psyscope_pool import create_tables, drop_tables

insert_thread_running = False
thread_queue = Queue()
db_data_directory = './db_data/'

if not is_db_existing():
    raise Exception('DB is not existing!')


def download_file(url):
    file_name = re.findall('.com/(.*?).tsv.gz', url)[0]
    print('Start downloading file', file_name, '...')
    if not os.path.isfile(db_data_directory + file_name):
        # Download file and unzip
        response = urllib.request.urlopen(url)
        compressed_file = io.BytesIO(response.read())
        decompressed_file = gzip.GzipFile(fileobj=compressed_file)

        print("Done downloading", file_name)
        with open(db_data_directory + file_name, 'wb') as outfile:
            outfile.write(decompressed_file.read())
    else:
        print("File already downloaded")


def insert_into_db(file_name):
    print("Reading csv", file_name)
    # Reading file with pandas
    columns = pd.read_sql(get_columns(get_table_name(file_name)), engine)
    if not columns.empty:
        columns_names = list(columns['column_name'])
        df = pd.read_csv(db_data_directory + file_name, sep='\t', skiprows=[0], header=None,
                         names=columns_names)
        print('CSV shape', df.shape)

        print("Done reading csv", file_name)

        # Preprocessing data
        data_type = columns['data_type']
        arrays_column = list(columns.loc[data_type == 'ARRAY']['column_name'])
        integer_columns = list(columns.loc[data_type == 'integer']['column_name'])
        boolean_columns = list(columns.loc[data_type == 'boolean']['column_name'])
        for array_column in arrays_column:
            df[array_column] = df[array_column].map(lambda x: str(x).split(','))

        for boolean_column in boolean_columns:
            df[boolean_column] = df[boolean_column].map(bool)

        for integer_column in integer_columns:
            df[integer_column] = pd.to_numeric(df[integer_column], errors='coerce')

        try:
            df = df[df[columns_names[0]] != ""]
        except:
            try:
                df = df[df[columns_names[0]] != None]
            except:
                pass

        print("Done preprocessing", file_name)
    else:
        # Fallback on default table
        df = pd.read_csv(db_data_directory + file_name, sep='\t', skiprows=None, header=0)
        print("Done reading csv", file_name)
    try:
        # Insert data to db
        df.to_sql(get_table_name(file_name), engine, if_exists='append', index=False,
                  chunksize=10000)
    except Exception as e:
        print(e)

    print("Done inserting", file_name)


class InsertFile(threading.Thread):
    def __init__(self, file_name):
        threading.Thread.__init__(self)
        self.file_name = file_name

    def run(self):
        global insert_thread_running
        insert_thread_running = True
        insert_into_db(self.file_name)
        insert_thread_running = False
        thread_queue.task_done()
        if not thread_queue.empty():
            thread_queue.get().start()


if __name__ == "__main__":
    start = time.time()
    drop_tables()
    create_tables()

    # download and insert parallel
    for url in urls:
        download_file(url)
        insert_thread = InsertFile(re.findall('.com/(.*?).tsv.gz', url)[0])
        thread_queue.put(insert_thread)
        if not insert_thread_running:
            thread_queue.get().start()

    print('Joining Queue')
    thread_queue.join()

    print("Finished in", time.time() - start)
