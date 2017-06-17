
import bokeh
import re
import requests
import subprocess
import os

import pandas as pd

RAW_FIXTURES_DIR = "./fixtures/raw"

CI_pattern = '95%(.)*'
Z_pattern = 'Z-(.)*'

urls = {'2017':"http://www.countyhealthrankings.org/sites/default/files/state/downloads/2017%20County%20Health%20Rankings%20Indiana%20Data%20-%20v1.xls",
        '2016':"http://www.countyhealthrankings.org/sites/default/files/state/downloads/2016%20County%20Health%20Rankings%20Indiana%20Data%20-%20v3.xls",
        '2015':"http://www.countyhealthrankings.org/sites/default/files/state/downloads/2015%20County%20Health%20Rankings%20Indiana%20Data%20-%20v3.xls",
        '2014':"http://www.countyhealthrankings.org/sites/default/files/state/downloads/2014%20County%20Health%20Rankings%20Indiana%20Data%20-%20v6.xls",
       '2013':"http://www.countyhealthrankings.org/sites/default/files/state/downloads/2013%20County%20Health%20Ranking%20Indiana%20Data%20-%20v1_0.xls",
       "2012":"http://www.countyhealthrankings.org/sites/default/files/state/downloads/2012%20County%20Health%20Ranking%20Indiana%20Data%20-%20v2.xls",
       "2011": "http://www.countyhealthrankings.org/sites/default/files/state/downloads/2011%20County%20Health%20Ranking%20Indiana%20Data%20-%20v2.xls"}

CI_re = re.compile(CI_pattern)
Z_re = re.compile(Z_pattern)
regex_list = [CI_re, Z_re]

cols_to_keep_old=['County', 'Teen Births', 'Teen Birth Rate', 'AFGR', '% LBW', '% Children in Poverty']
cols_to_keep_new=['County', 'Teen Births', 'Teen Birth Rate', 'Graduation Rate', '% LBW', '% Children in Poverty']

def get_file(url, filename):
    try:
        subprocess.call(['wget', url, '-O', filename])
    except Exception as e:
        print(filename, "failed.")
    else:
        return filename

def drop_bad_cols(df, regex_patterns=[]):
    bad_cols_ci = []
    for idx, col in enumerate(df.columns):
        for each_regex in regex_patterns:
            if re.search(each_regex, col):
                bad_cols_ci.append(idx)
    
    for bad_col in sorted(bad_cols_ci, reverse=True):
        df = df.drop(df.columns[bad_col], axis=1, inplace=False)

    return df

def keep_good_cols(df, cols_to_keep=[]):
    return df[cols_to_keep]

def load_dataset(year, url, sheetname="Ranked Measure Data", skiprows=1, bad_col_regex=list(), good_cols=list(), **kwargs):
    try:
        file_path = "{path}/main_data_{year}.xls".format(path = RAW_FIXTURES_DIR, year = year)
        url = url

        path_to_file = get_file(url = url, filename = file_path)
        df = pd.read_excel(path_to_file, sheetname=sheetname, skiprows=skiprows, **kwargs)
        df.columns = [col.strip() for col in df.columns]
        df = drop_bad_cols(df, regex_patterns=bad_col_regex)
        df = keep_good_cols(df, cols_to_keep = good_cols)
        df['year'] = year
    except KeyError as ke:
        print(year)
        print(df.columns)
        raise
    else:
        return df

dfs = {}
cols_to_keep = []
for year, url in urls.items():
    if int(year) < 2014:
      cols_to_keep = cols_to_keep_old
    else:
      cols_to_keep = cols_to_keep_new
    dfs[year] = load_dataset(year, url, bad_col_regex=regex_list, good_cols = cols_to_keep)

master_df = pd.concat([df for df in dfs.values()])

master_df.to_csv("./fixtures/clean/main_data.csv", sep = ',', index=False)







