#!/usr/bin/env bash
./fasttext skipgram -input ./corpus/actor_movie_corpus_2.txt -output ./models/actor_movie_model_full_50 -dim 300 -maxn 0 -minCount 1 -epoch 50
./fasttext skipgram -input ./corpus/actor_movie_corpus_2.txt -output ./models/actor_movie_model_full_20 -dim 300 -maxn 0 -minCount 1 -epoch 20
#./fasttext sent2vec -input ./corpus/actor_movie_corpus_reduced.txt -output ./models/actor_movie_model_s2v -dim 300 -maxn 0 -minCount 1 -epoch 10

