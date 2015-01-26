#!/usr/bin/env python
'''Description'''
import sys
from pandas import read_csv

def main():
    '''Main function'''

    fp = sys.argv[1]  # input file
    keyword = sys.argv[2]
    data = read_csv(fp, sep='\t')
    mask = [keyword in col for col in data.columns.values]
    # print mask
    select_data = data.ix[:, mask]
    select_data.to_csv(sys.stdout, sep='\t')


if __name__=='__main__':
    main()

