module load picardTools/1.89
output=$(basename $1 .sam).bam
java -jar $PICARD/SortSam.jar INPUT=$1 OUTPUT=$output SORT_ORDER=coordinate
