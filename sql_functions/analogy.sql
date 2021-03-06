CREATE OR REPLACE LANGUAGE plpythonu;

CREATE OR REPLACE FUNCTION analogy(word1 VARCHAR(255), word2 VARCHAR(255), word3 VARCHAR(255),
                                   word4 VARCHAR(255), reload_model BOOLEAN)
  RETURNS VARCHAR []
AS $$
import os


plpy.notice(os.path.abspath('/home/hendrik/PycharmProjects/CI_SQL/fil9_cbow.bin'))
from gensim.models.wrappers.fasttext import FastText

def tokenize(value):
    return value.replace(' ', '_').lower()


def main(word1, word2, word3, word4, reload_model, GD):
    fasttext_vectors = '/home/hendrik/PycharmProjects/postgres-cognitive-intelligence/models/corpus.txt_model_cbow.bin'
    # fasttext_vectors = '/home/hendrik/PycharmProjects/CI_SQL/vectors/actor_movie_model.bin'
    if reload_model or 'model' not in GD:
        GD['model'] = FastText.load_fasttext_format(fasttext_vectors)
    model = GD['model']

    word1 = tokenize(word1)
    word2 = tokenize(word2)
    word3 = tokenize(word3)
    word4 = tokenize(word4)
    # return [r.decode() for r, p in model.wv.most_similar(positive=[word1, word3], negative=[word2])]

    return [model.wv.doesnt_match(word1, word2, word3, word4)]


# model.wv.similarity('woman', 'man')

return main(word1, word2, word3, word4, reload_model, GD)
$$
LANGUAGE plpythonu;