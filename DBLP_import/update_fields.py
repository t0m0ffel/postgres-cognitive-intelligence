from engine import execute
import threading
from DBLP_import.insert import insert, insert_a


def clean_db():
    execute("""DELETE FROM article WHERE TRUE ;
DELETE FROM book WHERE TRUE ;
DELETE FROM incollection WHERE TRUE ;
DELETE FROM inproceedings WHERE TRUE ;
DELETE FROM article_author WHERE TRUE ;

DELETE FROM article_author WHERE TRUE ;
DELETE FROM book_author WHERE TRUE ;
DELETE FROM incollection_author WHERE TRUE ;
DELETE FROM inproceedings_author WHERE TRUE ;

ALTER SEQUENCE article_pub_id_seq RESTART 1;
ALTER SEQUENCE book_pub_id_seq RESTART 1;
ALTER SEQUENCE incollection_pub_id_seq RESTART 1;
ALTER SEQUENCE inproceedings_pub_id_seq RESTART 1;


DELETE FROM author WHERE TRUE ;
ALTER SEQUENCE author_author_id_seq RESTART 1;

INSERT INTO author (
  SELECT DISTINCT ON (y.v)
    NEXTVAL('author_author_id_seq'),
    y.v,
    result.v
  FROM Pub x, Field y, Field result
  WHERE x.k = y.k AND y.k = result.k AND x.p = 'www' AND y.p = 'author' AND result.p = 'url'

);
""")
    print("Done Cleaning DB...")


if __name__ == '__main__':

    tables = [
        'article',
        'book',
        'incollection',
        'inproceedings'
    ]

    update_table = ["""UPDATE article
    SET
      title = '{}',
      year = '{}',
      month = '{}',
      volume = '{}',
      journal = '{}',
      number = '{}'""",
                    """UPDATE book
                    SET
                      title = '{}',
                      year = '{}',
                      isbn = '{}',
                      publisher = '{}'""",
                    """UPDATE incollection
    SET
      title ='{}',
      year = '{}',
      isbn = '{}',
      booktitle = '{}'""",
                    """UPDATE inproceedings
                        SET
                          title = '{}',
                          year = '{}',
                          isbn ='{}',
                          booktitle = '{}',
                          editor = '{}'"""]

    fields = [
        ['pub_id', 'pub_key', 'title', 'year', 'month', 'volume', 'journal', 'number'],
        ['pub_id', 'pub_key', 'title', 'year', 'isbn', 'publisher'],
        ['pub_id', 'pub_key', 'title', 'year', 'isbn', 'booktitle'],
        ['pub_id', 'pub_key', 'title', 'year', 'isbn', 'booktitle', 'editor']
    ]
    clean_db()
    max_threads = 75


    class Insert(threading.Thread):
        def __init__(self, execute, tn, fields, table, current_dict, current_pub_id, db_index):
            threading.Thread.__init__(self)
            self.execute = execute
            self.tn = tn
            self.fields = fields
            self.table = table
            self.current_dict = current_dict
            self.current_pub_id = current_pub_id
            self.db_index = db_index

        def run(self):
            insert(execute=self.execute, tn=self.tn, fields=self.fields, table=self.table,
                   current_dict=self.current_dict, current_pub_id=self.current_pub_id, db_index=self.db_index)


    class InsertA(threading.Thread):
        def __init__(self, db_index, table, execute, val):
            threading.Thread.__init__(self)
            self.db_index = db_index
            self.table = table
            self.execute = execute
            self.val = val

        def run(self):
            insert_a(self.db_index, self.table, self.execute, self.val)


    threads = []

    for tn, table in enumerate(tables):

        result = execute(
            "SELECT field.* FROM field, pub WHERE pub.k=field.k AND pub.p= '{}' ORDER BY field.k".format(table))

        length = result.rowcount
        print("Read result for", table, "length", length)
        current_pub_id = ''
        db_index = 0

        current_dict = {}
        values = []
        for i, r in enumerate(result):

            if i % 1000 == 0:
                print('table', table, 'i', i, 'of', length)
                print("number of threads:", len(threads))
            if len(threads) > max_threads:
                threads = [t for t in threads if t.isAlive()]
                if len(threads) > max_threads:
                    print("Joining threads")
                    for thread in threads:
                        thread.join()
                    threads = []

            pub_id = r.k
            if current_pub_id == '':
                (db_index,) = execute("SELECT  NEXTVAL('{}_pub_id_seq')".format(table))
                current_pub_id = pub_id
            if current_pub_id != '' and current_pub_id != pub_id:
                db_insert = Insert(execute, tn, fields, table, current_dict, current_pub_id, db_index)
                db_insert.start()
                threads.append(db_insert)

                current_dict = {}
                current_pub_id = pub_id
                (db_index,) = execute("SELECT  NEXTVAL('{}_pub_id_seq')".format(table))

            if r.p in fields[tn]:
                current_dict[r.p] = r.v

            if r.p == 'author':
                db_insert = InsertA(db_index, table, execute, r.v)
                db_insert.start()
                threads.append(db_insert)
