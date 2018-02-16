#!/usr/bin/env bash
./fasttext skipgram -input ./corpus/actor_movie_corpus_reduced.txt -output ./vectors/actor_movie_model -dim 300 -maxn 0 -minCount 1 -epoch 10
./fasttext sent2vec -input ./corpus/actor_movie_corpus_reduced.txt -output ./vectors/actor_movie_model_s2v -dim 300 -maxn 0 -minCount 1 -epoch 10

