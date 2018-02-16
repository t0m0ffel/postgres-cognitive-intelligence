CREATE TABLE title_akas
(
  title_id         VARCHAR(30) NOT NULL,
  ordering         INTEGER,
  title            TEXT,
  region           VARCHAR(255),
  language         VARCHAR(255),
  types            VARCHAR(255),
  attributes       TEXT,
  is_orginal_title INTEGER
);

