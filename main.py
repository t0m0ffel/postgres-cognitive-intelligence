from create_corpus_from_table import create_corpus, tokenize3
from reduce_corpus import reduce_corpus
from train_vectors import train
import gensim

corpus_file = 'corpus'
# reduce_corpus_path = 'corpus_reduced'
# create_corpus(tokenize3, corpus_file)
# reduce_corpus(corpus_file,reduce_corpus_path)
# train(reduce_corpus_path, corpus_file, 'corpus_large.txt')
# train(corpus_file)

from gensim.models.wrappers import FastText

# model = FastText.train('./fasttext', corpus_file='./corpus/corpus', output_file='./test/test_gensim_model', iter=20,
#                       window=3, size=300, min_count=1)

# model.save('./test/test_gensim_model')

# model = gensim.models.KeyedVectors.load_word2vec_format('./models/actor_movie_model_skipgram.vec')
#model.save('./test_gensim_model')

model = gensim.models.KeyedVectors.load('./models/corpusgensim_model', mmap='r')

# print(model.similarity('children', 'war'))
# print(model.similarity('children', 'nazi'))
# print(model.similarity('war', 'nazi'))

# print([model.similarity('canim_ailem', 'wipeout'), model.similarity('please_like_me', 'wipeout'),
#        model.similarity('please_like_me', 'cabaret')])

'/home/hendrik/PycharmProjects/postgres-cognitive-intelligence/models/corpusgensim_model'
