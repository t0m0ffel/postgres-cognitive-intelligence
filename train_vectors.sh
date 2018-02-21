#!/usr/bin/env bash
./fasttext cbow -input ./corpus/actor_movie_corpus_reduced.txt -output ./models/actor_movie_model_cbow -dim 300 -ws 1000 -minCount 1 -epoch 5
./fasttext skipgram -input ./corpus/actor_movie_corpus_reduced.txt -output ./models/actor_movie_model_skipgram -dim 300 -ws 1000 -minCount 1 -epoch 5
#./fasttext sent2vec -input ./corpus/actor_movie_corpus_reduced.txt -output ./models/actor_movie_model_s2v -dim 300 -maxn 0 -minCount 1 -epoch 10

