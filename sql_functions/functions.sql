CREATE OR REPLACE LANGUAGE plpythonu;

CREATE OR REPLACE FUNCTION average_similarity(words1 VARCHAR [], words2 VARCHAR [])
  RETURNS FLOAT
AS $$

import gensim


def tokenize(value):
    return value.replace(' ', '_').lower()


def main(words, GD):
    if not GD.has_key("model"):
        #    raise Exception('No model was loaded! Please load a model via load_model(path) function!')
        GD['model'] = gensim.models.KeyedVectors.load_word2vec_format(
            '/home/hendrik/PycharmProjects/postgres-cognitive-intelligence/models/corpus_model_skipgram.vec')
    model = GD['model']

    sum_sim = 0
    for word1, word2 in words:

        #plpy.notice(word1, word2, sum_sim / len(words))
        try:
            sum_sim += model.similarity(tokenize(word1), tokenize(word2))
        except:
            return 0

        plpy.notice(word1, word2, sum_sim / len(words))

    return sum_sim / len(words)


return main(zip(words1, words2), GD)
$$
LANGUAGE plpythonu;

CREATE OR REPLACE FUNCTION load_model(path VARCHAR(255))
  RETURNS VARCHAR []
AS $$
from gensim.models.wrappers.fasttext import FastText


def main(path, GD):
    GD['model'] = FastText.load_fasttext_format(path)


main(path, GD)
$$
LANGUAGE plpythonu;

CREATE OR REPLACE FUNCTION max_similarity(words1 VARCHAR [], words2 VARCHAR [])
  RETURNS FLOAT
AS $$
def tokenize(value):
    return value.replace(' ', '_').lower()


def main(words, GD):
    if not GD.has_key("model"):
        raise Exception('No model was loaded! Please load a model via load_model(path) function!')
    model = GD['model']
    try:
        return max([model.similarity(tokenize(word1), tokenize(word2)) for word1, word2 in words])

    except:
        return 0


# model.wv.similarity('woman', 'man')

return main(zip(words1, words2), GD)
$$
LANGUAGE plpythonu;

CREATE OR REPLACE FUNCTION load_model(path VARCHAR(255))
  RETURNS VARCHAR []
AS $$
import gensim


def main(path, GD):
    GD['model'] = gensim.models.KeyedVectors.load_word2vec_format(path, limit=1000000)


main(path, GD)
$$
LANGUAGE plpythonu;


CREATE OR REPLACE FUNCTION compare_keywords(movie1 MOVIES)
  RETURNS INTEGER []
AS $$
import gensim
import numpy as np
from scipy import spatial
from numpy import dot
from numpy.linalg import norm
import operator

if not GD.has_key("model"):
    model = gensim.models.KeyedVectors.load(
        '/home/hendrik/PycharmProjects/postgres-cognitive-intelligence/models/model_corpus', mmap='r')
    GD['model'] = model
else:
    model = GD['model']


def most_sim(word_dict, _model, mean_keywords1):
    movie_ids, vectors = [], []
    for key in word_dict:
        vectors.append(np.mean([_model.wv[word] for word in word_dict[key]], axis=0))
        movie_ids.append(key)
    return np.array(gensim.models.KeyedVectors.cosine_similarities(mean_keywords1, np.array(vectors)))


def main(movie1, _model):
    kw1 = plpy.execute("""SELECT keyword FROM movies m1
                        JOIN movies_keywords mk ON m1.idmovies = mk.idmovies
                        JOIN keywords k ON mk.idkeywords = k.idkeywords
                        WHERE m1.idmovies = """ + str(movie1["idmovies"]) + ";")
    kw2 = plpy.execute("""SELECT m1.idmovies ,keyword FROM movies m1
                        JOIN movies_keywords mk ON m1.idmovies = mk.idmovies
                        JOIN keywords k ON mk.idkeywords = k.idkeywords
                        WHERE m1.idmovies != """ + str(movie1["idmovies"]) + ";")

    vectors1 = np.array([_model.wv[k['keyword']] for k in kw1])
    mean_keywords1 = np.mean(vectors1, axis=0)

    word_dict = {}


    for index, k in enumerate(kw2):
        if not k['keyword'].isdigit():
            if word_dict.has_key(k['idmovies']):
                word_dict[k['idmovies']].append(k['keyword'])
            else:
                word_dict[k['idmovies']] = [k['keyword']]

    movie_ids, vectors = [], []
    for key in word_dict:
        vectors.append(np.mean([_model.wv[word] for word in word_dict[key]], axis=0))
        movie_ids.append(key)
    most_sim_ = np.array(gensim.models.KeyedVectors.cosine_similarities(mean_keywords1, np.array(vectors)))


    max_sim_indices = most_sim_.argsort()[-10:][::-1]
    return np.take(movie_ids, max_sim_indices)

# plpy.notice(cos_sim)
# model.wv.similarity('woman', 'man')
return main(movie1, model)
$$
LANGUAGE plpythonu;