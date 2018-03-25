CREATE OR REPLACE LANGUAGE plpythonu;

CREATE OR REPLACE FUNCTION average_similarity(words1 VARCHAR [], words2 VARCHAR [])
  RETURNS FLOAT
AS $$
def tokenize(value):
    return value.replace(' ', '_').lower()


def main(words, GD):
    model = GD['model']

    if model is None:
        raise Exception('No model was loaded! Please load a model via load_model(path) function!')
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