
CREATE TABLE pub
(
  k TEXT,
  p TEXT
);

CREATE TABLE field
(
  k TEXT,
  i TEXT,
  p TEXT,
  v TEXT
);

CREATE TABLE author
(
  author_id       BIGSERIAL
    CONSTRAINT author_author_id_pk
    UNIQUE,
  author_name     TEXT,
  author_homepage TEXT
);

CREATE UNIQUE INDEX author_author_name_uindex
  ON author (author_name);

CREATE INDEX author_author_id_index
  ON author (author_id);

CREATE TABLE article_author
(
  pub_id    BIGINT,
  author_id BIGINT
);

CREATE TABLE book_author
(
  pub_id    BIGINT,
  author_id BIGINT
);

CREATE TABLE incollection_author
(
  pub_id    BIGINT,
  author_id BIGINT
);

CREATE TABLE inproceedings_author
(
  author_id BIGINT,
  pub_id    BIGINT
);

CREATE TABLE article
(
  pub_id  BIGSERIAL NOT NULL,
  pub_key TEXT,
  title   TEXT,
  year    TEXT,
  journal TEXT,
  month   TEXT,
  volume  TEXT,
  number  TEXT
);

CREATE UNIQUE INDEX article_pub_id_uindex
  ON article (pub_id);

CREATE TABLE book
(
  pub_id    BIGSERIAL NOT NULL,
  pub_key   TEXT,
  title     TEXT,
  year      TEXT,
  publisher TEXT,
  isbn      TEXT
);

CREATE UNIQUE INDEX book_pub_id_uindex
  ON book (pub_id);

CREATE TABLE incollection
(
  pub_id    BIGSERIAL NOT NULL,
  pub_key   VARCHAR(255),
  title     TEXT,
  year      VARCHAR(255),
  booktitle TEXT,
  publisher TEXT,
  isbn      TEXT
);

CREATE UNIQUE INDEX incollection_pub_id_uindex
  ON incollection (pub_id);

CREATE TABLE inproceedings
(
  pub_id    BIGSERIAL NOT NULL,
  pub_key   VARCHAR(255),
  title     TEXT,
  year      VARCHAR(255),
  booktitle TEXT,
  editor    TEXT,
  isbn      TEXT
);

CREATE UNIQUE INDEX inproceedings_pub_id_uindex
  ON inproceedings (pub_id);



copy Pub from '/home/hendrik/PycharmProjects/postgres-cognitive-intelligence/DBLP_import/hw1/pubFile.txt';
copy Field from '/home/hendrik/PycharmProjects/postgres-cognitive-intelligence/DBLP_import/hw1/fieldFile.txt';





