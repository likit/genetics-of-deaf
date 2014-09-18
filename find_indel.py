import sys
import pysam

class Indel(object):
    def __init__(self, chrom, start, end):
        self.chrom = chrom
        self.start = start
        self.end = end
        self.supported_pe_reads = set()
        self.coverage = 0

    def __repr__(self):
        return "%s:%d-%d" % (self.chrom, self.start, self.end)


def find_indel(inpsl, insam, chrom, expand=1000):
    for line in open(inpsl):
        pe_reads = set()
        features = line.split()
        strand = features[8]

        if int(features[-4]) < 2:  # no gaps in an alignment
            continue

        tstart, tend = [int(i) for i in features[-1].split(',')[:2]]
        tblocks = [int(i) for i in features[-3].split(',')[:2]]
        tstart = tstart + tblocks[0]
        if strand == '-':
            continue
        # print tstart, tend, strand
        for r in insam.fetch(chrom, tstart - expand, tstart):
            if (r.mpos > tend - expand and r.mpos < tend + expand):
                pe_reads.add(r.qname)
        yield chrom, tstart, tend, pe_reads


def indel_to_bed(candidates):
    for indel in candidates.itervalues():
        print '%s\t%d\t%d\t.\t%d\t%d' % (indel.chrom,
                                        indel.start,
                                        indel.end,
                                        indel.coverage,
                                        len(indel.supported_pe_reads))

def find(samfile, chrom, expand, *pslfiles):
    samfile = pysam.Samfile(samfile, 'rb')
    candidates = {}
    for pslfile in pslfiles:
        for chrom, tstart, tend, pe_reads in \
                find_indel(pslfile, samfile, chrom, expand):
            if len(pe_reads) > 0:
                try:
                    indel = candidates["%s:%d-%d" %
                                    (chrom, tstart, tend)]
                except KeyError:
                    indel = Indel(chrom, tstart, tend)
                    candidates[repr(indel)] = indel

                indel.coverage += 1
                indel.supported_pe_reads.update(pe_reads)

    return candidates


def main():
    pslfile = sys.argv[1]
    samfile = sys.argv[2]
    expand = int(sys.argv[3])
    try:  # chromosome not specified: fetch reads from all chromosomes
        chrom = sys.argv[4]
    except IndexError:
        chrom = None

    candidates = find(pslfile, samfile, chrom, expand)
    indel_to_bed(candidates)  # dump all indels to standard output in BED


if __name__=='__main__':
    main()
