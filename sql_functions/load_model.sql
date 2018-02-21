CREATE OR REPLACE FUNCTION load_model(path VARCHAR(255))
  RETURNS VARCHAR []
AS $$
from gensim.models.wrappers.fasttext import FastText


def main(path, GD):
    GD['model'] = FastText.load_fasttext_format(path)


main(path, GD)
$$
LANGUAGE plpythonu;