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

    execute(s)


def insert_a(db_index, table, execute, val):
    author = str(val).replace("'", "")
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
