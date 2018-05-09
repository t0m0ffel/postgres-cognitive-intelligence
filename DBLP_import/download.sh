#!/usr/bin/env bash
wget  http://dblp.uni-trier.de/xml/dblp.xml.gz -O ./hw1/dblp.xml
wget http://dblp.uni-trier.de/xml/dblp.dtd -O ./hw1/dblp.dtd
gunzip ./hw1/dblp.xml.gz
python ./hw1/wrapper.py