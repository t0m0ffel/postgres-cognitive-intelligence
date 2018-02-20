# Table specifications from IMBD http://www.imdb.com/interfaces/
import re

import requests
from bs4 import BeautifulSoup


def get_table_name(name):
    return name.replace('.', '_')


def get_urls():
    try:
        result = requests.get("https://datasets.imdbws.com/")

        soup = BeautifulSoup(result.content, 'html.parser')
        return [url.find('a')['href'] for url in soup.findAll('ul')]
    except:
        print('Could not find data')


def get_table_names():

    table_names = []
    for url in get_urls():
        table_names.append(get_table_name(re.findall('.com/(.*?).tsv.gz', url)[0]))


download_url = 'https://datasets.imdbws.com/{}.tsv.gz'


def get_columns(name):
    return 'SELECT column_name,data_type FROM information_schema.columns WHERE table_name =\'{}\''.format(name)
