import gensim
import numpy as np
from scipy import spatial
from numpy import dot
from numpy.linalg import norm
import operator




def main(movie1, movie2, _model):
    kw1 = plpy.execute("""SELECT keyword FROM movies m1
                        JOIN movies_keywords mk ON m1.idmovies = mk.idmovies
                        JOIN keywords k ON mk.idkeywords = k.idkeywords
                        WHERE m1.idmovies = """ + str(movie1["idmovies"]) + ";")
    kw2 = plpy.execute("""SELECT m1.idmovies ,keyword FROM movies m1
                        JOIN movies_keywords mk ON m1.idmovies = mk.idmovies
                        JOIN keywords k ON mk.idkeywords = k.idkeywords
                        WHERE m1.idmovies != """ + str(movie1["idmovies"]) + ";")

    vectors1 = np.array([_model.wv[k['keyword']] for k in kw1])
    mean_keywords1 = np.mean(vectors1, axis=0)

    word_dict = {}
    movie_ids, vectors = [], []

    for k in kw2:
        if word_dict.has_key(k['idmovies']):
            word_dict[k['idmovies']].append(k['keyword'])
        else:
            word_dict[k['idmovies']] = [k['keyword']]

    for key in word_dict:
        vectors.append(np.mean([_model.wv[word] for word in word_dict[key]],axis=0))
        movie_ids.append(key)

    plpy.notice(np.array(vectors).shape)
    plpy.notice(np.array(vectors[0]).shape)
    plpy.notice(np.array(mean_keywords1).shape)
    similarities = gensim.models.KeyedVectors.cosine_similarities(mean_keywords1, np.array(vectors))

    return str(movie_ids[np.argmax(similarities)])
