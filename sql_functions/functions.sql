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
        GD['model'] = gensim.models.KeyedVectors.load_word2vec_format('/home/cziommer/postgres-cognitive-intelligence/models/corpus_model_skipgram.vec')
    model = GD['model']

    sum_sim = 0
    for word1, word2 in words:
        try:
            sum_sim += model.similarity(tokenize(word1),tokenize(word2))
        except:
            return 0

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
    GD['model'] = gensim.models.KeyedVectors.load_word2vec_format(path)


main(path, GD)
$$
LANGUAGE plpythonu;