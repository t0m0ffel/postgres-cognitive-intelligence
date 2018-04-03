from create_corpus_from_table import create_corpus, tokenize3
from reduce_corpus import reduce_corpus
from train_vectors import train
import gensim

corpus_file = 'corpus'
# reduce_corpus_path = 'corpus_reduced'
# create_corpus(tokenize3, corpus_file)
# reduce_corpus(corpus_file,reduce_corpus_path)
# train(reduce_corpus_path, corpus_file, 'corpus_large.txt')
train(corpus_file)

