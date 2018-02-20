import re
import threading

from engine import execute
from imbd_specs import get_columns

# result = engine.execute(
#     "SELECT * FROM name_basics JOIN title_basics ON  tconst = ANY(know_for_titles) "
#     "LIMIT 1000")
from train_vectors import train

ignorable_columns = ['nconst', 'title_id', 'tconst', 'birth_year', 'death_year', 'original_title']

corpus = './corpus/'

file_name = corpus + 'actor_movie_corpus_2.txt'


def tokenize1(column_name, value):
    value = value.replace(' ', '_')
    return " " + value.lower() + " "


def tokenize2(column_name, value):
    value = value.replace(' ', '_')
    column_name = column_name.lower()
    return " " + column_name + " " + value.lower() + " "


tokenize = tokenize2


def extract_row(row, columns):
    foreign_keys = {'know_for_titles': [('title_basics', 'tconst'), ('title_ratings', 'tconst')]}
    line = ""
    for column_name, column_type in columns:
        if column_name not in row or column_name in ignorable_columns:
            continue
        if column_name in foreign_keys:
            if isinstance(row[column_name], list) or isinstance(row[column_name], tuple):
                for key in row[column_name]:
                    for table, column_id in foreign_keys[column_name]:
                        res = execute("SELECT * FROM {} WHERE {} = '{}'".format(table, column_id, key))
                        cols = execute(get_columns(table)).fetchall()

                        for ro in res:
                            line += extract_row(ro, cols)
            else:
                key = row[column_name]
                for table, column_id in foreign_keys[column_name]:
                    res = execute("SELECT * FROM {} WHERE {} = '{}'".format(table, column_id, key))
                    cols = execute(get_columns(table)).fetchall()
                    for ro in res:
                        line += extract_row(ro, cols)
        else:
            if row[column_name] is None:
                line += tokenize(column_name, "NULL")
            else:
                if column_type == 'ARRAY':
                    line += " ".join([tokenize(column_name, str(val))
                                      for val in row[column_name]]) + " "
                else:
                    line += tokenize(column_name, (str(row[column_name])))
    return line


table_name = 'name_basics'


def delete_double_spaces(string):
    return re.sub(' +', ' ', string).lstrip()


threads = []
max_threads = 50


class ExtractRow(threading.Thread):
    def __init__(self, row, columns):
        threading.Thread.__init__(self)
        self.row = row
        self.columns = columns

    def run(self):
        with open(file_name, 'a') as file:
            file.write(delete_double_spaces(extract_row(self.row, self.columns)) + "\n")


# result = execute("SELECT * FROM {}".format(table_name))


length = 1
chunk = 0
chunk_size = 600000
with open(file_name, 'w') as file:
    file.write("")
# select entries in chunks to speed things up
while length != 0:
    result = execute(
        "SELECT * FROM name_basics JOIN title_basics ON  tconst = ANY(know_for_titles) ORDER BY nconst"
        " LIMIT {} OFFSET {}".format(
            chunk_size, chunk))

    print("Done reading")

    length = result.rowcount
    print("Rowcount ", length)
    columns = execute(get_columns(table_name)).fetchall()
    for i, row in enumerate(result):

        # thread = ExtractRow(row, columns)
        # threads.append(thread)
        # thread.start()
        if i % 100000 == 0:
            print(i, 'of', length)
        line = ""
        row = [item for item in row]
        for index in [1, 2, 3, 4, 7, 8, 9, 10, 11, 12]:
            item = row[index]
            if isinstance(item, list):
                item = [tokenize("", str(e)) for e in item]
                line += " ".join(item) + " "
            else:
                if item is None:
                    line += tokenize("", "NULL") + " "
                else:
                    line += tokenize("", str(item)) + " "

        with open(file_name, 'a') as file:
            file.write(delete_double_spaces(line + "\n"))

        if len(threads) >= max_threads:
            for thread in threads:
                thread.join()
            threads = []

            print(i, 'of', length)

    if len(threads) > 0:
        for thread in threads:
            thread.join()
    chunk = chunk + chunk_size
    print('Inserted entries', chunk)

train()
