# create smaller corpus for training to fit in memory
def reduce_corpus():
    filepath = './corpus/actor_movie_corpus_3.txt'

    line_count = 5000000

    with open("./corpus/actor_movie_corpus_reduced.txt", 'w') as file:
        file.write("")

    with open(filepath) as fp:
        for i in range(line_count):
            line = fp.readline()
            if line is None:
                break
            with open("./corpus/actor_movie_corpus_reduced.txt", 'a') as file:
                file.write(line)
            if i % 10000 == 0:
                print(i)
