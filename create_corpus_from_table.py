import re
import threading

from engine import execute
from imbd_specs import get_columns

# result = engine.execute(
#     "SELECT * FROM name_basics JOIN title_basics ON  tconst = ANY(know_for_titles) "
#     "LIMIT 1000")

ignorable_columns = ['nconst', 'title_id', 'tconst', 'birth_year', 'death_year', 'original_title']

corpus = './corpus/'

file_name = corpus + 'actor_movie_corpus_3.txt'


def tokenize1(column_name, value):
    value = value.replace(' ', '_')
    return " " + value.lower() + " "


def tokenize2(column_name, value):
    value = value.replace(' ', '_')
    column_name = column_name.lower()
    return " " + column_name + " " + value.lower() + " "


def tokenize3(column_name, value):
    value = value.replace(' ', '_')
    column_name = column_name.lower()
    if value == "NULL" or value == 'TRUE' or value == 'FALSE':
        return " {}_{} ".format(column_name, value)
    try:
        return " {}_{} ".format(column_name, int(value))
    except ValueError:
        pass

    return " " + value.lower() + " "


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


class ExtractRow(threading.Thread):
    def __init__(self, row, columns):
        threading.Thread.__init__(self)
        self.row = row
        self.columns = columns

    def run(self):
        with open(file_name, 'a') as file:
            file.write(delete_double_spaces(extract_row(self.row, self.columns)) + "\n")


# result = execute("SELECT * FROM {}".format(table_name))

def create_corpus(tokenize, file_name):
    file_name = corpus + file_name
    threads = []
    max_threads = 50
    length = 1
    chunk = 0
    chunk_size = 6000000
    with open(file_name, 'w') as file:
        file.write("")

    columns = []

    statements = ["""SELECT  
                          title,
                          year,
                          type,
                          keyword,
                          genre
                      FROM movies
                          LEFT JOIN movies_keywords ON movies_keywords.idmovies = movies.idmovies
                          LEFT JOIN keywords ON movies_keywords.idkeywords = keywords.idkeywords
                          LEFT JOIN movies_genres ON movies.idmovies = movies_genres.idmovies
                          LEFT JOIN genres ON movies_genres.idgenres = genres.idgenres""",

                  """SELECT   
                          actors.fname,
                          actors.lname,
                          billing_position,
                          title,
                          genre,
                          year,
                          character,
                          language
                        FROM actors
                          LEFT JOIN acted_in ON acted_in.idactors = actors.idactors
                          LEFT JOIN movies ON acted_in.idactors = actors.idactors
                          LEFT JOIN movies_genres ON movies.idmovies = movies_genres.idmovies
                          LEFT JOIN genres ON movies_genres.idgenres = genres.idgenres
                        WHERE title NOTNULL
                              AND fname NOTNULL
                              AND lname NOTNULL"""
                  ]
    s = 0
    for statement in statements:
        print("Executing statement ", s)
        s += 1
        # select entries in chunks to speed things up
        while length != 0:
            result = execute((statement + """ ORDER BY movies.idmovies LIMIT {} OFFSET {}""").format(
                chunk_size, chunk))
            if len(columns) == 0:
                columns = [col[0] for col in result.cursor.description]
            print("Done reading")

            length = result.rowcount
            print("Rowcount ", length)
            for i, row in enumerate(result):
                if i % (chunk_size / 2) == 0:
                    print(i, 'of', length)
                line = ""
                row = [item for item in row]
                # arbitrary selection of columns
                cols_of_interest = range(len(row))
                for index in cols_of_interest:
                    item = row[index]
                    if isinstance(item, list):
                        item = [tokenize(columns[index], str(e)) for e in item]
                        line += " ".join(item) + " "
                    else:
                        if item is None:
                            line += tokenize(columns[index], "NULL") + " "
                        else:
                            line += tokenize(columns[index], str(item)) + " "

                with open(file_name, 'a') as file:
                    file.write(delete_double_spaces(line + "\n"))

                    print(i, 'of', length)

            chunk = chunk + chunk_size
            print('Inserted entries', chunk)
