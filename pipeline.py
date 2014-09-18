#!/usr/bin/env python
'''Description'''
import sys
import os
import subprocess
import gzip
import find_indel


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
    return outfile


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
        infile1 = sys.argv[1]
        infile2 = sys.argv[2]
        db = sys.argv[3]
        samfile = sys.argv[4]
        expand = int(sys.argv[5])
        try:
            chrom = sys.argv[6]
        except IndexError:
            chrom = None
    except IndexError:
        print >> sys.stderr, 'Usage:'
        print >> sys.stderr, \
            '\tpython %s <reads.fq(.gz)> <genome.fa>' \
            ' <samfile> <expand> [chrom]' \
            % os.path.split(sys.argv[0])[-1]
        sys.exit(1)

    # blat_command = 'blat %s %s %s' % (db, infile1, infile1 + '.psl')
    # print >> sys.stderr, 'Running', blat_command
    # outfile1 = run_blat(infile1, db)
    # blat_command = 'blat %s %s %s' % (db, infile2, infile2 + '.psl')
    # print >> sys.stderr, 'Running', blat_command
    # outfile2 = run_blat(infile2, db)
    outfile1 = 'sample59_nonconcordantreads.1.fa.psl'
    outfile2 = 'sample59_nonconcordantreads.2.fa.psl'

    candidates = find_indel.find(samfile, chrom,
                            expand, outfile1,
                            outfile2)
    find_indel.indel_to_bed(candidates)


if __name__=='__main__':
    main()
