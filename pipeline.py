#!/usr/bin/env python
'''Description'''
import sys
import os
import subprocess
import gzip


def run_blat(infile, db):
    '''runs BLAT from a command line'''

    if infile.endswith('.gz'):
        query = infile.rstrip('.gz') + '.fa' #  create fasta file
        print >> sys.stderr, 'Gunzipping file...'
        infile = gzip.open(infile) # gunzip input file
    else:
        query = infile + '.fa'  # create fasta file
        infile = open(infile)

    op = open(query, 'w')
    n = 0
    for line in infile:
        if n == 0:
            op.write(line.replace('@', '>'))
        elif n == 1:
            op.write(line)
        if n < 3:
            n += 1
        else:
            n = 0
    op.close()

    outfile = query + '.psl'

    command = 'blat -noHead %s %s %s' % (db, query, outfile)
    subprocess.check_call(command, shell=True)


def process_blat_alns(pslfile):
    '''sorts and filters BLAT alignments'''

    sorted_file, ext = os.path.sepext(pslfile)
    sorted_file += '.sorted' + ext

    print >> sys.stderr, 'Sorting alignments...'
    command = 'sort -k 10 %s > %s' % (pslfile, sorted_file)
    subprocess.check_call(command, shell=True)

    filtered_file, ext = os.path.sepext(pslfile)
    filtered_file += '.filtered' + ext

    print >> sys.stderr, 'Filtering alignments...'
    command = 'pslReps -nohead -noIntrons -singleHit %s %s info' % \
            (sorted_file, filtered_file)
    subprocess.check_all(command, shell=True)

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
    run_blat(infile, db)


if __name__=='__main__':
    main()

