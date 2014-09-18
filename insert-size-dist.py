import pysam
import sys

samfile = pysam.Samfile(sys.argv[1], 'rb')

for read in samfile.fetch():
    if (read.is_read1 and read.mate_is_reverse
            and not read.mate_is_unmapped):
        dist = abs(read.pos - read.mpos)
        if read.pos < read.mpos:
            print '%s\t%d\t%d\t%d' % (
                samfile.getrname(read.rname), read.pos, read.mpos, dist)
        elif read.mpos < read.pos:
            print '%s\t%d\t%d\t%d' % (
                samfile.getrname(read.rname), read.mpos, read.pos, dist)
        else:
            continue
