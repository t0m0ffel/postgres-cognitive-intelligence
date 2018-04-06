#!/usr/bin/env bash
for var in "$@"
do
    echo "$var"
   # ./fasttext cbow -input ./corpus/${var} -output ./models/"$var"_model_cbow -dim 300 -ws 30 -minCount 1 -epoch 100 -maxn 0
    ./fasttext skipgram -input ./corpus/${var} -output ./models/"$var"_model_skipgram -dim 300 -ws 3 -minCount 1 -epoch 20 -pretrainedVectors ./pretrained_vectors/wiki.en.bin
done


#./fasttext sent2vec -input ./corpus/actor_movie_corpus_reduced.txt -output ./models/actor_movie_model_s2v -dim 300 -maxn 0 -minCount 1 -epoch 10

