#!/usr/bin/env python
'''Description'''
import sys
import subprocess


def run_blat(infile):
    '''run BLAT from command line'''

    subprocess.check_call(['blat', db, infile, outfile], shell=True)

def main():
    '''Main function'''

    try:
        unpair = sys.argv[1]
        db = sys.argv[2]
    except IndexError:
        print >> sys.stderr, 'Usage:'
        print >> sys.stderr, '\tpython %s <unpaired.fq> <genome.fa>' \
                % sys.argv[0]
        print >> sys.stderr, 'Note:'
        print >> sys.stderr, '\tunpaired.fq can be compressed in gzip format.'
        sys.exit(1)
    else:
        print >> sys.stderr, 'The output file is %s.psl' % sys.argv[1]

    blat_command = 'blat %s %s %s' % (db, unpair, unpair + '.psl')
    print >> sys.stderr, 'Running BLAT with:'
    print >> sys.stderr, '\t' + blat_command
    run_blat(unpair)


if __name__=='__main__':
    main()

