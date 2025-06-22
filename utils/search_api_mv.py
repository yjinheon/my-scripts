from typing import Optional, Union
from pydantic import BaseModel
from fastapi import FastAPI, HTTPException

import sys
import argparse
from hashlib import md5
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
from sklearn.metrics.pairwise import cosine_similarity
from sentence_transformers import SentenceTransformer, util

import warnings

warnings.filterwarnings(action="ignore")

import logging

logger = logging.getLogger(__name__)

torch.autograd.set_detect_anomaly(True)
random_seed = 42
torch.manual_seed(random_seed)  # torch
torch.cuda.manual_seed(
    random_seed
)  # 동일한 조건에서 학습시 weight가 변화하지 않게 하는 옵션
np.random.seed(random_seed)  # numpy
random.seed(random_seed)  # random

dir_path = "/workspace/keyword"
version = 1.0  # 버전 명시. 메모리 사용량을 이유로 모든 파일은 미리 불러옴
device = "cpu"
category_class = [
    "cpif",
    "consult",
    "rflg",
    "expt",
    "alarm",
    "cmmnty",
    "faq",
    "edu",
]  # 상담/지자체관/현장의 달인/알림마당/커뮤니티/FAQ/교육
content_id = "id"
similarity_constant = 0.4  # 유사도 상수값을 미리 지정해줌
best_constant = 0.75

streamHandler = logging.StreamHandler()
fileHandler = logging.FileHandler(f"{dir_path}/search.log")
logger.addHandler(streamHandler)
logger.addHandler(fileHandler)
logger.setLevel(level=logging.DEBUG)

# load model
with open(f"{dir_path}/bert/sbert.pickle", "rb") as fr:
    sbert = pickle.load(fr)
sbert.to(device)
sbert.max_seq_length = 64

mecab = Mecab()

app = FastAPI()


class InvalidVersion(Exception):
    def __init__(self, detail):
        self.detail = detail


class InvalidFileName(Exception):
    def __init__(self, detail):
        self.detail = detail


class InvalidQuery(Exception):
    def __init__(self, detail):
        self.detail = detail


class InvalidControl(Exception):
    def __init__(self, detail):
        self.detail = detail


class InvalidPage(Exception):
    def __init__(self, detail):
        self.detail = detail


def faiss_cosine(query_vector, search_data):
    try:
        query_vector = np.array(query_vector).astype(np.float32).reshape(1, 768)
        data_vectors = np.array(search_data.tolist()).astype(np.float32)

        index = faiss.IndexFlatIP(768)
        faiss.normalize_L2(data_vectors)
        index.add(data_vectors)
        faiss.normalize_L2(query_vector)
        similarity, indices = index.search(query_vector, len(data_vectors))

    except Exception as e:
        exc_type, exc_obj, exc_tb = sys.exc_info()
        fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
        print(exc_type, fname, exc_tb.tb_lineno)

    return similarity, indices


# global file_list
# file_list = dict()
# data_dir_path = f'{dir_path}/data_{version}'
# for (root, directories, files) in os.walk(data_dir_path):
#     for file in files:
#         if '.pickle' in file:
#             file_path = os.path.join(root, file)
#             target_file = file_path.split('/')[-1:][0]

#             if '_dict' in target_file:
#                 with open(f'{data_dir_path}/{target_file}', 'rb') as fr:
#                     file_list[target_file.strip('.pickle')] = pickle.load(fr)


