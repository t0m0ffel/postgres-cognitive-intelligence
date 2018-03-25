import subprocess


def train(*args):
    subprocess.call(['./train_vectors.sh', *args])
