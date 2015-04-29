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
    stim, response, emotion, correct, rt = row
    return str(stim), int(response), int(emotion), int(correct), float(rt)


def flatten_row(test_round, subj, (stim, response, emotion, correct, rt)):
    return test_round, subj, stim, response, emotion, correct, rt



def convert_file(fname):
    data = tablib.import_set(open(fname, 'rb'))
    data.headers = ('round', 'subj', 'csv')
    for (test_round, subj, ext) in data:
        if ext is None:
            continue
        yield flatten_row(int(test_round), int(subj), fix_csv_line(read_csv_line(ext)))



if __name__ == "__main__":
    base = tablib.Dataset()
    base.headers = ("test_round", "subj", "stim", "response", "emotion", "correct", "rt")
    for x in ["egame1.xlsx", "egame2.xlsx"]:
        # (1, 145, 'img/Rafd090_09_Caucasian_male_surprised_frontal.jpg', 7, 7, 1, 2.8650708198547363)
        data = tablib.Dataset()
        data.headers = ("test_round", "subj", "stim", "response", "emotion", "correct", "rt")
        data.extend(convert_file(x))
        base = base.stack(data)


    with open("egame.xlsx", "wb") as f:
        f.write(base.xlsx)

    with open("egame.csv", "wb") as f:
        f.write(base.csv)

    with open("egame.yaml", "wb") as f:
        f.write(base.yaml)
