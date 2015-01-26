#!/usr/bin/env python
'''Description'''
import sys
from pandas import read_csv

def main():
    '''Main function'''

    fp = sys.argv[1]  # input file
    keyword = sys.argv[2] # prefix or etc.
    data = read_csv(fp, sep='\t')

    # if keyword in column names, it will be True
    mask = [keyword in col for col in data.columns.values]
    # mask will be like [True, False, True, True..]

    select_data = data.ix[:, mask]  # select columns corresponding 
                                    # to True value in mask.
    select_data.to_csv(sys.stdout, sep='\t')  # print results in csv.


if __name__=='__main__':
    main()

