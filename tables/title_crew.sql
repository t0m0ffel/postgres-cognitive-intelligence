CREATE TABLE title_crew
(
  tconst    VARCHAR(30) NOT NULL
    CONSTRAINT title_crew_pkey
    PRIMARY KEY,
  directors TEXT [],
  writers   TEXT []
);

CREATE UNIQUE INDEX title_crew_tconst_uindex
  ON title_crew (tconst);