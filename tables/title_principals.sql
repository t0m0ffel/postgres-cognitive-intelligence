CREATE TABLE title_principals
(
  tconst         VARCHAR(30) NOT NULL
    CONSTRAINT title_principals_pkey
    PRIMARY KEY,
  principal_cast VARCHAR(255) []
);

CREATE UNIQUE INDEX title_principals_tconst_uindex
  ON title_principals (tconst);