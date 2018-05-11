from engine import execute

authors = execute('SELECT author_id, author_name FROM author')

author_dict = {}

for _author in authors:
    author_dict[_author.author_name] = _author.author_id


def insert(execute, tn, fields, table, current_dict,
           current_pub_id, db_index):
    values = [db_index[0], current_pub_id]
    for field in fields[tn][2:]:
        if field in current_dict:
            values.append(current_dict[field].replace('"', '').replace("'", ""))
        else:
            values.append('')

    s = "INSERT INTO {} {}  VALUES {}".format(table, str(tuple(fields[tn])).replace("'", ""), tuple(values))
    s = s.replace("%", "%%")

    # execute(s)
    open("file", "a").write(s + ";\n")


def insert_a(db_index, table, execute, val):
    author = str(val).replace("'", "")

    if author in author_dict:
        author_id = [author_dict[author]]
    else:
        try:
            (author_id,) = execute(
                "SELECT author_id FROM author WHERE author.author_name = '{}'".format(author))
        except:
            try:
                execute("INSERT INTO author (author_name, author_homepage) VALUES ('{}',NULL)".format(author))
                (author_id,) = execute(
                    "SELECT author_id FROM author WHERE author.author_name = '{}'".format(author))
            except:
                (author_id,) = execute(
                    "SELECT author_id FROM author WHERE author.author_name = '{}'".format(author))

    execute("INSERT INTO {}_author (pub_id,author_id) values ({},{})".format(table, db_index[0], author_id[0]))
