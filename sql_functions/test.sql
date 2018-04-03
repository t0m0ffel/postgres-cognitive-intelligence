CREATE OR REPLACE FUNCTION test()
  RETURNS FLOAT[]
AS $$
import gensim
model = gensim.models.KeyedVectors.load_word2vec_format('/home/hendrik/PycharmProjects/postgres-cognitive-intelligence/models/corpus_model_skipgram.vec')
GD['model'] = model
return [model.similarity('canim_ailem','wipeout'),model.similarity('please_like_me','wipeout'),model.similarity('please_like_me','cabaret')]
$$
LANGUAGE plpythonu;
