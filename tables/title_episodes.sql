CREATE TABLE title_episode
(
  tconst         VARCHAR(20) NOT NULL
    CONSTRAINT title_episode_pkey
    PRIMARY KEY,
  parent_t_const TEXT,
  season_number  INTEGER,
  episode_number INTEGER
);
