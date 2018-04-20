-- SELECT
--   title.title,
--   aka_title.title,
--   kind_type.kind
-- FROM title
--   JOIN aka_title ON title.id = aka_title.movie_id
--   JOIN kind_type ON title.kind_id = kind_type.id
-- WHERE aka_title.movie_id = 317578;
--
--
-- SELECT
--   title.title,
--   keyword.keyword
-- FROM title
--   JOIN movie_keyword ON title.id = movie_keyword.movie_id
--   JOIN keyword ON movie_keyword.keyword_id = keyword.id
-- WHERE title.id = 317578;
--
--
-- SELECT
--   title.title,
--   movie_info.info,
--   movie_info.note
-- FROM title
--   JOIN movie_info ON movie_info.movie_id = title.id
-- WHERE title.id = 317578;
--
-- CREATE TYPE SIM_MOVIES AS
-- (
--   similarity FLOAT,
--   title      TITLE
-- );


CREATE OR REPLACE FUNCTION find_similar_title(title1 TITLE, title2 TITLE)
  RETURNS FLOAT
AS $$
import gensim
import numpy as np
from scipy import spatial
from numpy.linalg import norm
import operator
import re

if not GD.has_key("model"):
    model = gensim.models.KeyedVectors.load(
        '/home/cziommer/postgres-cognitive-intelligence/models/fixed_corpus_gensim_model_ws100', mmap='r')
    GD['model'] = model
else:
    model = GD['model']

statements = [
    """SELECT
          title.title,
          aka_title.title,
          kind_type.kind
        FROM title
          JOIN aka_title ON title.id = aka_title.movie_id
           JOIN kind_type ON title.kind_id = kind_type.id
        WHERE aka_title.movie_id = {};""",
    """SELECT
        keyword.keyword
      FROM title
        JOIN movie_keyword ON title.id = movie_keyword.movie_id
        JOIN keyword ON movie_keyword.keyword_id = keyword.id
      WHERE title.id  = {};""",
    """SELECT
        movie_info.info,
        movie_info.note
      FROM title
        JOIN movie_info ON movie_info.movie_id = title.id
      WHERE title.id  = {};"""
]


def t(column_name, value):
    column_name = column_name.lower()

    if value is None:
        value = 'NULL'

    if value == "NULL" or value == 'TRUE' or value == 'FALSE':
        return " {}_{} ".format(column_name, value)

    value = value.replace(' ', '_')
    try:
        intval = int(value)
        return " {}_{} ".format(column_name, intval)
    except ValueError:
        pass

    return re.sub(' +', ' ', value.lower()).lstrip()


def get_mean_vector(_model, _id):
    vectors = []
    for statement in statements:
        results = plpy.execute(statement.format(_id))
        plpy.notice(results)
        result_vectors = []
        for result in results:
            current_v = []
            for key in result:

                token = t(key, result[key])
                try:
                    current_v.append(_model[token])
                except KeyError:
                    plpy.notice('token not in corpus')
                    plpy.notice(token + ' for movie ' + str(_id) + ' key ' + key)
            if len(current_v) > 0:
                result_vectors.append(np.mean(current_v, axis=0))

        # plpy.notice('result_vectors',result_vectors)
        result_vectors = [v for v in result_vectors if not np.all(v == 0)]

        plpy.notice('vectors', vectors)
        if len(result_vectors) > 0:
            vectors.append(np.mean(result_vectors, axis=0))

    if len(vectors) == 0:
        return np.zeros(300)
    mean_vector = np.mean(vectors, axis=0)

    if np.any(np.isnan(mean_vector)):
        return np.zeros(300)

    else:
        ##plpy.notice('----------')
        ##plpy.notice(mean_vector)
        ###plpy.notice(np.around(mean_vector, decimals=3))
        return np.around(mean_vector, decimals=3)


# similarities = np.array(gensim.models.KeyedVectors.cosine_similarities(mean_keywords1, np.array(vectors)))

# return zip(similarities, movies)


from sklearn.metrics.pairwise import cosine_similarity


def cos_sim(a, b):
    """Takes 2 vectors a, b and returns the cosine similarity according
    to the definition of the dot product
    """
    dot_product = np.dot(a, b)
    norm_a = np.linalg.norm(a)
    norm_b = np.linalg.norm(b)
    return dot_product / (norm_a * norm_b)


def main(_model):
    plpy.notice(title1['id'])
    plpy.notice(title2['id'])
    v1 = get_mean_vector(model, title1['id'])
    v2 = get_mean_vector(model, title2['id'])
    if np.all(v1 == 0) or np.all(v2 == 0):
        plpy.info('All values are zero!')
        return -1

    try:
        return np.around(cos_sim(v1, v2), decimals=3)
    except:
        plpy.info('Error while cos_sim')
        return -1


return main(model)

# for similarity, movie in main(title, model):
#     ###plpy.notice(movie)
#     yield similarity, movie
$$
LANGUAGE plpythonu;


SELECT
  find_similar_title(t1, t2),
  t1.id,
  t1.title,
  t2.id,
  t2.title
FROM title t1, title t2
WHERE t1.id = any (ARRAY[3765702,4353456,3765717,933484,3702144,3375613])
AND t2.id= any (ARRAY[3765702,4353456,3765717,933484,3702144,3375613])
AND t1.id<=t2.id
;
