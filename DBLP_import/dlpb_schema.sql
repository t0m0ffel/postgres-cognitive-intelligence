-- CREATE TABLE author
-- (
--   author_id       BIGSERIAL
--     CONSTRAINT author_author_id_pk
--     UNIQUE,
--   author_name     TEXT,
--   author_homepage TEXT
-- );
--
-- CREATE UNIQUE INDEX author_author_name_uindex
--   ON author (author_name);
--
-- CREATE INDEX author_author_id_index
--   ON author (author_id);

CREATE TABLE article
(
  pub_id  BIGSERIAL,
  pub_key VARCHAR(255),
  title   VARCHAR(255),
  year    VARCHAR(255),
  journal VARCHAR(255),
  month   VARCHAR(255),
  volume  VARCHAR(255),
  number  VARCHAR(255)
);

CREATE UNIQUE INDEX article_pub_id_uindex
  ON article (pub_id);

CREATE TABLE book
(
  pub_id    BIGSERIAL,
  pub_key   VARCHAR(255),
  title     VARCHAR(255),
  year      VARCHAR(255),
  publisher VARCHAR(255),
  isbn      VARCHAR(255)
);

CREATE UNIQUE INDEX book_pub_id_uindex
  ON book (pub_id);

CREATE TABLE incollection
(
  pub_id    BIGSERIAL,
  pub_key   VARCHAR(255),
  title     VARCHAR(255),
  year      VARCHAR(255),
  booktitle TEXT,
  publisher TEXT,
  isbn      VARCHAR(255)
);

CREATE UNIQUE INDEX incollection_pub_id_uindex
  ON incollection (pub_id);


CREATE TABLE inproceedings
(
  pub_id    BIGSERIAL,
  pub_key   VARCHAR(255),
  title     VARCHAR(255),
  year      VARCHAR(255),
  booktitle TEXT,
  editor    TEXT,
  isbn      VARCHAR(255)
);

CREATE UNIQUE INDEX inproceedings_pub_id_uindex
  ON inproceedings (pub_id);