# gunicorn -k uvicorn.workers.UvicornWorker --access-logfile ./gunicorn-access.log search_api_new:app --max-requests 36 --max-requests-jitter 36 --bind 0.0.0.0:8000 --workers 4 --preload
# uvicorn search_api_new:app --reload --host=0.0.0.0 --port=8000 --workers 4


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/hashCheck")
async def hash_check():
    try:
        global file_list
        exist_file = file_list["view_search_table_dict"]
        exist_file.pop("embeddings", None)
        exist_file.pop("content_old", None)
        for ky in exist_file.keys():
            exist_file[ky] = np.array(exist_file[ky]).tolist()
        exist_file_hash = md5(json.dumps(exist_file).encode("UTF-8")).digest()

        file_list_new = dict()
        data_dir_path = f"{dir_path}/data_{version}"
        for root, directories, files in os.walk(data_dir_path):
            for file in files:
                if ".pickle" in file:
                    file_path = os.path.join(root, file)
                    target_file = file_path.split("/")[-1:][0]

                    if "_dict" in target_file:
                        with open(f"{data_dir_path}/{target_file}", "rb") as fr:
                            file_list_new[target_file.strip(".pickle")] = pickle.load(
                                fr
                            )
        new_file = file_list_new["view_search_table_dict"]
        new_file.pop("embeddings", None)
        new_file.pop("content_old", None)
        for ky in new_file.keys():
            new_file[ky] = np.array(new_file[ky]).tolist()
        new_file_hash = md5(json.dumps(new_file).encode("UTF-8")).digest()

        if exist_file_hash != new_file_hash:
            file_list = file_list_new
            logger.debug(
                f'{datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")} | file reload :True\n'
            )
            logger.debug(
                f'{datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")} | exist_file_hash : {exist_file_hash} || new_file_hash : {new_file_hash} \n'
            )
            return {"file reload": "True"}

        else:
            logger.debug(
                f'{datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")} | file reload :False\n'
            )
            logger.debug(
                f'{datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")} | exist_file_hash : {exist_file_hash} || new_file_hash : {new_file_hash} \n'
            )
            return {"file reload": "False"}

    except Exception as e:
        print(e)
        exc_type, exc_obj, exc_tb = sys.exc_info()
        fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
        print(exc_type, fname, exc_tb.tb_lineno)
        logger.error(
            f'{datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")} | hashCheck err {str(e) + " " + str(exc_type) + " " + str(fname) + " " + str(exc_tb.tb_lineno)}\n'
        )


