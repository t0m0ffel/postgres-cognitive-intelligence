CREATE OR REPLACE LANGUAGE plpythonu;

CREATE OR REPLACE FUNCTION max_similarity(words1 VARCHAR [], words2 VARCHAR [])
  RETURNS FLOAT
AS $$
def tokenize(value):
    return value.replace(' ', '_').lower()


def main(words, GD):
    model = GD['model']
    if model is None:
        raise Exception('No model was loaded! Please load a model via load_model(path) function!')
    try:
        return max([model.similarity(tokenize(word1), tokenize(word2)) for word1, word2 in words])

    except:
        return 0


# model.wv.similarity('woman', 'man')

return main(zip(words1, words2), GD)
$$
LANGUAGE plpythonu;