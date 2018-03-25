# create smaller corpus for training to fit in memory
def reduce_corpus(corpus_file):
    filepath = './corpus/' + corpus_file

    corpus_file = corpus_file.split(".txt")[0]
    line_count = 5000000

    with open("./corpus/" + corpus_file + "_reduced.txt", 'w') as file:
        file.write("")

    with open(filepath) as fp:
        for i in range(line_count):
            line = fp.readline()
            if line is None:
                break
            with open("./corpus/" + corpus_file + "_reduced.txt", 'a') as file:
                file.write(line)
            if i % 10000 == 0:
                print(i)
    return corpus_file + "_reduced.txt"
