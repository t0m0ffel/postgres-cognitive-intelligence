import gzip
import os
import shutil
import subprocess

url = 'ftp://ftp.fu-berlin.de/pub/misc/movies/database/'


def download_files():
    subprocess.call(['./download_files.sh', url])


def unzip_files():
    db_dir = './ftp.fu-berlin.de/pub/misc/movies/database/frozendata/'
    files_dir = os.listdir(db_dir)

    files_ = './unzip_files/'
    if not os.path.exists(files_):
        os.makedirs(files_)
    for file_name in files_dir:
        print(file_name)
        if 'list.gz' in file_name:
            decompressed_file = gzip.open(db_dir + file_name)  # open the file
            with open(files_ + file_name.split('.')[0] + '.list', 'wb') as outfile:
                outfile.write(decompressed_file.read())


def delete_files():
    shutil.rmtree('./ftp.fu-berlin.de')


if __name__ == '__main__':
    download_files()
    unzip_files()
    delete_files()
