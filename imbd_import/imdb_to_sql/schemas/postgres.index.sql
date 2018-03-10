-- acted_in
CREATE INDEX "ACTED_IN_IDSERIES_INDEX"
  ON acted_in USING BTREE (idseries);
CREATE INDEX "ACTED_IN_IDMOVIES_INDEX"
  ON acted_in USING BTREE (idmovies);
CREATE INDEX "ACTED_IN_IDACTORS_INDEX"
  ON acted_in USING BTREE (idactors);

-- actors
-- not sure how to do partial text searching

-- aka_names
CREATE INDEX "AKA_NAMES_IDACTORS_INDEX"
  ON aka_names USING BTREE (idactors);

-- aka_titles
CREATE INDEX "AKA_TITLES_IDMOVIES_INDEX"
  ON aka_titles USING BTREE (idmovies);

-- movies
-- same comment with actors about partial searching

-- series
CREATE INDEX "SERIES_IDMOVIES_INDEX"
  ON series USING BTREE (idmovies);

