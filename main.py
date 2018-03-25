from train_vectors import train

corpus_file = 'corpus'
reduce_corpus_path = 'corpus_reduced.txt'
# create_corpus(tokenize3, corpus_file)
# reduce_corpus_path = reduce_corpus(corpus_file)
# train(reduce_corpus_path, corpus_file, 'corpus_large.txt')
train('corpus')
