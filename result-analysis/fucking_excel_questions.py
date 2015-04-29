#!/usr/bin/env python
"""Fucking excel :(
"""
import tablib


def read_csv_line(s):
    if s is None:
        return None
    return s.split(",")


def fix_csv_line(row):
    if row is None:
        return None
    qid, response, rt = row
    return int(qid), int(response), float(rt)


def flatten_row(test_round, subj, (qid, response, rt)):
    return test_round, subj, qid, response, rt

def convert_file(fname):
    data = tablib.import_set(open(fname, 'rb'))
    data.headers = ('round', 'subj', 'csv')
    for (test_round, subj, ext) in data:
        if ext is None:
            continue
        yield flatten_row(int(test_round), int(subj), fix_csv_line(read_csv_line(ext)))



if __name__ == "__main__":
    base = tablib.Dataset()
    base.headers = ("test_round", "subj", "qid", "response", "rt")
    for x in ["questions1.xlsx", "questions2.xlsx"]:
        data = tablib.Dataset()
        data.headers = ("test_round", "subj", "qid", "response", "rt")
        data.extend(convert_file(x))
        base = base.stack(data)


    with open("questions.xlsx", "wb") as f:
        f.write(base.xlsx)

    with open("questions.csv", "wb") as f:
        f.write(base.csv)

    with open("questions.yaml", "wb") as f:
        f.write(base.yaml)
