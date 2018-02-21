from create_corpus_from_table import create_corpus, tokenize3
from reduce_corpus import reduce_corpus
from train_vectors import train

create_corpus(tokenize3)
reduce_corpus()
train()
