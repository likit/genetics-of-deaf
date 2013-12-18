import sys
import gzip

infile = sys.argv[1]
lineno = 1

pair = "/1\n" if "R1" in infile else "/2\n"
for line in gzip.open(infile):
    if lineno == 1:
        sys.stdout.write(
            line.split()[0].replace('@', '>', 1).strip('\n') + pair)
    if lineno == 2:
        sys.stdout.write(line)
    if lineno == 4:
        lineno = 0
    lineno += 1