# http://127.0.0.1:8000/epis/search/query?version=1.0&userid=user_0001
# http://127.0.0.1:8000/epis/search/query?version=1.2&userid=user_0001&query=귀농에 필요한 준비물은 무엇인가요
# http://127.0.0.1:8000/epis/search/query?version=1.0&userid=user_0001&category=TN_BBS&query=귀농에 필요한 준비물은 무엇인가요
# http://127.0.0.1:8000/epis/search/query?version=1.0&userid=user_0001&category=TN_BBS&query=귀농에 필요한 준비물은 무엇인가요&limit=50
# http://127.0.0.1:8000/epis/search/query?version=1.0&userid=user_0001&category=TN_BBS&query=귀농에 필요한 준비물은 무엇인가요
# http://127.0.0.1:8000/epis/search/query?version=1.0&userid=user_0001&query=귀농에 필요한 준비물은 무엇인가요&limit=50
@app.get("/epis/search/query")
async def epis_search_query(
    version: float,
    category: Optional[str] = None,
    keyword: Optional[str] = None,
    query: Optional[str] = None,
    userid: Optional[str] = None,
    page: Optional[str] = None,
    items_per_page: Optional[str] = None,
):
    try:
        starttime = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S:%f")
        searchlist = []
        responsecode = 0
        error = None

        if query == None:  # 질의어 안들어옴
            raise InvalidQuery("Invalid query")

        if page == None:  # 페이지 안들어옴
            raise InvalidPage("Invalid page")

        if items_per_page == None:  # 페이지 안들어옴
            raise InvalidPage("Invalid page")

        try:
            page = int(page)
            items_per_page = int(items_per_page)
        except:
            raise InvalidPage("Invalid page")
        file_list = dict()
        data_dir_path = f"{dir_path}/data_{version}"
        for root, directories, files in os.walk(data_dir_path):
            for file in files:
                if ".pickle" in file:
                    file_path = os.path.join(root, file)
                    target_file = file_path.split("/")[-1:][0]

                    if "_dict" in target_file:
                        with open(f"{data_dir_path}/{target_file}", "rb") as fr:
                            file_list[target_file.strip(".pickle")] = pickle.load(fr)

        view_search_table = pd.DataFrame(file_list["view_search_table_dict"])

        if len(file_list) < 1:  # version에 문제가 있을 경우
            raise InvalidVersion("Invalid version")

        if category == None:  # 카테고리가 null일 때
            target_df = view_search_table

        else:  # 카테고리가 하나일 때

            if category == "consult":
                target_df = view_search_table.loc[
                    view_search_table["category"] == "consult"
                ]
            elif category == "rflg":
                target_df = view_search_table.loc[
                    view_search_table["category"] == "rflg"
                ]
            elif category == "expt":
                target_df = view_search_table.loc[
                    view_search_table["category"] == "expt"
                ]
            elif category == "alarm":
                target_df = view_search_table.loc[
                    view_search_table["category"] == "alarm"
                ]
            elif category == "cmmnty":
                target_df = view_search_table.loc[
                    view_search_table["category"] == "cmmnty"
                ]
            elif category == "faq":
                target_df = view_search_table.loc[
                    view_search_table["category"] == "faq"
                ]
            elif category == "edu":
                target_df = view_search_table.loc[
                    view_search_table["category"] == "edu"
                ]
            elif category == "cpif":
                target_df = view_search_table.loc[
                    view_search_table["category"] == "cpif"
                ]
            else:  # 카테고리가 null도 아니고 기존에 정의한 카테고리도 아닐때
                raise InvalidFileName("Invalid catecory")

    except InvalidQuery as IQ:  # 지정한 예외
        responsecode = 1
        error = str(IQ)
        result_return = {
            "version": version,
            "searchlist": searchlist,
            "starttime": starttime,
            "endtime": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S:%f"),
            "responsecode": responsecode,
            "error": error,
        }
        return result_return

    except InvalidPage as IP:  # 지정한 예외
        responsecode = 1
        error = str(IP)
        result_return = {
            "version": version,
            "searchlist": searchlist,
            "starttime": starttime,
            "endtime": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S:%f"),
            "responsecode": responsecode,
            "error": error,
        }
        return result_return

    except InvalidVersion as IV:  # 지정한 예외
        responsecode = 1
        error = str(IV)
        result_return = {
            "version": version,
            "searchlist": searchlist,
            "starttime": starttime,
            "endtime": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S:%f"),
            "responsecode": responsecode,
            "error": error,
        }
        return result_return

    except InvalidFileName as IF:  # 지정한 예외
        responsecode = 1
        error = str(IF)
        result_return = {
            "version": version,
            "searchlist": searchlist,
            "starttime": starttime,
            "endtime": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S:%f"),
            "responsecode": responsecode,
            "error": error,
        }
        return result_return

    except Exception as e:  # 지정하지 않은 예외
        exc_type, exc_obj, exc_tb = sys.exc_info()
        fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
        responsecode = 1
        error = (
            "Undefined error : "
            + str(e)
            + " "
            + str(exc_type)
            + " "
            + str(fname)
            + " "
            + str(exc_tb.tb_lineno)
        )
        result_return = {
            "version": version,
            "searchlist": searchlist,
            "starttime": starttime,
            "endtime": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S:%f"),
            "responsecode": responsecode,
            "error": error,
        }
        return result_return

    try:
        if category == None:  # 전체 검색
            if (userid == None) and (query != None):  # 비회원검색
                for i in range(len(category_class)):
                    target_df_cls = target_df.loc[
                        target_df["category"] == category_class[i]
                    ]

                    # query 형태소 분석
                    # tokenized_doc = mecab.pos(query)
                    # tokenized_nouns = [ word[0] for word in tokenized_doc if (len(word[0]) > 1) and (word[1]=='NNG' or word[1]=='NNP' or word[1]=='VA+ETM' or word[1]=='VV+NNG') ]

                    contains_cls = target_df_cls.loc[
                        target_df_cls["content"].astype("str").str.contains(query)
                    ]
                    contains_cls["similarity"] = 1

                    query_vector = [sbert.encode(query)]
                    # target_df_cls['similarity'] = target_df_cls['embeddings'].map(lambda x : util.pytorch_cos_sim(query_vector, x)[0][0])
                    similarity, indices = faiss_cosine(
                        query_vector, target_df_cls["embeddings"]
                    )
                    target_df_cls["similarity"] = similarity[0]
                    target_df_cls = target_df_cls.loc[
                        target_df_cls["similarity"] >= similarity_constant
                    ]
                    target_df_cls = target_df_cls.sort_values(
                        by="similarity", ascending=False
                    )
                    target_df_cls = target_df_cls.reset_index(drop=True)

                    target_df_cls = pd.concat(
                        [contains_cls, target_df_cls], axis=0
                    ).drop_duplicates(content_id)

                    # 결과 추출
                    temp_search_result_df = target_df_cls

                    best_search_result_df = temp_search_result_df.loc[
                        temp_search_result_df["similarity"] >= best_constant
                    ]
                    best_search_result_df = best_search_result_df.sort_values(
                        by="similarity", ascending=False
                    )

                    std_search_result_df = temp_search_result_df.loc[
                        temp_search_result_df["similarity"] < best_constant
                    ]
                    std_search_result_df = std_search_result_df.sort_values(
                        by="reg_dt", ascending=False
                    )

                    search_result_df = pd.concat(
                        [best_search_result_df, std_search_result_df], axis=0
                    ).drop_duplicates(content_id)
                    search_result_df = search_result_df.reset_index(drop=True)

                    start_idx = items_per_page * (page - 1)
                    end_idx = start_idx + items_per_page
                    search_result_page = search_result_df.iloc[start_idx:end_idx]

                    search_result_page_id = search_result_page[content_id]

                    id_range = len(search_result_page_id)
                    id_list = list(search_result_page_id)
                    title_list = list(search_result_page["title"])
                    # old_list = list(search_result_page['content_old'])
                    old_list = list(search_result_page["content"])
                    dt_list = list(search_result_page["reg_dt"])
                    del_list = list(search_result_page["del_yn"])
                    # content_new_list = list(search_result_page['content'])

                    content_result = []
                    content_result_ap = content_result.append
                    for j in range(id_range):
                        content_dict = dict()
                        content_dict["id"] = id_list[j]
                        content_dict["title"] = title_list[j]
                        content_dict["content"] = old_list[j]
                        content_dict["reg_dt"] = dt_list[j]
                        content_dict["del_yn"] = del_list[j]
                        # content_dict['new_list'] = content_new_list[j]

                        for etc_col in list(search_result_page.columns):
                            if "etc" in etc_col:
                                content_dict[etc_col] = list(
                                    search_result_page[etc_col]
                                )[j]
                        content_result_ap(content_dict)
                    # content_dict['id'] = list(search_result_page_id)
                    # content_dict['title'] = list(search_result_page['title'])
                    # content_dict['content'] = list(search_result_page['content_old'])
                    # content_dict['reg_dt'] = list(search_result_page['reg_dt'])
                    # content_dict['del_yn'] = list(search_result_page['del_yn'])
                    # for etc_col in list(search_result_page.columns):
                    #     if "etc" in etc_col:
                    #         content_dict[etc_col] = list(search_result_page[etc_col])

                    result = dict()
                    result["category"] = str(category_class[i])
                    result["userid"] = userid
                    result["query"] = str(query)
                    result["content"] = content_result
                    result["count"] = len(search_result_df)
                    searchlist.append(result)

            elif (userid != None) and (query != None):  # 회원검색
                for i in range(len(category_class)):
                    target_df_cls = target_df.loc[
                        target_df["category"] == category_class[i]
                    ]

                    # # query 형태소 분석
                    # tokenized_doc = mecab.pos(query)
                    # tokenized_nouns = [ word[0] for word in tokenized_doc if (len(word[0]) > 1) and (word[1]=='NNG' or word[1]=='NNP' or word[1]=='VA+ETM' or word[1]=='VV+NNG') ]

                    # query_split = query.split(" ")
                    # if len(query_split) < 2:
                    #     tokenized_nouns = 1
                    # elif len(query_split) >= 2:
                    #     tokenized_nouns = 2

                    contains_cls = target_df_cls.loc[
                        target_df_cls["content"].astype("str").str.contains(query)
                    ]
                    contains_cls["similarity"] = 1

                    query_vector = [sbert.encode(query)]
                    # target_df_cls['similarity'] = target_df_cls['embeddings'].map(lambda x : util.pytorch_cos_sim(query_vector, x)[0][0])
                    similarity, indices = faiss_cosine(
                        query_vector, target_df_cls["embeddings"]
                    )
                    target_df_cls["similarity"] = similarity[0]
                    target_df_cls = target_df_cls.loc[
                        target_df_cls["similarity"] >= similarity_constant
                    ]
                    target_df_cls = target_df_cls.sort_values(
                        by="similarity", ascending=False
                    )
                    target_df_cls = target_df_cls.reset_index(drop=True)

                    target_df_cls = pd.concat(
                        [contains_cls, target_df_cls], axis=0
                    ).drop_duplicates(content_id)

                    # 결과 추출
                    temp_search_result_df = target_df_cls

                    best_search_result_df = temp_search_result_df.loc[
                        temp_search_result_df["similarity"] >= best_constant
                    ]
                    best_search_result_df = best_search_result_df.sort_values(
                        by="similarity", ascending=False
                    )

                    std_search_result_df = temp_search_result_df.loc[
                        temp_search_result_df["similarity"] < best_constant
                    ]
                    std_search_result_df = std_search_result_df.sort_values(
                        by="reg_dt", ascending=False
                    )

                    search_result_df = pd.concat(
                        [best_search_result_df, std_search_result_df], axis=0
                    ).drop_duplicates(content_id)
                    search_result_df = search_result_df.reset_index(drop=True)

                    start_idx = items_per_page * (page - 1)
                    end_idx = start_idx + items_per_page
                    search_result_page = search_result_df.iloc[start_idx:end_idx]

                    search_result_page_id = search_result_page[content_id]

                    id_range = len(search_result_page_id)
                    id_list = list(search_result_page_id)
                    title_list = list(search_result_page["title"])
                    # old_list = list(search_result_page['content_old'])
                    old_list = list(search_result_page["content"])
                    dt_list = list(search_result_page["reg_dt"])
                    del_list = list(search_result_page["del_yn"])
                    # content_new_list = list(search_result_page['content'])

                    content_result = []
                    content_result_ap = content_result.append
                    for j in range(id_range):
                        content_dict = dict()
                        content_dict["id"] = id_list[j]
                        content_dict["title"] = title_list[j]
                        content_dict["content"] = old_list[j]
                        content_dict["reg_dt"] = dt_list[j]
                        content_dict["del_yn"] = del_list[j]
                        # content_dict['new_list'] = content_new_list[j]

                        for etc_col in list(search_result_page.columns):
                            if "etc" in etc_col:
                                content_dict[etc_col] = list(
                                    search_result_page[etc_col]
                                )[j]
                        content_result_ap(content_dict)

                    result = dict()
                    result["category"] = str(category_class[i])
                    result["userid"] = userid
                    result["query"] = str(query)
                    result["content"] = content_result
                    result["count"] = len(search_result_df)
                    searchlist.append(result)

            result_return = {
                "version": version,
                "searchlist": searchlist,
                "starttime": starttime,
                "endtime": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S:%f"),
                "responsecode": responsecode,
                "error": error,
            }
            return result_return

        else:  # 단일 검색
            if (userid == None) and (query != None):  # 비회원검색
                target_df_cls = target_df.loc[target_df["category"] == category]

                # # query 형태소 분석
                # tokenized_doc = mecab.pos(query)
                # tokenized_nouns = [ word[0] for word in tokenized_doc if (len(word[0]) > 1) and (word[1]=='NNG' or word[1]=='NNP' or word[1]=='VA+ETM' or word[1]=='VV+NNG') ]

                # query_split = query.split(" ")
                # if len(query_split) < 2:
                #     tokenized_nouns = 1
                # elif len(query_split) >= 2:
                #     tokenized_nouns = 2

                contains_cls = target_df_cls.loc[
                    target_df_cls["content"].astype("str").str.contains(query)
                ]
                contains_cls["similarity"] = 1

                query_vector = [sbert.encode(query)]
                # target_df_cls['similarity'] = target_df_cls['embeddings'].map(lambda x : util.pytorch_cos_sim(query_vector, x)[0][0])
                similarity, indices = faiss_cosine(
                    query_vector, target_df_cls["embeddings"]
                )
                target_df_cls["similarity"] = similarity[0]
                target_df_cls = target_df_cls.loc[
                    target_df_cls["similarity"] >= similarity_constant
                ]
                target_df_cls = target_df_cls.sort_values(
                    by="similarity", ascending=False
                )
                target_df_cls = target_df_cls.reset_index(drop=True)

                target_df_cls = pd.concat(
                    [contains_cls, target_df_cls], axis=0
                ).drop_duplicates(content_id)

                # 결과 추출
                temp_search_result_df = target_df_cls

                best_search_result_df = temp_search_result_df.loc[
                    temp_search_result_df["similarity"] >= best_constant
                ]
                best_search_result_df = best_search_result_df.sort_values(
                    by="similarity", ascending=False
                )

                std_search_result_df = temp_search_result_df.loc[
                    temp_search_result_df["similarity"] < best_constant
                ]
                std_search_result_df = std_search_result_df.sort_values(
                    by="reg_dt", ascending=False
                )

                search_result_df = pd.concat(
                    [best_search_result_df, std_search_result_df], axis=0
                ).drop_duplicates(content_id)
                search_result_df = search_result_df.reset_index(drop=True)

                start_idx = items_per_page * (page - 1)
                end_idx = start_idx + items_per_page
                search_result_page = search_result_df.iloc[start_idx:end_idx]

                search_result_page_id = search_result_page[content_id]

                id_range = len(search_result_page_id)
                id_list = list(search_result_page_id)
                title_list = list(search_result_page["title"])
                # old_list = list(search_result_page['content_old'])
                old_list = list(search_result_page["content"])
                dt_list = list(search_result_page["reg_dt"])
                del_list = list(search_result_page["del_yn"])
                # content_new_list = list(search_result_page['content'])

                content_result = []
                content_result_ap = content_result.append
                for j in range(id_range):
                    content_dict = dict()
                    content_dict["id"] = id_list[j]
                    content_dict["title"] = title_list[j]
                    content_dict["content"] = old_list[j]
                    content_dict["reg_dt"] = dt_list[j]
                    content_dict["del_yn"] = del_list[j]
                    # content_dict['new_list'] = content_new_list[j]

                    for etc_col in list(search_result_page.columns):
                        if "etc" in etc_col:
                            content_dict[etc_col] = list(search_result_page[etc_col])[j]
                    content_result_ap(content_dict)

                result = dict()
                result["category"] = str(category)
                result["userid"] = userid
                result["query"] = str(query)
                result["content"] = content_result
                result["count"] = len(search_result_df)
                searchlist.append(result)

            elif (userid != None) and (query != None):  # 회원검색
                target_df_cls = target_df.loc[target_df["category"] == category]

                contains_cls = target_df_cls.loc[
                    target_df_cls["content"].astype("str").str.contains(query)
                ]
                contains_cls["similarity"] = 1

                query_vector = [sbert.encode(query)]
                # target_df_cls['similarity'] = target_df_cls['embeddings'].map(lambda x : util.pytorch_cos_sim(query_vector, x)[0][0])
                similarity, indices = faiss_cosine(
                    query_vector, target_df_cls["embeddings"]
                )
                target_df_cls["similarity"] = similarity[0]
                target_df_cls = target_df_cls.loc[
                    target_df_cls["similarity"] >= similarity_constant
                ]
                target_df_cls = target_df_cls.sort_values(
                    by="similarity", ascending=False
                )
                target_df_cls = target_df_cls.reset_index(drop=True)

                target_df_cls = pd.concat(
                    [contains_cls, target_df_cls], axis=0
                ).drop_duplicates(content_id)

                # 결과 추출
                temp_search_result_df = target_df_cls

                best_search_result_df = temp_search_result_df.loc[
                    temp_search_result_df["similarity"] >= best_constant
                ]
                best_search_result_df = best_search_result_df.sort_values(
                    by="similarity", ascending=False
                )

                std_search_result_df = temp_search_result_df.loc[
                    temp_search_result_df["similarity"] < best_constant
                ]
                std_search_result_df = std_search_result_df.sort_values(
                    by="reg_dt", ascending=False
                )

                search_result_df = pd.concat(
                    [best_search_result_df, std_search_result_df], axis=0
                ).drop_duplicates(content_id)
                search_result_df = search_result_df.reset_index(drop=True)

                start_idx = items_per_page * (page - 1)
                end_idx = start_idx + items_per_page
                search_result_page = search_result_df.iloc[start_idx:end_idx]

                search_result_page_id = search_result_page[content_id]

                id_range = len(search_result_page_id)
                id_list = list(search_result_page_id)
                title_list = list(search_result_page["title"])
                # old_list = list(search_result_page['content_old'])
                old_list = list(search_result_page["content"])
                dt_list = list(search_result_page["reg_dt"])
                del_list = list(search_result_page["del_yn"])
                # content_new_list = list(search_result_page['content'])

                content_result = []
                content_result_ap = content_result.append
                for j in range(id_range):
                    content_dict = dict()
                    content_dict["id"] = id_list[j]
                    content_dict["title"] = title_list[j]
                    content_dict["content"] = old_list[j]
                    content_dict["reg_dt"] = dt_list[j]
                    content_dict["del_yn"] = del_list[j]
                    # content_dict['new_list'] = content_new_list[j]

                    for etc_col in list(search_result_page.columns):
                        if "etc" in etc_col:
                            content_dict[etc_col] = list(search_result_page[etc_col])[j]
                    content_result_ap(content_dict)

                result = dict()
                result["category"] = str(category)
                result["userid"] = userid
                result["query"] = str(query)
                result["content"] = content_result
                result["count"] = len(search_result_df)
                searchlist.append(result)

            result_return = {
                "version": version,
                "searchlist": searchlist,
                "starttime": starttime,
                "endtime": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S:%f"),
                "responsecode": responsecode,
                "error": error,
            }
            return result_return

    except Exception as e:  # 지정하지 않은 예외
        exc_type, exc_obj, exc_tb = sys.exc_info()
        fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
        responsecode = 1
        error = (
            "Undefined error : "
            + str(e)
            + " "
            + str(exc_type)
            + " "
            + str(fname)
            + " "
            + str(exc_tb.tb_lineno)
        )
        result_return = {
            "version": version,
            "searchlist": searchlist,
            "starttime": starttime,
            "endtime": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S:%f"),
            "responsecode": responsecode,
            "error": error,
        }
        return result_return
        # raise HTTPException(status_code=400, detail=result_return)
