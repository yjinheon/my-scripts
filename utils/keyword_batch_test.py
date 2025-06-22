import sys
import argparse
import os
import psycopg2
import psycopg2.extras as extras
from database import Databases
import json
import csv
import re
import random
import numpy as np
import pandas as pd
import torch
import torch.nn.functional as F
from numpy import dot
from numpy.linalg import norm
import urllib.request
import pickle
from bs4 import BeautifulSoup
import requests
import faiss
import time
import itertools
import datetime
import psutil

from konlpy.tag import Mecab
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from sentence_transformers import SentenceTransformer, util

import warnings

warnings.filterwarnings(action="ignore")

import logging

logger = logging.getLogger(__name__)

torch.autograd.set_detect_anomaly(True)
random_seed = 42
torch.manual_seed(random_seed)  # torch
np.random.seed(random_seed)  # numpy
random.seed(random_seed)  # random

dir_path = "/workspace/keyword"
version = 1.0
device = "cpu"
schema_name = "rfph"
table_name = "v_search_view_day"
init_table_name = "v_search_view_init"

streamHandler = logging.StreamHandler()
fileHandler = logging.FileHandler(f"{dir_path}/search.log")
logger.addHandler(streamHandler)
logger.addHandler(fileHandler)
logger.setLevel(level=logging.DEBUG)


class CRUD(Databases):
    def part_insertDB(self, schema, table, colum, data):
        sql = " INSERT INTO {schema}.{table}{colum} VALUES {data} ;".format(
            schema=schema, table=table, colum=colum, data=data
        )
        try:
            self.cursor.execute(sql)
            self.db.commit()
            logger.debug(
                f'{datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")} | {sql}\n'
            )
        except Exception as e:
            # print(" insert DB err ",e)
            logger.error(
                f'{datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")} | part_insertDB err {e}\n'
            )

    def total_insertDB(self, schema, table, cols, tuples):
        sql = " INSERT INTO %s.%s(%s) VALUES %%s" % (schema, table, cols)
        try:
            extras.execute_values(self.cursor, sql, tuples)
            self.db.commit()
            logger.debug(
                f'{datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")} | {sql[:50]}\n'
            )
        except Exception as e:
            self.db.rollback()
            self.cursor.close()
            # print(" insert DB err ",e)
            logger.error(
                f'{datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")} | total_insertDB err {e}\n'
            )
        # self.cursor.close()

    def total_readDB(self, schema, table, colum):
        sql = " SELECT {colum} from {schema}.{table}".format(
            colum=colum, schema=schema, table=table
        )
        try:
            self.cursor.execute(sql)
            result = self.cursor.fetchall()
            logger.debug(
                f'{datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")} | {sql}\n'
            )
        except Exception as e:
            logger.error(
                f'{datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")} | total_readDB err {e}\n'
            )

        return result, self.cursor

    def part_readDB(self, schema, table, colum, condition):
        sql = " SELECT {colum} from {schema}.{table} where {condition}".format(
            colum=colum, schema=schema, table=table, condition=condition
        )
        try:
            logger.debug(
                f'{datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")} | {sql}\n'
            )
            self.cursor.execute(sql)
            result = self.cursor.fetchall()

        except Exception as e:
            logger.error(
                f'{datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")} | part_readDB err {e}\n'
            )

        return result, self.cursor

    def updateDB(self, schema, table, colum, value, condition_colum, condition):
        sql = " UPDATE {schema}.{table} SET {colum}={value} WHERE {condition_colum}='{condition}' ".format(
            schema=schema,
            table=table,
            colum=colum,
            value=value,
            condition_colum=condition_colum,
            condition=condition,
        )
        try:
            self.cursor.execute(sql)
            self.db.commit()
            logger.debug(
                f'{datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")} | {sql}\n'
            )
        except Exception as e:
            # print(" update DB err",e)
            logger.error(
                f'{datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")} | updateDB err {e}\n'
            )

    def deleteDB(self, schema, table, condition):
        sql = " delete from {schema}.{table} where {condition} ; ".format(
            schema=schema, table=table, condition=condition
        )
        try:
            self.cursor.execute(sql)
            self.db.commit()
            logger.debug(
                f'{datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")} | {sql}\n'
            )
        except Exception as e:
            # print( "delete DB err", e)
            logger.error(
                f'{datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")} | deleteDB err {e}\n'
            )

    def truncateDB(self, schema, table):
        sql = "truncate table {schema}.{table}; ".format(schema=schema, table=table)
        try:
            self.cursor.execute(sql)
            self.db.commit()
            logger.debug(
                f'{datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")} | {sql}\n'
            )
        except Exception as e:
            # print( "truncate DB err", e)
            logger.error(
                f'{datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")} | truncateDB err {e}\n'
            )


# # load model
# with open(f'{dir_path}/bert/sbert.pickle', 'rb') as fr:
#     sbert = pickle.load(fr)
# sbert.max_seq_length = 256


db = CRUD()
data, cursor = db.total_readDB(
    schema=f"{schema_name}", table=f'"{table_name}"', colum="*"
)
cols = []
for elt in cursor.description:
    cols.append(elt[0])
print(cols)
print("data : ", len(data))
view_search_table = pd.DataFrame(data=data, columns=cols)
view_search_table = view_search_table.loc[view_search_table["del_yn"] == "N"]
view_search_table = view_search_table.reset_index(drop=True)
view_search_table = view_search_table.fillna("")
view_search_table["content_old"] = view_search_table["content"]
# view_search_table['content'] = view_search_table.apply(lambda x: re.sub(r'[\xa0\r\s\t\n]', ' ',BeautifulSoup(x['content'], 'html.parser').getText()), axis=1) # html코드로 구성되어 있으므로 정규식으로 이용해 제거

view_search_table = view_search_table.astype("str")  # 모두 문자열 처리
view_search_table = view_search_table.reset_index(drop=True)
view_search_table["TEXT"] = (
    view_search_table["title"] + " " + view_search_table["content"]
)
print(view_search_table)


db = CRUD()
data, cursor = db.total_readDB(
    schema=f"{schema_name}", table=f'"{init_table_name}"', colum="*"
)
cols = []
for elt in cursor.description:
    cols.append(elt[0])
print(cols)
view_search_init_table = pd.DataFrame(data=data, columns=cols)
view_search_init_table = view_search_init_table.loc[
    view_search_init_table["del_yn"] == "N"
]
view_search_init_table = view_search_init_table.reset_index(drop=True)
view_search_init_table = view_search_init_table.fillna("")
view_search_init_table["content_old"] = view_search_init_table["content"]
view_search_init_table["content"] = view_search_init_table.apply(
    lambda x: re.sub(
        r"[\xa0\r\s\t\n]", " ", BeautifulSoup(x["content"], "html.parser").getText()
    ),
    axis=1,
)  # html코드로 구성되어 있으므로 정규식으로 이용해 제거

view_search_init_table = view_search_init_table.astype("str")  # 모두 문자열 처리
view_search_init_table = view_search_init_table.reset_index(drop=True)
view_search_init_table["TEXT"] = (
    view_search_init_table["title"] + " " + view_search_init_table["content"]
)
print(view_search_init_table)


# 기존 저장 파일 불러오기
with open(f"{dir_path}/data_{version}/view_search_table_dict.pickle", "rb") as fr:
    view_search_table_dict_exist = pickle.load(fr)

view_search_table_df_exist = pd.DataFrame(view_search_table_dict_exist)
print(len(view_search_table_df_exist))

