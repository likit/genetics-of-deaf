#!/usr/bin/env python
'''Description'''
import sys
import os
import subprocess
import gzip


def run_blat(infile):
    '''run BLAT from command line'''

    zipfile = False
    if infile.endswith('.gz'):
        print >> sys.stderr, 'Gunzipping file...'
        query = infile.rstrip('.gz')
        op = open(query, 'w')
        infile = gzip.open(infile) # gunzip input file
        for line in infile:
            op.write(line)
        op.close()
        zipfile = True
    else:
        query = infile

    outfile = query + '.psl'

    # subprocess.check_call(['blat', db, query, outfile], shell=True)

    print >> sys.stderr, 'removing unzipped file'
    if zipfile:
        os.rm(query)  # delete unzipped file

def main():
    '''Main function'''

    try:
        infile = sys.argv[1]
        db = sys.argv[2]
    except IndexError:
        print >> sys.stderr, 'Usage:'
        print >> sys.stderr, \
                '\tpython %s <reads.fq or reads.fq.gz> <genome.fa>' \
                % sys.argv[0]
        sys.exit(1)
    else:
        print >> sys.stderr, 'The output file is %s.psl' % sys.argv[1]

    blat_command = 'blat %s %s %s' % (db, infile, infile + '.psl')
    print >> sys.stderr, 'Running BLAT with:'
    print >> sys.stderr, '\t' + blat_command
    run_blat(infile)


if __name__=='__main__':
    main()

