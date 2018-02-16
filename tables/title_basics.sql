CREATE TABLE title_basics
(
  tconst          VARCHAR(30) NOT NULL
    CONSTRAINT title_basics_tconst_pk
    PRIMARY KEY,
  title_type      TEXT,
  primary_title   TEXT,
  original_title  TEXT,
  is_adult        BOOLEAN,
  start_year      INTEGER,
  end_year        INTEGER,
  runtime_minutes INTEGER,
  genres          TEXT []
);

CREATE UNIQUE INDEX title_basics_tconst_uindex
  ON title_basics (tconst);