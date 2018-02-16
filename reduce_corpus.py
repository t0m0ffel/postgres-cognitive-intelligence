from train_vectors import train


# create smaller corpus for training to fit in memory
def reduce_corpus():
    filepath = './corpus/actor_movie_corpus.txt'

    line_count = 5000000

    with open("./corpus/actor_movie_corpus_reduced.txt", 'w') as file:
        file.write("")

    with open(filepath) as fp:
        line = fp.readline()
        for i in range(line_count):
            line = fp.readline()
            with open("./corpus/actor_movie_corpus_reduced.txt", 'a') as file:
                file.write(line)
            if i % 10000 == 0:
                print(i)

    train()
