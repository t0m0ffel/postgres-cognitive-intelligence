-- CREATE TYPE SIM_MOVIES AS
-- (
--   similarity    FLOAT,
--   movie MOVIES
-- );


CREATE OR REPLACE FUNCTION compare_keywords(movie1 MOVIES)
  RETURNS SETOF SIM_MOVIES
AS $$
import gensim
import numpy as np
from scipy import spatial
from numpy.linalg import norm
import operator

if not GD.has_key("model"):
    model = gensim.models.KeyedVectors.load(
        '/home/hendrik/PycharmProjects/postgres-cognitive-intelligence/models/model_corpus', mmap='r')
    GD['model'] = model
else:
    model = GD['model']


def main(movie1, _model):
    kw1 = plpy.execute("""SELECT keyword FROM movies m1
                        JOIN movies_keywords mk ON m1.idmovies = mk.idmovies
                        JOIN keywords k ON mk.idkeywords = k.idkeywords
                        WHERE m1.idmovies = """ + str(movie1["idmovies"]) + ";")
    kw2 = plpy.execute("""SELECT m1.* ,keyword FROM movies m1
                        JOIN movies_keywords mk ON m1.idmovies = mk.idmovies
                        JOIN keywords k ON mk.idkeywords = k.idkeywords
                        WHERE m1.idmovies != """ + str(movie1["idmovies"]) + ";")

    if len(kw1) == 0:
        plpy.notice('Movie has no keywords')
        return []
    vectors1 = np.array([_model.wv[k['keyword']] for k in kw1])
    mean_keywords1 = np.mean(vectors1, axis=0)

    word_dict = {}
    movie_dict = {}

    for index, k in enumerate(kw2):
        if not k['keyword'].isdigit():
            if word_dict.has_key(k['idmovies']):
                word_dict[k['idmovies']].append(k['keyword'])
            else:
                word_dict[k['idmovies']] = [k['keyword']]
                k.pop('keyword')
                movie_dict[k['idmovies']] = k

    movies, vectors = [], []
    for key in word_dict:
        vectors.append(np.mean([_model.wv[word] for word in word_dict[key]], axis=0))
        movies.append(movie_dict[key])

    similarities = np.array(gensim.models.KeyedVectors.cosine_similarities(mean_keywords1, np.array(vectors)))

    return zip(similarities, movies)


# plpy.notice(cos_sim)
for similarity, movie in main(movie1, model):
    plpy.notice(movie)
    yield similarity, movie
$$
LANGUAGE plpythonu;

-- SELECT m2
-- FROM movies m1, movies m2
-- WHERE m1.idmovies = 1511653 AND m2.idmovies = compare_keywords(m1);

-- SELECT m3.*
-- FROM
--   (
--     SELECT compare_keywords(_m1)
--     FROM movies _m1
--     WHERE _m1.idmovies = 45153
--     LIMIT 1
--   ) AS res, movies m3
-- WHERE m3.idmovies = ANY (replace(replace(replace(res :: TEXT, ')', ''), '(', ''), '"', '') :: INTEGER []);
--
--
-- CREATE FUNCTION get_sim_movies(INTEGER)
--   RETURNS SETOF MOVIES AS $$
--
-- SELECT m3.*
-- FROM
--   (
--     SELECT compare_keywords(_m1)
--     FROM movies _m1
--     WHERE _m1.idmovies = $1
--     LIMIT 1
--   ) AS res, movies m3
-- WHERE m3.idmovies = ANY (replace(replace(replace(res :: TEXT, ')', ''), '(', ''), '"', '') :: INTEGER []);
-- $$
-- LANGUAGE SQL;

-- SELECT m.*
-- FROM get_sim_movies(45153) AS m;

SELECT (c.movie).*, similarity
FROM movies _m1, compare_keywords(_m1) AS c
WHERE _m1.idmovies = 45153
ORDER BY c.similarity DESC
LIMIT 100;

-- --
SELECT
  m1.idmovies,
  m1.title,
  keyword
FROM movies m1
  JOIN movies_keywords mk ON m1.idmovies = mk.idmovies
  JOIN keywords k ON mk.idkeywords = k.idkeywords

WHERE m1.idmovies = 23636


SELECT
  m1.idmovies,
  m1.title,
  keyword
FROM movies m1
  JOIN movies_keywords mk ON m1.idmovies = mk.idmovies
  JOIN keywords k ON mk.idkeywords = k.idkeywords

WHERE  m1.idmovies = 256387
