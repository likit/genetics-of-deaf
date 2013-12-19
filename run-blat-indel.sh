#!/bin/sh
genome=$1
input=$2
outdir=$3

# Run BLAT
test -d $outdir || exit 1
~/blat -dots=1000 -noHead $genome $input $outdir/$input.psl

# Sort and select alignments
cd $outdir
sorted_psl=$(basename $input.psl .psl).sorted.psl
filtered_psl=$(basename $input.psl .psl).flt.psl

printf "Sorting...\n"
sort -k 10 $input.psl > $sorted_psl
pslReps -nohead -noIntrons -singleHit $sorted_psl $filtered_psl info
rm $input.psl # not needed anymore

# Filter small indels
printf "Filtering...\n"
awk '$7<2' $filtered_psl | awk '$8>10000' > $(basename $filtered_psl .psl).large_ins.psl
cd -
