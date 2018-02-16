CREATE TABLE name_basics
(
  nconst             VARCHAR(20) NOT NULL
    CONSTRAINT name_basics_nconst_pk
    PRIMARY KEY,
  primary_name       VARCHAR(200),
  birth_year         INTEGER,
  death_year         INTEGER,
  primary_profession TEXT [],
  know_for_titles    TEXT []
);

CREATE UNIQUE INDEX name_basics_nconst_uindex
  ON name_basics (nconst);