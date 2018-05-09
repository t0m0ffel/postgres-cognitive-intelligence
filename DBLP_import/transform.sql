INSERT INTO author (
  SELECT DISTINCT ON (y.v)
    NEXTVAL('author_author_id_seq'),
    y.v,
    result.v
  FROM Pub x, Field y, Field result
  WHERE x.k = y.k AND y.k = result.k AND x.p = 'www' AND y.p = 'author' AND result.p = 'url'

);


INSERT INTO article (
  SELECT DISTINCT ON (y.k)
    NEXTVAL('article_pub_id_seq'),
    y.k
  FROM Pub x, Field y
  WHERE x.k = y.k  AND x.p = 'article'

);

INSERT INTO book (
  SELECT DISTINCT ON (y.k)
    NEXTVAL('book_pub_id_seq'),
    y.k
  FROM Pub x, Field y
  WHERE x.k = y.k  AND x.p = 'book'

);

INSERT INTO incollection (
  SELECT DISTINCT ON (y.k)
    NEXTVAL('incollection_pub_id_seq'),
    y.k
  FROM Pub x, Field y
  WHERE x.k = y.k  AND x.p = 'incollection'

);

INSERT INTO inproceedings (
  SELECT DISTINCT ON (y.k)
    NEXTVAL('inproceedings_pub_id_seq'),
    y.k
  FROM Pub x, Field y
  WHERE x.k = y.k  AND x.p = 'inproceedings'

);