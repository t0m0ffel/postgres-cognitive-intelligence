# Table specifications form IMBD http://www.imdb.com/interfaces/
import re

import requests
from bs4 import BeautifulSoup

result = requests.get("https://datasets.imdbws.com/")

soup = BeautifulSoup(result.content, 'html.parser')

urls = []

for ul in soup.findAll('ul'):
    urls.append(ul.find('a')['href'])


def get_table_name(name):
    return name.replace('.', '_')


table_names = []
for url in urls:
    table_names.append(get_table_name(re.findall('.com/(.*?).tsv.gz', url)[0]))

download_url = 'https://datasets.imdbws.com/{}.tsv.gz'


def get_columns(name):
    return 'SELECT column_name,data_type FROM information_schema.columns WHERE table_name =\'{}\''.format(name)
