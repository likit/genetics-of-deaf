#!/usr/bin/env python
'''Description'''
import sys
from pandas import read_csv

def main():
    '''Main function'''
    fp = sys.argv[1]
    data = read_csv(fp, sep='\t', comment='#', header=None)
    header = file('header.vcf').readline().strip().split(',')
    data.columns = header
    data.to_csv(sys.stdout, sep='\t')


if __name__=='__main__':
    main()

