CREATE TABLE title_ratings
(
  tconst         VARCHAR(20) NOT NULL
    CONSTRAINT title_ratings_pkey
    PRIMARY KEY,
  average_rating INTEGER,
  num_votes      INTEGER
);

CREATE UNIQUE INDEX title_ratings_tconst_uindex
  ON title_ratings (tconst);