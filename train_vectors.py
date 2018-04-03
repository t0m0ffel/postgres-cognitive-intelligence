from gensim.models.wrappers import FastText


def train(*args):
    for corpus in args:
        model = FastText.train('./fasttext', corpus_file='./corpus/' + corpus,
                               iter=20, window=3, size=300, min_count=1)
        model.save('./models/model_' + corpus)
